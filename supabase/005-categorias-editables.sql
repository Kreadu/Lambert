-- Lambert · 005 · categorías en una tabla: el administrador las crea y las elimina desde admin.html.
-- Pegar completo en Supabase → SQL Editor → Run, después de 004. Se puede correr más de una vez.

create table if not exists public.categories (
  slug        text primary key check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  label       text not null check (length(trim(label)) > 0),
  -- dónde van sus productos en el diseñador 3D: floor | wall | surface (cerámica) | none (no se dibuja)
  placement   text not null default 'floor' check (placement in ('floor', 'wall', 'surface', 'none')),
  position    int not null default 0,
  created_at  timestamptz not null default now()
);
alter table public.categories enable row level security;

drop policy if exists "categories: todos las ven" on public.categories;
create policy "categories: todos las ven" on public.categories for select using (true);

drop policy if exists "categories: admin escribe" on public.categories;
create policy "categories: admin escribe" on public.categories
  for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));

grant select on public.categories to anon, authenticated;
grant insert, update, delete on public.categories to authenticated;

-- las 12 de siempre (no pisa nombres que ya hayas cambiado)
insert into public.categories (slug, label, placement, position) values
  ('ceramica', 'Cerámica y baldosas', 'surface', 1),
  ('sanitarios', 'Sanitarios', 'floor', 2),
  ('lavamanos', 'Lavamanos', 'wall', 3),
  ('griferia', 'Grifería', 'wall', 4),
  ('duchas', 'Duchas', 'wall', 5),
  ('divisiones', 'Divisiones de baño', 'floor', 6),
  ('tinas', 'Tinas y platos de ducha', 'floor', 7),
  ('muebles', 'Muebles', 'floor', 8),
  ('espejos', 'Espejos', 'wall', 9),
  ('accesorios', 'Accesorios', 'wall', 10),
  ('instalacion', 'Instalación y plomería', 'none', 11),
  ('pegantes', 'Pegantes y boquillas', 'none', 12)
on conflict (slug) do nothing;

-- la lista fija pasa a ser una referencia a la tabla: no se puede eliminar una categoría con productos
alter table public.products drop constraint if exists products_category_check;
alter table public.products drop constraint if exists products_category_fkey;
alter table public.products add constraint products_category_fkey
  foreign key (category) references public.categories (slug) on update cascade on delete restrict;
