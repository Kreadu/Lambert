-- Lambert · 006 · diseños de baño guardados con un código (ej. BA-7K3Q) para retomarlos en otro equipo.
-- Pegar completo en Supabase → SQL Editor → Run, después de 005. Se puede correr más de una vez.
--
-- El público NO lee la tabla (tiene nombre y celular del cliente): guarda y abre diseños solo con las
-- funciones save_design / get_design. El administrador sí ve todos.

create table if not exists public.designs (
  id              uuid primary key default gen_random_uuid(),
  code            text not null unique,
  data            jsonb not null,
  total           numeric(14,2) not null default 0 check (total >= 0),
  customer_name   text not null default '',
  customer_phone  text not null default '',
  source          text not null default 'web' check (source in ('web', 'tienda')),
  created_at      timestamptz not null default now()
);
create index if not exists designs_created_idx on public.designs (created_at desc);
alter table public.designs enable row level security;

drop policy if exists "designs: admin lee y borra" on public.designs;
create policy "designs: admin lee y borra" on public.designs
  for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
grant select, delete on public.designs to authenticated;

-- Guardar: devuelve el código. Límites para que no se abuse de la tabla.
create or replace function public.save_design(
  p_data jsonb, p_total numeric, p_name text default '', p_phone text default '', p_source text default 'web'
)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'; -- sin 0/O ni 1/I/L
  v_code text;
begin
  if p_data is null or jsonb_typeof(p_data) <> 'object' then raise exception 'diseño inválido'; end if;
  if length(p_data::text) > 100000 then raise exception 'diseño demasiado grande'; end if;
  if coalesce(p_total, 0) < 0 or p_total > 1e12 then raise exception 'total inválido'; end if;
  loop
    v_code := 'BA-' || (select string_agg(substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1), '')
                        from generate_series(1, 4));
    exit when not exists (select 1 from public.designs where code = v_code);
  end loop;
  insert into public.designs (code, data, total, customer_name, customer_phone, source)
  values (v_code, p_data, coalesce(p_total, 0), left(coalesce(p_name, ''), 80), left(coalesce(p_phone, ''), 30),
          case when p_source = 'tienda' then 'tienda' else 'web' end);
  return v_code;
end;
$$;

-- Abrir por código: solo el diseño (sin datos del cliente).
create or replace function public.get_design(p_code text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select data from public.designs where code = upper(trim(p_code));
$$;

revoke execute on function public.save_design(jsonb, numeric, text, text, text) from public;
revoke execute on function public.get_design(text) from public;
grant execute on function public.save_design(jsonb, numeric, text, text, text) to anon, authenticated;
grant execute on function public.get_design(text) to anon, authenticated;
