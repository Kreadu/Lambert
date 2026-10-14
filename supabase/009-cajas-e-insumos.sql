-- Lambert · 009 · cerámica por cajas, pegante y boquilla en la cotización, y datos de la cotización impresa.
-- Pegar completo en Supabase → SQL Editor → Run, después de 008. Se puede correr más de una vez.

-- Cerámica: cuántos m² trae cada caja (la cotización redondea a cajas completas)
alter table public.products
  add column if not exists m2_per_box  numeric(6,3) check (m2_per_box > 0),
  -- insumos: cuántos m² rinde una unidad (un bulto de pegante, una bolsa de boquilla)
  add column if not exists coverage_m2 numeric(6,2) check (coverage_m2 > 0),
  -- insumos que la cotización agrega sola: pegante general, pegante para porcelanato / gran formato, boquilla
  add column if not exists supply_role text;
alter table public.products drop constraint if exists products_supply_role_check;
alter table public.products add constraint products_supply_role_check
  check (supply_role in ('adhesive', 'adhesive_porcelain', 'grout'));

-- Cotización impresa: validez y notas de cada tienda
alter table public.stores
  add column if not exists quote_validity_days int not null default 15 check (quote_validity_days between 1 and 365),
  add column if not exists quote_notes text not null default '';

-- ── Llenar con lo que ya dice la ficha técnica ──
-- "Piezas por caja": "8 (1,44 m²)" → 1.44
update public.products p
set m2_per_box = (
  select replace(substring(f ->> 'value' from '\(([0-9]+(?:[.,][0-9]+)?) *m'), ',', '.')::numeric
  from jsonb_array_elements(p.features) f
  where f ->> 'label' ilike 'piezas por caja' and substring(f ->> 'value' from '\(([0-9]+(?:[.,][0-9]+)?) *m') is not null
  limit 1)
where p.m2_per_box is null and p.placement = 'surface';

-- Pegantes: "Rendimiento": "≈ 4–5 m²" → 4 (el menor, para no quedarse corto)
update public.products p
set coverage_m2 = (
  select replace(substring(f ->> 'value' from '([0-9]+(?:[.,][0-9]+)?)'), ',', '.')::numeric
  from jsonb_array_elements(p.features) f
  where f ->> 'label' ilike 'rendimiento' and substring(f ->> 'value' from '([0-9]+(?:[.,][0-9]+)?)') is not null
  limit 1)
where p.coverage_m2 is null and p.category = 'pegantes';

-- Catálogo de muestra: qué insumo es cada uno (solo si nadie lo ha elegido todavía)
update public.products set supply_role = 'adhesive'
  where supply_role is null and category = 'pegantes' and name ilike 'Pegante cerámico interior%';
update public.products set supply_role = 'adhesive_porcelain'
  where supply_role is null and category = 'pegantes' and name ilike 'Pegante para porcelanato%';
update public.products set supply_role = 'grout', coverage_m2 = coalesce(coverage_m2, 5)
  where supply_role is null and category = 'pegantes' and name ilike 'Boquilla (fragüe) sin arena%';
-- rendimiento aproximado de las demás boquillas (junta de 2–3 mm en piezas medianas)
update public.products set coverage_m2 = 6 where coverage_m2 is null and category = 'pegantes' and name ilike 'Boquilla con arena 5 kg%';
update public.products set coverage_m2 = 3 where coverage_m2 is null and category = 'pegantes' and name ilike 'Boquilla epóxica 2 kg%';
