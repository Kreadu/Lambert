-- Lambert · 012 · sedes: cada tienda puede tener varios puntos de venta, cada uno con su propio stock
-- (y, si quiere, su propio precio). El cliente elige "Comprando en: …" en el catálogo y el diseñador.
-- Si una sede no tiene dato para un color, se usan el stock y el precio generales.
-- Pegar completo en Supabase → SQL Editor → Run, después de 011. Se puede correr más de una vez.

create table if not exists public.store_branches (
  id           uuid primary key default gen_random_uuid(),
  store_id     uuid not null references public.stores (id) on delete cascade,
  name         text not null check (length(trim(name)) between 1 and 80),
  city         text not null default '' check (length(city) <= 80),
  address      text not null default '' check (length(address) <= 200),
  whatsapp_cc  text not null default '57' check (whatsapp_cc ~ '^[0-9]{1,4}$'),
  whatsapp     text not null default '' check (whatsapp ~ '^[0-9]{0,15}$'),  -- vacío = el WhatsApp de la tienda
  position     int not null default 0,
  active       boolean not null default true,
  created_at   timestamptz not null default now()
);
create index if not exists store_branches_store_idx on public.store_branches (store_id, position);
alter table public.store_branches enable row level security;
drop policy if exists "branches: público ve las activas" on public.store_branches;
create policy "branches: público ve las activas" on public.store_branches
  for select using (active or (select public.can_manage_store(store_id)));
drop policy if exists "branches: la tienda escribe" on public.store_branches;
create policy "branches: la tienda escribe" on public.store_branches
  for all to authenticated using ((select public.can_manage_store(store_id))) with check ((select public.can_manage_store(store_id)));
grant select on public.store_branches to anon, authenticated;
grant insert, update, delete on public.store_branches to authenticated;

-- stock (y precio opcional) de cada color en cada sede
create table if not exists public.branch_stock (
  branch_id   uuid not null references public.store_branches (id) on delete cascade,
  variant_id  uuid not null references public.product_variants (id) on delete cascade,
  store_id    uuid not null references public.stores (id) on delete cascade,
  stock       int not null default 0 check (stock >= 0),
  price       numeric(14,2) check (price >= 0),          -- vacío = el precio general
  updated_at  timestamptz not null default now(),
  primary key (branch_id, variant_id)
);
create index if not exists branch_stock_variant_idx on public.branch_stock (variant_id);
create index if not exists branch_stock_store_idx on public.branch_stock (store_id);

-- la tienda de la fila sale de la sede, y el color tiene que ser de esa misma tienda
create or replace function public.branch_stock_store()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.store_id := (select b.store_id from public.store_branches b where b.id = new.branch_id);
  if not exists (select 1 from public.product_variants v where v.id = new.variant_id and v.store_id = new.store_id) then
    raise exception 'El color no es de la tienda de esta sede';
  end if;
  new.updated_at := now();
  return new;
end;
$$;
drop trigger if exists branch_stock_store on public.branch_stock;
create trigger branch_stock_store before insert or update on public.branch_stock
  for each row execute function public.branch_stock_store();

alter table public.branch_stock enable row level security;
drop policy if exists "branch_stock: todos leen" on public.branch_stock;
create policy "branch_stock: todos leen" on public.branch_stock for select using (true);
drop policy if exists "branch_stock: la tienda escribe" on public.branch_stock;
create policy "branch_stock: la tienda escribe" on public.branch_stock
  for all to authenticated using ((select public.can_manage_store(store_id))) with check ((select public.can_manage_store(store_id)));
grant select on public.branch_stock to anon, authenticated;
grant insert, update, delete on public.branch_stock to authenticated;

-- Sedes de muestra para la tienda "lambert" (solo si todavía no tiene ninguna):
-- Norte usa el stock general; en Centro se agota uno de cada tres colores, para ver la diferencia.
do $$
declare
  v_store uuid := (select id from public.stores where slug = 'lambert');
  v_centro uuid;
begin
  if v_store is null or exists (select 1 from public.store_branches where store_id = v_store) then return; end if;
  insert into public.store_branches (store_id, name, city, address, position)
    values (v_store, 'Sede Norte', 'Bogotá', 'Autopista Norte con calle 170', 0);
  insert into public.store_branches (store_id, name, city, address, position)
    values (v_store, 'Sede Centro', 'Bogotá', 'Carrera 10 con calle 13', 1)
    returning id into v_centro;
  insert into public.branch_stock (branch_id, variant_id, store_id, stock)
    select v_centro, v.id, v_store, case when row_number() over (order by v.created_at, v.id) % 3 = 0 then 0 else greatest(v.stock / 2, 1) end
    from public.product_variants v where v.store_id = v_store;
end $$;
