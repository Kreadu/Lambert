-- Lambert · 011 · seguimiento de los diseños guardados, límite para guardar diseños y tiendas inactivas.
-- Pegar completo en Supabase → SQL Editor → Run, después de 010. Se puede correr más de una vez.

-- ── Seguimiento: cada diseño guardado es un cliente para llamar ──
alter table public.designs
  add column if not exists status      text not null default 'nuevo',
  add column if not exists notes       text not null default '',
  add column if not exists client_hash text,          -- huella de la conexión (no la IP), para el límite
  add column if not exists updated_at  timestamptz not null default now();
alter table public.designs drop constraint if exists designs_status_check;
alter table public.designs add constraint designs_status_check
  check (status in ('nuevo', 'contactado', 'cotizado', 'vendido', 'descartado'));
alter table public.designs drop constraint if exists designs_notes_check;
alter table public.designs add constraint designs_notes_check check (length(notes) <= 1000);
create index if not exists designs_store_status_idx on public.designs (store_id, status, created_at desc);
create index if not exists designs_client_idx on public.designs (client_hash, created_at desc) where client_hash is not null;
-- la tienda cambia solo el estado y la nota (lo demás lo escribe save_design)
grant update (status, notes, updated_at) on public.designs to authenticated;

-- ── Guardar diseño, con límite: 30 por hora desde una misma conexión y 500 por hora por tienda ──
create or replace function public.save_design(
  p_store uuid, p_data jsonb, p_total numeric, p_name text default '', p_phone text default '', p_source text default 'web'
)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'; -- sin 0/O ni 1/I/L
  v_code text;
  v_ip text := split_part(coalesce(current_setting('request.headers', true)::json ->> 'x-forwarded-for', ''), ',', 1);
  v_hash text := case when v_ip <> '' then md5('lambert:' || trim(v_ip)) end;
begin
  if not exists (select 1 from public.stores where id = p_store and active) then raise exception 'tienda inválida'; end if;
  if p_data is null or jsonb_typeof(p_data) <> 'object' then raise exception 'diseño inválido'; end if;
  if length(p_data::text) > 100000 then raise exception 'diseño demasiado grande'; end if;
  if coalesce(p_total, 0) < 0 or p_total > 1e12 then raise exception 'total inválido'; end if;
  if v_hash is not null and (select count(*) from public.designs
      where client_hash = v_hash and created_at > now() - interval '1 hour') >= 30 then
    raise exception 'demasiados diseños: intenta más tarde';
  end if;
  if (select count(*) from public.designs where store_id = p_store and created_at > now() - interval '1 hour') >= 500 then
    raise exception 'demasiados diseños: intenta más tarde';
  end if;
  loop
    v_code := 'BA-' || (select string_agg(substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1), '')
                        from generate_series(1, 4));
    exit when not exists (select 1 from public.designs where code = v_code);
  end loop;
  insert into public.designs (store_id, code, data, total, customer_name, customer_phone, source, client_hash)
  values (p_store, v_code, p_data, coalesce(p_total, 0), left(coalesce(p_name, ''), 80), left(coalesce(p_phone, ''), 30),
          case when p_source = 'tienda' then 'tienda' else 'web' end, v_hash);
  return v_code;
end;
$$;
revoke execute on function public.save_design(uuid, jsonb, numeric, text, text, text) from public;
grant execute on function public.save_design(uuid, jsonb, numeric, text, text, text) to anon, authenticated;

-- ── Tiendas: solo la plataforma (Kreadu) activa o desactiva una tienda ──
create or replace function public.store_active_guard()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.active is distinct from old.active and not public.is_admin() then
    raise exception 'solo la plataforma activa o desactiva tiendas';
  end if;
  return new;
end;
$$;
drop trigger if exists store_active_guard on public.stores;
create trigger store_active_guard before update of active on public.stores
  for each row execute function public.store_active_guard();
