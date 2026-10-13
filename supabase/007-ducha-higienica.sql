-- Lambert · 007 · ducha higiénica ("ducha turca") y asientos bidé (GENERADO por tools/generar_catalogo.py).
-- Solo agrega estos productos; no toca el resto del catálogo. Se puede repetir.

begin;
delete from public.products where sku like 'DEMO-HIG-%' or sku like 'DEMO-BID-%';

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Ducha higiénica (turca) con manguera y soporte', 'duchas', 'Ducha higiénica', 'unidad', '', 'DEMO-HIG-001', 85000, 'Duchita de mano junto al sanitario para el aseo íntimo: la alternativa práctica al bidé. Gatillo para controlar el chorro.', '[{"label": "Manguera", "value": "1,2 m flexible"}, {"label": "Incluye", "value": "Ducha de mano, manguera y soporte de pared"}, {"label": "Agua", "value": "Fría"}]'::jsonb, 5, 18, 8, 'wall', null, null, null, 128) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-HIG-001-01', null, 30, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-HIG-001-02', 102000, 3, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-HIG-001-03', 98000, 29, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-HIG-001-04', 115000, 28, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-HIG-001-05', 115000, 19, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-HIG-001-06', 106000, 17, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-HIG-001-07', 102000, 9, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Kit ducha higiénica con llave de paso', 'duchas', 'Ducha higiénica', 'juego', '', 'DEMO-HIG-002', 140000, 'Ducha higiénica con su llave de paso angular: se conecta a la salida de agua del sanitario.', '[{"label": "Incluye", "value": "Ducha de mano, manguera 1,2 m, soporte y llave de paso 1/2\""}, {"label": "Agua", "value": "Fría"}]'::jsonb, 8, 18, 10, 'wall', null, null, null, 129) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-HIG-002-01', null, 37, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-HIG-002-02', 168000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-HIG-002-03', 161000, 0, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-HIG-002-04', 189000, 37, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-HIG-002-05', 189000, 42, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-HIG-002-06', 175000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-HIG-002-07', 168000, 32, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Kit ducha higiénica en T para sanitario (sin obra)', 'duchas', 'Ducha higiénica', 'juego', '', 'DEMO-HIG-003', 95000, 'Se instala con una T en la llave del tanque del sanitario, sin romper la pared.', '[{"label": "Incluye", "value": "T de conexión, ducha de mano, manguera y soporte"}, {"label": "Instalación", "value": "Sin obra"}]'::jsonb, 8, 18, 10, 'wall', null, null, null, 130) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-HIG-003-01', null, 7, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-HIG-003-02', 114000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-HIG-003-03', 109000, 7, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-HIG-003-04', 128000, 24, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Ducha higiénica con mezclador monocontrol de pared', 'duchas', 'Ducha higiénica', 'unidad', '', 'DEMO-HIG-004', 290000, 'Mezclador de agua fría y caliente a la vista, con su ducha higiénica.', '[{"label": "Agua", "value": "Fría y caliente"}, {"label": "Manguera", "value": "1,2 m"}]'::jsonb, 12, 20, 12, 'wall', null, null, null, 131) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-HIG-004-01', null, 4, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-HIG-004-02', 348000, 34, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-HIG-004-03', 334000, 19, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-HIG-004-04', 392000, 21, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-HIG-004-05', 392000, 8, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-HIG-004-06', 362000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-HIG-004-07', 348000, 38, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Ducha higiénica empotrada fría y caliente', 'duchas', 'Ducha higiénica', 'unidad', '', 'DEMO-HIG-005', 380000, 'Mezclador empotrado en la pared: solo se ven la manija, la salida y la ducha de mano.', '[{"label": "Agua", "value": "Fría y caliente"}, {"label": "Incluye", "value": "Cuerpo de empotrar"}]'::jsonb, 12, 12, 8, 'wall', null, null, null, 132) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-HIG-005-01', null, 35, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-HIG-005-02', 456000, 25, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-HIG-005-03', 437000, 31, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-HIG-005-04', 513000, 28, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-HIG-005-05', 513000, 41, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-HIG-005-06', 475000, 24, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-HIG-005-07', 456000, 0, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Ducha higiénica termostática empotrada', 'duchas', 'Ducha higiénica', 'unidad', '', 'DEMO-HIG-006', 520000, 'Mantiene la temperatura del agua estable: evita cambios bruscos de frío o calor.', '[{"label": "Agua", "value": "Fría y caliente, termostática"}, {"label": "Incluye", "value": "Cuerpo de empotrar"}]'::jsonb, 14, 14, 8, 'wall', null, null, null, 133) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-HIG-006-01', null, 27, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-HIG-006-02', 624000, 6, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-HIG-006-03', 598000, 0, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-HIG-006-04', 702000, 32, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Asiento bidé sin electricidad (agua fría)', 'sanitarios', 'Asiento bidé', 'unidad', '', 'DEMO-BID-001', 260000, 'Reemplaza la tapa del sanitario y le agrega un bidé con boquilla retráctil. No necesita conexión eléctrica.', '[{"label": "Boquillas", "value": "2 (trasera y femenina)"}, {"label": "Agua", "value": "Fría"}, {"label": "Cierre", "value": "Lento"}]'::jsonb, 36, 8, 48, 'none', null, null, null, 134) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-BID-001-01', null, 32, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-BID-001-02', 273000, 26, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Asiento bidé sin electricidad (agua fría y caliente)', 'sanitarios', 'Asiento bidé', 'unidad', '', 'DEMO-BID-002', 420000, 'Como el de agua fría, con mezcla de agua caliente para más comodidad.', '[{"label": "Boquillas", "value": "2 autolimpiables"}, {"label": "Agua", "value": "Fría y caliente"}, {"label": "Cierre", "value": "Lento"}]'::jsonb, 36, 8, 48, 'none', null, null, null, 135) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-BID-002-01', null, 29, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-BID-002-02', 441000, 33, 1);

commit;
