-- Lambert · 002 · catálogo de baño: categorías fijas, medidas, cerámica y variantes con stock.
-- Pegar completo en Supabase → SQL Editor → Run, después de setup.sql. Se puede correr más de una vez.
-- Pensado para conectarse a Miel más adelante: cada variante tiene su propio SKU.

-- ── Productos: datos de baño ──
alter table public.products
  drop column if exists sizes,
  drop column if exists colors,
  add column if not exists brand          text not null default '',
  add column if not exists sku            text,
  add column if not exists width_cm       numeric(7,1) check (width_cm > 0),
  add column if not exists height_cm      numeric(7,1) check (height_cm > 0),
  add column if not exists depth_cm       numeric(7,1) check (depth_cm > 0),
  -- dónde va en el diseñador 3D: piso (WC, mueble, tina), pared (lavamanos suspendido, espejo,
  -- grifería, ducha) o superficie (cerámica que cubre piso o paredes)
  add column if not exists placement      text not null default 'floor',
  -- solo cerámica: tamaño de la pieza y dónde se puede usar
  add column if not exists tile_width_cm  numeric(6,1) check (tile_width_cm > 0),
  add column if not exists tile_height_cm numeric(6,1) check (tile_height_cm > 0),
  add column if not exists surface_use    text;

alter table public.products alter column category set default 'accesorios';

alter table public.products drop constraint if exists products_category_check;
alter table public.products add constraint products_category_check check (category in (
  'ceramica', 'sanitarios', 'lavamanos', 'duchas', 'griferia', 'muebles', 'espejos', 'tinas', 'accesorios'
));
alter table public.products drop constraint if exists products_placement_check;
alter table public.products add constraint products_placement_check check (placement in ('floor', 'wall', 'surface'));
alter table public.products drop constraint if exists products_surface_use_check;
alter table public.products add constraint products_surface_use_check check (surface_use in ('floor', 'wall', 'both'));

-- ── Variantes: color o acabado, cada una con su SKU, precio y stock ──
create table if not exists public.product_variants (
  id           uuid primary key default gen_random_uuid(),
  product_id   uuid not null references public.products(id) on delete cascade,
  name         text not null check (length(trim(name)) > 0),   -- ej: "Blanco brillante"
  color_hex    text check (color_hex ~ '^#[0-9a-fA-F]{6}$'),    -- color para pintar el modelo 3D
  finish       text not null default '',                        -- ej: brillante, mate, satinado
  sku          text,
  price        numeric(14,2) check (price >= 0),                -- vacío = precio del producto
  stock        int not null default 0 check (stock >= 0),
  texture_path text,                                            -- cerámica: foto de la pieza para el 3D
  active       boolean not null default true,
  position     int not null default 0,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index if not exists product_variants_product_idx on public.product_variants (product_id, position);
create unique index if not exists product_variants_sku_key on public.product_variants (sku) where sku is not null and sku <> '';
alter table public.product_variants enable row level security;

drop policy if exists "variants: público ve las de productos activos" on public.product_variants;
create policy "variants: público ve las de productos activos" on public.product_variants
  for select using (
    (select public.is_admin())
    or (active and exists (select 1 from public.products p where p.id = product_id and p.active))
  );

drop policy if exists "variants: admin escribe" on public.product_variants;
create policy "variants: admin escribe" on public.product_variants
  for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));

grant select on public.product_variants to anon, authenticated;
grant insert, update, delete on public.product_variants to authenticated;
