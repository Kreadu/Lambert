-- Lambert · 003 · más categorías (instalación, pegantes, divisiones), subcategoría y unidad de venta.
-- Pegar completo en Supabase → SQL Editor → Run, después de 002. Se puede correr más de una vez.

alter table public.products
  add column if not exists subcategory text not null default '',      -- ej: Porcelanato, One piece, Monocontrol
  add column if not exists unit        text not null default 'unidad'; -- cómo se vende

alter table public.products drop constraint if exists products_category_check;
alter table public.products add constraint products_category_check check (category in (
  'ceramica', 'sanitarios', 'lavamanos', 'griferia', 'duchas', 'divisiones', 'tinas', 'muebles',
  'espejos', 'accesorios', 'instalacion', 'pegantes'
));

-- none: no se dibuja en el diseñador 3D (plomería, pegantes), pero sí entra en la cotización
alter table public.products drop constraint if exists products_placement_check;
alter table public.products add constraint products_placement_check check (placement in ('floor', 'wall', 'surface', 'none'));

alter table public.products drop constraint if exists products_unit_check;
alter table public.products add constraint products_unit_check check (unit in (
  'unidad', 'm2', 'caja', 'bulto', 'kg', 'galon', 'metro', 'juego', 'tubo'
));

create index if not exists products_category_idx on public.products (category, subcategory);
