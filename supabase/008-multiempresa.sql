-- Lambert · 008 · varias empresas (tiendas) en la misma plataforma.
-- Pegar completo en Supabase → SQL Editor → Run, después de 007. Se puede correr más de una vez.
--
-- Cada tienda tiene sus datos (nombre, logo, país, moneda, WhatsApp), su catálogo, sus categorías y sus
-- diseños, y no ve los de las demás. Los productos, categorías y diseños que ya existen pasan a la tienda
-- "lambert". La tabla `admins` sigue siendo la de los administradores de la plataforma (Kreadu): ven y
-- administran todas las tiendas y son los únicos que crean tiendas nuevas (con la función `crear-tienda`).

-- ── Tiendas ──
create table if not exists public.stores (
  id           uuid primary key default gen_random_uuid(),
  slug         text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),  -- va en la dirección: ?t=lambert
  name         text not null check (length(trim(name)) > 0),
  legal_name   text not null default '',
  tax_id       text not null default '',                                         -- NIT, RUT, RFC…
  email        text not null default '',
  phone_cc     text not null default '57' check (phone_cc ~ '^[0-9]{1,4}$'),     -- código de país, sin +
  phone        text not null default '' check (phone ~ '^[0-9]{0,15}$'),
  whatsapp_cc  text not null default '57' check (whatsapp_cc ~ '^[0-9]{1,4}$'),
  whatsapp     text not null default '' check (whatsapp ~ '^[0-9]{0,15}$'),     -- vacío = sin "Hablar con un asesor"
  address      text not null default '',
  city         text not null default '',
  country      text not null default 'CO' check (country ~ '^[A-Z]{2}$'),       -- ISO 3166 (CO, MX, PE…)
  currency     text not null default 'COP' check (currency ~ '^[A-Z]{3}$'),     -- ISO 4217 (COP, MXN, USD…)
  website      text not null default '',
  logo_path    text,
  active       boolean not null default true,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
alter table public.stores enable row level security;

create table if not exists public.store_members (
  store_id    uuid not null references public.stores (id) on delete cascade,
  user_id     uuid not null references auth.users (id) on delete cascade,
  role        text not null default 'owner' check (role in ('owner', 'staff')),
  created_at  timestamptz not null default now(),
  primary key (store_id, user_id)
);
create index if not exists store_members_user_idx on public.store_members (user_id);
alter table public.store_members enable row level security;

