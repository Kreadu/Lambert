-- Lambert · catálogo de pruebas
-- Pegar completo en Supabase → SQL Editor → Run (se puede correr más de una vez).
-- Después: agrega tu correo como administrador (último bloque, al final del archivo).

create extension if not exists pgcrypto;

-- ── Administradores: solo estos correos pueden crear, editar y subir ──
create table if not exists public.admins (
  email text primary key
);
alter table public.admins enable row level security;
-- (sin políticas: nadie la lee ni la escribe desde la web; solo desde el SQL Editor)

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  -- Solo responde por quien llama (su correo del JWT, que pone Auth; no user_metadata).
  select exists (
    select 1 from public.admins
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;
grant execute on function public.is_admin() to anon, authenticated;

-- ── Productos ──
create table if not exists public.products (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (length(trim(name)) > 0),
  category    text not null default 'general',
  price       numeric(14,2) not null check (price >= 0),
  description text not null default '',
  features    jsonb not null default '[]'::jsonb,   -- [{"label":"Material","value":"Algodón"}]
  sizes       text[] not null default '{}',
  colors      text[] not null default '{}',          -- colores en hex: {"#000000","#f5f0e8"}
  active      boolean not null default true,
  position    int not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
alter table public.products enable row level security;

drop policy if exists "products: público ve los activos" on public.products;
create policy "products: público ve los activos" on public.products
  for select using (active or (select public.is_admin()));

drop policy if exists "products: admin escribe" on public.products;
create policy "products: admin escribe" on public.products
  for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));

-- ── Fotos y 3D de cada producto ──
-- kind: photo (fotos normales) · spin (fotos de la vista 360°, en orden) · model (archivo 3D .glb)
create table if not exists public.product_media (
  id          uuid primary key default gen_random_uuid(),
  product_id  uuid not null references public.products(id) on delete cascade,
  kind        text not null check (kind in ('photo', 'spin', 'model')),
  path        text not null,
  position    int not null default 0,
  created_at  timestamptz not null default now()
);
create index if not exists product_media_product_idx on public.product_media (product_id, kind, position);
alter table public.product_media enable row level security;

drop policy if exists "media: público ve la de productos activos" on public.product_media;
create policy "media: público ve la de productos activos" on public.product_media
  for select using (
    exists (select 1 from public.products p where p.id = product_id and (p.active or (select public.is_admin())))
  );

drop policy if exists "media: admin escribe" on public.product_media;
create policy "media: admin escribe" on public.product_media
  for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));

-- ── Acceso por la API (los proyectos nuevos pueden no exponer las tablas solos; RLS filtra las filas) ──
grant select on public.products, public.product_media to anon, authenticated;
grant insert, update, delete on public.products, public.product_media to authenticated;

-- ── Bucket de archivos (lectura pública, escritura solo admin) ──
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'catalogo', 'catalogo', true, 52428800,  -- 50 MB por archivo (límite del plan gratis)
  array['image/jpeg', 'image/png', 'image/webp', 'model/gltf-binary', 'application/octet-stream']
)
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

-- (borrar archivos exige poder leerlos en storage.objects; el público los ve por la URL pública)
drop policy if exists "catalogo: admin lee" on storage.objects;
create policy "catalogo: admin lee" on storage.objects
  for select to authenticated using (bucket_id = 'catalogo' and (select public.is_admin()));

drop policy if exists "catalogo: admin sube" on storage.objects;
create policy "catalogo: admin sube" on storage.objects
  for insert to authenticated with check (bucket_id = 'catalogo' and (select public.is_admin()));

drop policy if exists "catalogo: admin cambia" on storage.objects;
create policy "catalogo: admin cambia" on storage.objects
  for update to authenticated using (bucket_id = 'catalogo' and (select public.is_admin()));

drop policy if exists "catalogo: admin borra" on storage.objects;
create policy "catalogo: admin borra" on storage.objects
  for delete to authenticated using (bucket_id = 'catalogo' and (select public.is_admin()));

-- ── Tu correo como administrador (cámbialo y corre solo esta línea) ──
-- insert into public.admins (email) values ('tu-correo@ejemplo.com') on conflict do nothing;
