-- Lambert · 010 · materiales de instalación en la cotización y código de barras para ingresar inventario.
-- Pegar completo en Supabase → SQL Editor → Run, después de 009. Se puede correr más de una vez.

-- ── Código de barras del proveedor (EAN/UPC/Code 128), en cada color o variante ──
alter table public.product_variants add column if not exists barcode text
  check (barcode is null or barcode ~ '^[0-9A-Za-z. -]{1,64}$');
-- un código = una variante dentro de la tienda (otra tienda sí puede tener el mismo)
create unique index if not exists product_variants_store_barcode_key
  on public.product_variants (store_id, barcode) where barcode is not null;

-- ── Movimientos de inventario (ingresos con el escáner) ──
create table if not exists public.stock_movements (
  id          uuid primary key default gen_random_uuid(),
  store_id    uuid not null references public.stores (id) on delete cascade,
  variant_id  uuid not null references public.product_variants (id) on delete cascade,
  qty         int not null check (qty <> 0),
  kind        text not null default 'ingreso' check (kind in ('ingreso', 'ajuste')),
  note        text not null default '',
  created_by  uuid default auth.uid() references auth.users (id) on delete set null,
  created_at  timestamptz not null default now()
);
create index if not exists stock_movements_store_idx on public.stock_movements (store_id, created_at desc);
create index if not exists stock_movements_variant_idx on public.stock_movements (variant_id);
alter table public.stock_movements enable row level security;
drop policy if exists "stock_movements: la tienda lee" on public.stock_movements;
create policy "stock_movements: la tienda lee" on public.stock_movements
  for select to authenticated using ((select public.can_manage_store(store_id)));
grant select on public.stock_movements to authenticated;

-- Ingresar inventario: suma las cantidades al stock y deja el registro, todo o nada.
-- p_items: [{"variant_id": "…", "qty": 12}, …]
create or replace function public.add_stock(p_store uuid, p_items jsonb, p_note text default '')
returns int
language plpgsql
security definer
set search_path = ''
as $$
declare
  it jsonb;
  v_qty int;
  v_n int := 0;
begin
  if not public.can_manage_store(p_store) then raise exception 'sin permiso'; end if;
  if jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then raise exception 'sin productos'; end if;
  for it in select * from jsonb_array_elements(p_items) loop
    v_qty := (it ->> 'qty')::int;
    if v_qty is null or v_qty <= 0 or v_qty > 100000 then raise exception 'cantidad inválida'; end if;
    update public.product_variants
      set stock = stock + v_qty, updated_at = now()
      where id = (it ->> 'variant_id')::uuid and store_id = p_store;
    if not found then raise exception 'variante % no es de la tienda', it ->> 'variant_id'; end if;
    insert into public.stock_movements (store_id, variant_id, qty, kind, note)
    values (p_store, (it ->> 'variant_id')::uuid, v_qty, 'ingreso', left(coalesce(p_note, ''), 200));
    v_n := v_n + 1;
  end loop;
  return v_n;
end;
$$;
revoke execute on function public.add_stock(uuid, jsonb, text) from public;
grant execute on function public.add_stock(uuid, jsonb, text) to authenticated;

-- ── Materiales de instalación: qué lleva cada producto del baño (y el baño completo) ──
-- applies_to = slug de una categoría ("sanitarios": por cada sanitario) o '_bano' (una vez por diseño)
create table if not exists public.install_kits (
  id          uuid primary key default gen_random_uuid(),
  store_id    uuid not null references public.stores (id) on delete cascade,
  applies_to  text not null check (applies_to ~ '^(_bano|[a-z0-9]+(-[a-z0-9]+)*)$'),
  product_id  uuid not null references public.products (id) on delete cascade,
  qty         numeric(8,2) not null default 1 check (qty > 0),
  position    int not null default 0,
  created_at  timestamptz not null default now()
);
create index if not exists install_kits_store_idx on public.install_kits (store_id, applies_to, position);
create index if not exists install_kits_product_idx on public.install_kits (product_id);
alter table public.install_kits enable row level security;
drop policy if exists "install_kits: todos leen" on public.install_kits;
create policy "install_kits: todos leen" on public.install_kits for select using (true);
drop policy if exists "install_kits: la tienda escribe" on public.install_kits;
create policy "install_kits: la tienda escribe" on public.install_kits
  for all to authenticated using ((select public.can_manage_store(store_id))) with check ((select public.can_manage_store(store_id)));
grant select on public.install_kits to anon, authenticated;
grant insert, update, delete on public.install_kits to authenticated;

-- Kits de muestra para la tienda "lambert" (solo si todavía no tiene ninguno)
do $$
declare
  v_store uuid := (select id from public.stores where slug = 'lambert');
  r record;
begin
  if v_store is null or exists (select 1 from public.install_kits where store_id = v_store) then return; end if;
  for r in
    select * from (values
      ('sanitarios', 'Kit de anclaje para sanitario', 1, 1),
      ('sanitarios', 'Sello de cera para sanitario', 1, 2),
      ('sanitarios', 'Manguera flexible para sanitario%', 1, 3),
      ('sanitarios', 'Llave de paso angular%', 1, 4),
      ('lavamanos', 'Sifón flexible para lavamanos%', 1, 1),
      ('lavamanos', 'Desagüe push (clic-clac) con rebose', 1, 2),
      ('lavamanos', 'Llave de paso angular%', 2, 3),
      ('lavamanos', 'Manguera flexible para lavamanos%', 2, 4),
      ('muebles', 'Sifón flexible para lavamanos%', 1, 1),
      ('muebles', 'Desagüe push (clic-clac) con rebose', 1, 2),
      ('muebles', 'Llave de paso angular%', 2, 3),
      ('muebles', 'Manguera flexible para lavamanos%', 2, 4),
      ('tinas', 'Silicona antihongos%', 1, 1),
      ('griferia', 'Cinta teflón%', 1, 1),
      ('_bano', 'Tubo PVC presión 1/2"%', 2, 1),
      ('_bano', 'Tubo CPVC 1/2"%', 1, 2),
      ('_bano', 'Tubo PVC sanitario 2"%', 1, 3),
      ('_bano', 'Rejilla de piso cuadrada%', 1, 4),
      ('_bano', 'Cinta teflón%', 2, 5),
      ('_bano', 'Silicona antihongos%', 1, 6)
    ) as k(applies_to, name, qty, pos)
  loop
    insert into public.install_kits (store_id, applies_to, product_id, qty, position)
    select v_store, r.applies_to, p.id, r.qty, r.pos
    from public.products p
    where p.store_id = v_store and p.name ilike r.name
    order by p.name limit 1;
  end loop;
end $$;