-- ¿Puede el usuario actual administrar esta tienda? (plataforma o miembro de la tienda)
create or replace function public.can_manage_store(p_store uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.is_admin()
      or exists (select 1 from public.store_members m where m.store_id = p_store and m.user_id = auth.uid());
$$;
revoke execute on function public.can_manage_store(uuid) from public;
grant execute on function public.can_manage_store(uuid) to anon, authenticated;

-- La tienda que ya existía
insert into public.stores (slug, name) values ('lambert', 'Lambert') on conflict (slug) do nothing;

-- ── Columna store_id en lo que ya existe ──
alter table public.categories      add column if not exists store_id uuid references public.stores (id) on delete cascade;
alter table public.products        add column if not exists store_id uuid references public.stores (id) on delete cascade;
alter table public.product_variants add column if not exists store_id uuid references public.stores (id) on delete cascade;
alter table public.designs         add column if not exists store_id uuid references public.stores (id) on delete cascade;

update public.categories set store_id = (select id from public.stores where slug = 'lambert') where store_id is null;
update public.products   set store_id = (select id from public.stores where slug = 'lambert') where store_id is null;
update public.designs    set store_id = (select id from public.stores where slug = 'lambert') where store_id is null;
update public.product_variants v set store_id = p.store_id from public.products p where p.id = v.product_id and v.store_id is null;

alter table public.categories       alter column store_id set not null;
alter table public.products         alter column store_id set not null;
alter table public.product_variants alter column store_id set not null;
alter table public.designs          alter column store_id set not null;

-- Categorías por tienda: la clave pasa de (slug) a (store_id, slug)
alter table public.products drop constraint if exists products_category_fkey;
alter table public.categories drop constraint if exists categories_pkey;
alter table public.categories add constraint categories_pkey primary key (store_id, slug);
alter table public.products add constraint products_category_fkey
  foreign key (store_id, category) references public.categories (store_id, slug) on update cascade;

-- La referencia (SKU) se repite entre tiendas (dos tiendas venden el mismo sanitario): única por tienda
drop index if exists public.product_variants_sku_key;
create unique index if not exists product_variants_store_sku_key on public.product_variants (store_id, sku)
  where sku is not null and sku <> '';

create index if not exists products_store_idx on public.products (store_id, position);
create index if not exists product_variants_store_idx on public.product_variants (store_id);
create index if not exists designs_store_idx on public.designs (store_id, created_at desc);

-- La variante toma la tienda de su producto (el navegador no tiene que enviarla)
create or replace function public.variant_store()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.store_id := (select p.store_id from public.products p where p.id = new.product_id);
  return new;
end;
$$;
drop trigger if exists variant_store on public.product_variants;
create trigger variant_store before insert or update of product_id on public.product_variants
  for each row execute function public.variant_store();

-- Una tienda nueva empieza con las categorías de baño de siempre
create or replace function public.store_default_categories()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.categories (store_id, slug, label, placement, position) values
    (new.id, 'ceramica', 'Cerámica y baldosas', 'surface', 1),
    (new.id, 'sanitarios', 'Sanitarios', 'floor', 2),
    (new.id, 'lavamanos', 'Lavamanos', 'wall', 3),
    (new.id, 'griferia', 'Grifería', 'wall', 4),
    (new.id, 'duchas', 'Duchas', 'wall', 5),
    (new.id, 'divisiones', 'Divisiones de baño', 'floor', 6),
    (new.id, 'tinas', 'Tinas y platos de ducha', 'floor', 7),
    (new.id, 'muebles', 'Muebles', 'floor', 8),
    (new.id, 'espejos', 'Espejos', 'wall', 9),
    (new.id, 'accesorios', 'Accesorios', 'wall', 10),
    (new.id, 'instalacion', 'Instalación y plomería', 'none', 11),
    (new.id, 'pegantes', 'Pegantes y boquillas', 'none', 12)
  on conflict do nothing;
  return new;
end;
$$;
drop trigger if exists store_default_categories on public.stores;
create trigger store_default_categories after insert on public.stores
  for each row execute function public.store_default_categories();

-- ── Permisos (RLS) ──
drop policy if exists "stores: público ve las activas" on public.stores;
create policy "stores: público ve las activas" on public.stores
  for select using (active or (select public.can_manage_store(id)));
drop policy if exists "stores: la tienda edita sus datos" on public.stores;
create policy "stores: la tienda edita sus datos" on public.stores
  for update to authenticated using ((select public.can_manage_store(id))) with check ((select public.can_manage_store(id)));
drop policy if exists "stores: plataforma crea y borra" on public.stores;
create policy "stores: plataforma crea y borra" on public.stores
  for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
grant select on public.stores to anon, authenticated;
grant insert, update, delete on public.stores to authenticated;

drop policy if exists "store_members: cada uno ve los suyos" on public.store_members;
create policy "store_members: cada uno ve los suyos" on public.store_members
  for select to authenticated using (user_id = (select auth.uid()) or (select public.is_admin()));
grant select on public.store_members to authenticated;

drop policy if exists "categories: admin escribe" on public.categories;
drop policy if exists "categories: la tienda escribe" on public.categories;
create policy "categories: la tienda escribe" on public.categories
  for all to authenticated using ((select public.can_manage_store(store_id))) with check ((select public.can_manage_store(store_id)));

drop policy if exists "products: público ve los activos" on public.products;
create policy "products: público ve los activos" on public.products
  for select using (active or (select public.can_manage_store(store_id)));
drop policy if exists "products: admin escribe" on public.products;
drop policy if exists "products: la tienda escribe" on public.products;
create policy "products: la tienda escribe" on public.products
  for all to authenticated using ((select public.can_manage_store(store_id))) with check ((select public.can_manage_store(store_id)));

drop policy if exists "media: público ve la de productos activos" on public.product_media;
create policy "media: público ve la de productos activos" on public.product_media
  for select using (
    exists (select 1 from public.products p where p.id = product_id and (p.active or (select public.can_manage_store(p.store_id))))
  );
drop policy if exists "media: admin escribe" on public.product_media;
drop policy if exists "media: la tienda escribe" on public.product_media;
create policy "media: la tienda escribe" on public.product_media
  for all to authenticated
  using (exists (select 1 from public.products p where p.id = product_id and (select public.can_manage_store(p.store_id))))
  with check (exists (select 1 from public.products p where p.id = product_id and (select public.can_manage_store(p.store_id))));

drop policy if exists "variants: público ve las de productos activos" on public.product_variants;
create policy "variants: público ve las de productos activos" on public.product_variants
  for select using (
    (select public.can_manage_store(store_id))
    or (active and exists (select 1 from public.products p where p.id = product_id and p.active))
  );
drop policy if exists "variants: admin escribe" on public.product_variants;
drop policy if exists "variants: la tienda escribe" on public.product_variants;
create policy "variants: la tienda escribe" on public.product_variants
  for all to authenticated using ((select public.can_manage_store(store_id))) with check ((select public.can_manage_store(store_id)));

drop policy if exists "designs: admin lee y borra" on public.designs;
drop policy if exists "designs: la tienda lee y borra" on public.designs;
create policy "designs: la tienda lee y borra" on public.designs
  for all to authenticated using ((select public.can_manage_store(store_id))) with check ((select public.can_manage_store(store_id)));

-- ── Archivos: <producto>/… (fotos, 360°, 3D, texturas) y stores/<tienda>/… (logo) ──
create or replace function public.can_manage_file(p_name text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select case
    when (storage.foldername(p_name))[1] = 'stores' then exists (
      select 1 from public.stores s where s.id::text = (storage.foldername(p_name))[2] and public.can_manage_store(s.id))
    else exists (
      select 1 from public.products p where p.id::text = (storage.foldername(p_name))[1] and public.can_manage_store(p.store_id))
  end;
$$;
revoke execute on function public.can_manage_file(text) from public;
grant execute on function public.can_manage_file(text) to authenticated;

drop policy if exists "catalogo: admin lee" on storage.objects;
create policy "catalogo: admin lee" on storage.objects
  for select to authenticated using (bucket_id = 'catalogo' and public.can_manage_file(name));
drop policy if exists "catalogo: admin sube" on storage.objects;
create policy "catalogo: admin sube" on storage.objects
  for insert to authenticated with check (bucket_id = 'catalogo' and public.can_manage_file(name));
drop policy if exists "catalogo: admin cambia" on storage.objects;
create policy "catalogo: admin cambia" on storage.objects
  for update to authenticated using (bucket_id = 'catalogo' and public.can_manage_file(name));
drop policy if exists "catalogo: admin borra" on storage.objects;
create policy "catalogo: admin borra" on storage.objects
  for delete to authenticated using (bucket_id = 'catalogo' and public.can_manage_file(name));

-- ── Diseños: se guardan con la tienda ──
drop function if exists public.save_design(jsonb, numeric, text, text, text);
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
begin
  if not exists (select 1 from public.stores where id = p_store and active) then raise exception 'tienda inválida'; end if;
  if p_data is null or jsonb_typeof(p_data) <> 'object' then raise exception 'diseño inválido'; end if;
  if length(p_data::text) > 100000 then raise exception 'diseño demasiado grande'; end if;
  if coalesce(p_total, 0) < 0 or p_total > 1e12 then raise exception 'total inválido'; end if;
  loop
    v_code := 'BA-' || (select string_agg(substr(alphabet, 1 + floor(random() * length(alphabet))::int, 1), '')
                        from generate_series(1, 4));
    exit when not exists (select 1 from public.designs where code = v_code);
  end loop;
  insert into public.designs (store_id, code, data, total, customer_name, customer_phone, source)
  values (p_store, v_code, p_data, coalesce(p_total, 0), left(coalesce(p_name, ''), 80), left(coalesce(p_phone, ''), 30),
          case when p_source = 'tienda' then 'tienda' else 'web' end);
  return v_code;
end;
$$;
revoke execute on function public.save_design(uuid, jsonb, numeric, text, text, text) from public;
grant execute on function public.save_design(uuid, jsonb, numeric, text, text, text) to anon, authenticated;

-- Abrir por código: el diseño y la tienda donde se hizo (para abrirlo con su catálogo y su moneda)
create or replace function public.get_design(p_code text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select d.data || jsonb_build_object('store', s.slug)
  from public.designs d join public.stores s on s.id = d.store_id
  where d.code = upper(trim(p_code));
$$;
