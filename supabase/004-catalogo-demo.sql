-- Lambert · 004 · catálogo de referencia de baño (GENERADO por tools/generar_catalogo.py; no editar a mano).
-- Productos genéricos con modelos, medidas y colores comunes. PRECIOS de referencia aproximada en COP y STOCK de prueba:
-- reemplázalos por los reales desde admin.html. Correr después de 003. Se puede repetir: borra y recarga solo los DEMO-.

begin;
delete from public.products where sku like 'DEMO-%';

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Porcelanato liso 60×60', 'ceramica', 'Porcelanato', 'm2', '', 'DEMO-CER-001', 62000, 'Porcelanato esmaltado de formato cuadrado, para piso y pared. Junta mínima de 2 mm.', '[{"label": "Espesor", "value": "9 mm"}, {"label": "Tráfico", "value": "Alto (PEI 4)"}, {"label": "Absorción", "value": "< 0,5 %"}, {"label": "Piezas por caja", "value": "4 (1,44 m²)"}]'::jsonb, null, null, null, 'surface', 60, 60, 'both', 1) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f1f1ee', 'mate', 'DEMO-CER-001-01', null, 28, 0),
  ((select id from p), 'Gris claro', '#c9c9c6', 'mate', 'DEMO-CER-001-02', null, 13, 1),
  ((select id from p), 'Gris oscuro', '#6b6b6b', 'mate', 'DEMO-CER-001-03', null, 10, 2),
  ((select id from p), 'Beige', '#d9c9ad', 'mate', 'DEMO-CER-001-04', null, 25, 3),
  ((select id from p), 'Negro', '#2a2a2a', 'mate', 'DEMO-CER-001-05', 68000, 7, 4),
  ((select id from p), 'Blanco brillante', '#f6f6f4', 'brillante', 'DEMO-CER-001-06', 65000, 12, 5);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Porcelanato tipo mármol 60×120', 'ceramica', 'Porcelanato', 'm2', '', 'DEMO-CER-002', 118000, 'Gran formato con veta de mármol. Pocas juntas: el baño se ve más amplio.', '[{"label": "Espesor", "value": "9 mm"}, {"label": "Rectificado", "value": "Sí"}, {"label": "Piezas por caja", "value": "2 (1,44 m²)"}]'::jsonb, null, null, null, 'surface', 60, 120, 'both', 2) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Carrara', '#e9e9e6', 'brillante', 'DEMO-CER-002-01', null, 29, 0),
  ((select id from p), 'Calacatta', '#efe9df', 'brillante', 'DEMO-CER-002-02', 130000, 0, 1),
  ((select id from p), 'Negro Marquina', '#1c1c1c', 'brillante', 'DEMO-CER-002-03', 136000, 4, 2),
  ((select id from p), 'Travertino', '#d8c7a8', 'mate', 'DEMO-CER-002-04', 124000, 28, 3),
  ((select id from p), 'Gris Pulpis', '#8a8580', 'mate', 'DEMO-CER-002-05', 124000, 8, 4);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Porcelanato tipo madera 20×120', 'ceramica', 'Porcelanato', 'm2', '', 'DEMO-CER-003', 79000, 'Tablón con textura de madera, cálido y resistente al agua.', '[{"label": "Espesor", "value": "9 mm"}, {"label": "Antideslizante", "value": "R10"}, {"label": "Piezas por caja", "value": "6 (1,44 m²)"}]'::jsonb, null, null, null, 'surface', 20, 120, 'floor', 3) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-CER-003-01', null, 34, 0),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-CER-003-02', null, 32, 1),
  ((select id from p), 'Gris ceniza', '#9a948c', 'texturizado', 'DEMO-CER-003-03', null, 26, 2),
  ((select id from p), 'Miel', '#b98a52', 'texturizado', 'DEMO-CER-003-04', null, 18, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Porcelanato tipo cemento 60×60', 'ceramica', 'Porcelanato', 'm2', '', 'DEMO-CER-004', 66000, 'Acabado de cemento pulido, estilo industrial.', '[{"label": "Espesor", "value": "9 mm"}, {"label": "Tráfico", "value": "Alto"}, {"label": "Piezas por caja", "value": "4 (1,44 m²)"}]'::jsonb, null, null, null, 'surface', 60, 60, 'both', 4) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cemento claro', '#b9b6af', 'mate', 'DEMO-CER-004-01', null, 40, 0),
  ((select id from p), 'Cemento gris', '#8f8d88', 'mate', 'DEMO-CER-004-02', null, 28, 1),
  ((select id from p), 'Antracita', '#4b4b4a', 'mate', 'DEMO-CER-004-03', null, 16, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Cerámica de pared 30×60', 'ceramica', 'Cerámica de pared', 'm2', '', 'DEMO-CER-005', 39000, 'Revestimiento de pared para zonas húmedas. Fácil de cortar e instalar.', '[{"label": "Espesor", "value": "8 mm"}, {"label": "Piezas por caja", "value": "8 (1,44 m²)"}]'::jsonb, null, null, null, 'surface', 30, 60, 'wall', 5) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco brillante', '#f6f6f4', 'brillante', 'DEMO-CER-005-01', null, 21, 0),
  ((select id from p), 'Blanco mate', '#efefec', 'mate', 'DEMO-CER-005-02', null, 16, 1),
  ((select id from p), 'Gris perla', '#d2d2cf', 'mate', 'DEMO-CER-005-03', null, 27, 2),
  ((select id from p), 'Beige arena', '#ddd0b8', 'mate', 'DEMO-CER-005-04', null, 38, 3),
  ((select id from p), 'Blanco con relieve', '#f1f1ee', 'relieve', 'DEMO-CER-005-05', 45000, 20, 4);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Cerámica de pared 25×40', 'ceramica', 'Cerámica de pared', 'm2', '', 'DEMO-CER-006', 29000, 'Formato económico y clásico para paredes de baño.', '[{"label": "Espesor", "value": "7 mm"}, {"label": "Piezas por caja", "value": "15 (1,5 m²)"}]'::jsonb, null, null, null, 'surface', 25, 40, 'wall', 6) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f6f6f4', 'brillante', 'DEMO-CER-006-01', null, 9, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-CER-006-02', null, 39, 1),
  ((select id from p), 'Gris', '#c9c9c6', 'brillante', 'DEMO-CER-006-03', null, 20, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Cerámica de piso 45×45', 'ceramica', 'Cerámica de piso', 'm2', '', 'DEMO-CER-007', 34000, 'Piso cerámico de tráfico medio, económico.', '[{"label": "Tráfico", "value": "Medio (PEI 3)"}, {"label": "Piezas por caja", "value": "10 (2,02 m²)"}]'::jsonb, null, null, null, 'surface', 45, 45, 'floor', 7) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#efefec', 'mate', 'DEMO-CER-007-01', null, 19, 0),
  ((select id from p), 'Beige', '#d9c9ad', 'mate', 'DEMO-CER-007-02', null, 40, 1),
  ((select id from p), 'Gris', '#a9a9a6', 'mate', 'DEMO-CER-007-03', null, 4, 2),
  ((select id from p), 'Tipo piedra', '#b3a891', 'rústico', 'DEMO-CER-007-04', 36000, 24, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Piso antideslizante para ducha 30×30', 'ceramica', 'Antideslizante', 'm2', '', 'DEMO-CER-008', 48000, 'Baldosa con textura antideslizante para la zona de ducha.', '[{"label": "Antideslizante", "value": "R11"}, {"label": "Piezas por caja", "value": "11 (1 m²)"}]'::jsonb, null, null, null, 'surface', 30, 30, 'floor', 8) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#efefec', 'antideslizante', 'DEMO-CER-008-01', null, 7, 0),
  ((select id from p), 'Gris', '#9c9c99', 'antideslizante', 'DEMO-CER-008-02', null, 36, 1),
  ((select id from p), 'Beige', '#d9c9ad', 'antideslizante', 'DEMO-CER-008-03', null, 26, 2),
  ((select id from p), 'Negro', '#2a2a2a', 'antideslizante', 'DEMO-CER-008-04', 50000, 30, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Subway metro 7,5×15', 'ceramica', 'Subway / metro', 'm2', '', 'DEMO-CER-009', 85000, 'Ladrillo biselado tipo metro, ideal para la pared de la ducha o detrás del lavamanos.', '[{"label": "Biselado", "value": "Sí"}, {"label": "m² por caja", "value": "0,5"}]'::jsonb, null, null, null, 'surface', 15, 7.5, 'wall', 9) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f6f6f4', 'brillante', 'DEMO-CER-009-01', null, 34, 0),
  ((select id from p), 'Negro', '#1f1f1f', 'brillante', 'DEMO-CER-009-02', null, 7, 1),
  ((select id from p), 'Verde botella', '#3f6650', 'brillante', 'DEMO-CER-009-03', 89000, 13, 2),
  ((select id from p), 'Azul petróleo', '#2f5566', 'brillante', 'DEMO-CER-009-04', 89000, 0, 3),
  ((select id from p), 'Rosa empolvado', '#e3c4bd', 'brillante', 'DEMO-CER-009-05', 89000, 0, 4),
  ((select id from p), 'Gris', '#a5a7a8', 'mate', 'DEMO-CER-009-06', null, 28, 5);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mosaico de vidrio 30×30 (malla)', 'ceramica', 'Mosaico', 'm2', '', 'DEMO-CER-010', 95000, 'Pastillas de vidrio en malla, para franjas decorativas y nichos.', '[{"label": "Pastilla", "value": "2,5 × 2,5 cm"}, {"label": "Mallas por m²", "value": "11"}]'::jsonb, null, null, null, 'surface', 30, 30, 'wall', 10) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Azul mar', '#3d7ea6', 'vidrio', 'DEMO-CER-010-01', null, 34, 0),
  ((select id from p), 'Verde agua', '#7fb7a8', 'vidrio', 'DEMO-CER-010-02', null, 4, 1),
  ((select id from p), 'Blanco perla', '#eeeeea', 'vidrio', 'DEMO-CER-010-03', null, 36, 2),
  ((select id from p), 'Mix grises', '#8f9396', 'vidrio', 'DEMO-CER-010-04', null, 0, 3),
  ((select id from p), 'Mix dorado', '#c3a46c', 'vidrio', 'DEMO-CER-010-05', 119000, 18, 4);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mosaico hexagonal 26×30 (malla)', 'ceramica', 'Mosaico', 'm2', '', 'DEMO-CER-011', 110000, 'Hexágonos en malla, para piso de ducha o pared de acento.', '[{"label": "Hexágono", "value": "5 cm"}, {"label": "Mallas por m²", "value": "13"}]'::jsonb, null, null, null, 'surface', 26, 30, 'both', 11) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f1f1ee', 'mate', 'DEMO-CER-011-01', null, 10, 0),
  ((select id from p), 'Negro', '#232323', 'mate', 'DEMO-CER-011-02', null, 29, 1),
  ((select id from p), 'Mármol Carrara', '#e6e6e3', 'pulido', 'DEMO-CER-011-03', 154000, 32, 2),
  ((select id from p), 'Terrazo', '#d8d2c8', 'mate', 'DEMO-CER-011-04', 126000, 3, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Listelo / cenefa decorativa 8×60', 'ceramica', 'Decorado', 'unidad', '', 'DEMO-CER-012', 18000, 'Franja decorativa que se combina con la cerámica de pared. Se vende por pieza.', '[{"label": "Uso", "value": "Franja horizontal"}]'::jsonb, null, null, null, 'surface', 8, 60, 'wall', 12) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Vidrio plata', '#c9ccce', 'vidrio', 'DEMO-CER-012-01', null, 28, 0),
  ((select id from p), 'Vidrio dorado', '#c8a96a', 'vidrio', 'DEMO-CER-012-02', 20000, 10, 1),
  ((select id from p), 'Piedra', '#a69a86', 'natural', 'DEMO-CER-012-03', 22000, 27, 2),
  ((select id from p), 'Metálico negro', '#2a2a2a', 'metálico', 'DEMO-CER-012-04', 20000, 13, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Baldosa hidráulica 20×20', 'ceramica', 'Decorado', 'm2', '', 'DEMO-CER-013', 140000, 'Diseños geométricos estilo hidráulico, para piso o pared de acento.', '[{"label": "Espesor", "value": "9 mm"}, {"label": "Piezas por caja", "value": "25 (1 m²)"}]'::jsonb, null, null, null, 'surface', 20, 20, 'both', 13) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Geométrico gris', '#9b9d9f', 'mate', 'DEMO-CER-013-01', null, 5, 0),
  ((select id from p), 'Floral azul', '#4d6f96', 'mate', 'DEMO-CER-013-02', null, 40, 1),
  ((select id from p), 'Estrella negro y blanco', '#5a5a5a', 'mate', 'DEMO-CER-013-03', null, 0, 2),
  ((select id from p), 'Terracota', '#b5653d', 'mate', 'DEMO-CER-013-04', null, 31, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sanitario one piece alongado', 'sanitarios', 'One piece', 'unidad', '', 'DEMO-SAN-014', 890000, 'Tanque y taza en una sola pieza: más fácil de limpiar. Descarga de doble pulsador.', '[{"label": "Consumo", "value": "4,8 L / 3 L doble descarga"}, {"label": "Distancia a pared (rough)", "value": "30 cm"}, {"label": "Asiento", "value": "Cierre lento incluido"}]'::jsonb, 38, 72, 70, 'floor', null, null, null, 14) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-014-01', null, 24, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-SAN-014-02', 934000, 25, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-SAN-014-03', 1290000, 38, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-SAN-014-04', 1246000, 7, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sanitario dos piezas redondo', 'sanitarios', 'Dos piezas', 'unidad', '', 'DEMO-SAN-015', 380000, 'Modelo clásico de tanque y taza separados. Económico y de fácil mantenimiento.', '[{"label": "Consumo", "value": "6 L"}, {"label": "Distancia a pared (rough)", "value": "30 cm"}, {"label": "Asiento", "value": "Incluido"}]'::jsonb, 37, 76, 68, 'floor', null, null, null, 15) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-015-01', null, 18, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-SAN-015-02', 399000, 4, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sanitario dos piezas alongado ahorrador', 'sanitarios', 'Dos piezas', 'unidad', '', 'DEMO-SAN-016', 520000, 'Taza alongada más cómoda, con tanque ahorrador.', '[{"label": "Consumo", "value": "4,8 L"}, {"label": "Distancia a pared (rough)", "value": "30 cm"}]'::jsonb, 38, 78, 72, 'floor', null, null, null, 16) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-016-01', null, 0, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-SAN-016-02', 546000, 42, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-SAN-016-03', 754000, 35, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-SAN-016-04', 728000, 38, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sanitario suspendido de pared', 'sanitarios', 'Suspendido', 'unidad', '', 'DEMO-SAN-017', 1150000, 'Se cuelga de la pared con tanque oculto: libera el piso y se ve moderno. Requiere estructura empotrada.', '[{"label": "Consumo", "value": "4,5 L / 3 L"}, {"label": "Requiere", "value": "Tanque empotrado y bastidor"}]'::jsonb, 36, 36, 54, 'wall', null, null, null, 17) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-017-01', null, 5, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-SAN-017-02', 1208000, 0, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-SAN-017-03', 1668000, 28, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-SAN-017-04', 1610000, 25, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sanitario inteligente con bidé', 'sanitarios', 'Smart', 'unidad', '', 'DEMO-SAN-018', 3900000, 'Asiento calefactado, bidé integrado con agua tibia, secado y descarga automática.', '[{"label": "Alimentación", "value": "110 V"}, {"label": "Funciones", "value": "Bidé, secado, asiento calefactado, luz nocturna"}]'::jsonb, 40, 50, 70, 'floor', null, null, null, 18) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-018-01', null, 12, 0),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-SAN-018-02', 4290000, 35, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sanitario infantil', 'sanitarios', 'Infantil', 'unidad', '', 'DEMO-SAN-019', 450000, 'Altura reducida para jardines, colegios y baños de niños.', '[{"label": "Altura de la taza", "value": "30 cm"}]'::jsonb, 32, 56, 52, 'floor', null, null, null, 19) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-019-01', null, 22, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Bidé de piso', 'sanitarios', 'Bidé', 'unidad', '', 'DEMO-SAN-020', 420000, 'Complemento para la higiene personal. Se combina con el sanitario de la misma línea.', '[{"label": "Grifería", "value": "No incluida"}]'::jsonb, 36, 40, 54, 'floor', null, null, null, 20) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-020-01', null, 26, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-SAN-020-02', 441000, 15, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-SAN-020-03', 609000, 30, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-SAN-020-04', 588000, 39, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Orinal de pared', 'sanitarios', 'Orinal', 'unidad', '', 'DEMO-SAN-021', 480000, 'Orinal con fluxómetro o con sensor (fluxómetro aparte).', '[{"label": "Consumo", "value": "1 L"}]'::jsonb, 36, 60, 33, 'wall', null, null, null, 21) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-021-01', null, 21, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-SAN-021-02', 504000, 38, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Asiento sanitario con cierre lento', 'sanitarios', 'Asiento', 'unidad', '', 'DEMO-SAN-022', 120000, 'Tapa de repuesto con bisagras de cierre lento y desmonte rápido.', '[{"label": "Material", "value": "Polipropileno"}]'::jsonb, 36, 5, 46, 'none', null, null, null, 22) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-SAN-022-01', null, 0, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-SAN-022-02', 126000, 0, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-SAN-022-03', 174000, 5, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-SAN-022-04', 168000, 13, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Tanque empotrado con pulsador para sanitario suspendido', 'sanitarios', 'Tanque', 'unidad', '', 'DEMO-SAN-023', 980000, 'Bastidor y tanque que van dentro del muro, con pulsador de doble descarga.', '[{"label": "Incluye", "value": "Bastidor, tanque, pulsador"}]'::jsonb, 50, 112, 12, 'none', null, null, null, 23) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-SAN-023-01', null, 35, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-SAN-023-02', 1176000, 41, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-SAN-023-03', 1127000, 22, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos de pedestal', 'lavamanos', 'De pedestal', 'unidad', '', 'DEMO-LAV-024', 260000, 'Lavamanos con columna que oculta el sifón. Clásico y económico.', '[{"label": "Perforación grifería", "value": "Monocontrol o 4\""}, {"label": "Rebose", "value": "Sí"}]'::jsonb, 55, 85, 45, 'floor', null, null, null, 24) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-024-01', null, 4, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-024-02', 273000, 16, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-LAV-024-03', 377000, 5, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-LAV-024-04', 364000, 0, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos de semipedestal', 'lavamanos', 'Semipedestal', 'unidad', '', 'DEMO-LAV-025', 310000, 'Va colgado a la pared con medio pedestal: deja libre el piso.', '[{"label": "Perforación grifería", "value": "Monocontrol"}]'::jsonb, 50, 45, 44, 'wall', null, null, null, 25) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-025-01', null, 15, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-025-02', 326000, 16, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-LAV-025-03', 450000, 5, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-LAV-025-04', 434000, 17, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos de sobreponer redondo', 'lavamanos', 'De sobreponer', 'unidad', '', 'DEMO-LAV-026', 290000, 'Lavamanos tipo vessel que va encima del mueble o mesón. Requiere grifería alta o de pared.', '[{"label": "Rebose", "value": "No"}, {"label": "Grifería", "value": "Alta o de pared"}]'::jsonb, 40, 14, 40, 'wall', null, null, null, 26) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-026-01', null, 40, 0),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-LAV-026-02', 377000, 0, 1),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-LAV-026-03', 377000, 37, 2),
  ((select id from p), 'Piedra natural', '#9c968a', 'natural', 'DEMO-LAV-026-04', 638000, 35, 3),
  ((select id from p), 'Terrazo', '#d8d2c8', 'mate', 'DEMO-LAV-026-05', 464000, 0, 4);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos de sobreponer rectangular', 'lavamanos', 'De sobreponer', 'unidad', '', 'DEMO-LAV-027', 320000, 'Vessel rectangular de líneas rectas.', '[{"label": "Rebose", "value": "No"}]'::jsonb, 50, 13, 38, 'wall', null, null, null, 27) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-027-01', null, 16, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-027-02', 336000, 0, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-LAV-027-03', 464000, 42, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-LAV-027-04', 448000, 0, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos de empotrar bajo cubierta', 'lavamanos', 'De empotrar', 'unidad', '', 'DEMO-LAV-028', 230000, 'Se instala debajo del mesón de piedra o cuarzo: superficie continua, fácil de limpiar.', '[{"label": "Requiere", "value": "Mesón con corte"}]'::jsonb, 49, 18, 36, 'wall', null, null, null, 28) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-028-01', null, 35, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-028-02', 242000, 25, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos de empotrar sobre cubierta', 'lavamanos', 'De empotrar', 'unidad', '', 'DEMO-LAV-029', 240000, 'El borde queda apoyado sobre el mesón.', '[{"label": "Perforación grifería", "value": "Monocontrol"}]'::jsonb, 52, 18, 42, 'wall', null, null, null, 29) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-029-01', null, 11, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-029-02', 252000, 36, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos suspendido de pared', 'lavamanos', 'Suspendido', 'unidad', '', 'DEMO-LAV-030', 360000, 'Se fija directo a la pared, sin mueble ni pedestal.', '[{"label": "Perforación grifería", "value": "Monocontrol"}]'::jsonb, 60, 15, 45, 'wall', null, null, null, 30) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-030-01', null, 8, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-030-02', 378000, 27, 1),
  ((select id from p), 'Negro mate', '#222222', 'mate', 'DEMO-LAV-030-03', 522000, 19, 2),
  ((select id from p), 'Gris mate', '#8d8f91', 'mate', 'DEMO-LAV-030-04', 504000, 29, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos esquinero', 'lavamanos', 'Esquinero', 'unidad', '', 'DEMO-LAV-031', 210000, 'Para baños pequeños: aprovecha la esquina.', '[{"label": "Perforación grifería", "value": "Monocontrol"}]'::jsonb, 42, 15, 42, 'wall', null, null, null, 31) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-031-01', null, 32, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-031-02', 220000, 32, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Lavamanos integrado para mueble', 'lavamanos', 'Integrado', 'unidad', '', 'DEMO-LAV-032', 280000, 'Lavamanos de cerámica que encaja en el mueble del mismo ancho.', '[{"label": "Para mueble de", "value": "60 cm"}]'::jsonb, 61, 12, 46, 'wall', null, null, null, 32) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-LAV-032-01', null, 40, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-LAV-032-02', 294000, 37, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería monocontrol baja para lavamanos', 'griferia', 'Lavamanos', 'unidad', '', 'DEMO-GRI-033', 230000, 'Una sola manija para agua fría y caliente. Cartucho cerámico.', '[{"label": "Cartucho", "value": "Cerámico 35 mm"}, {"label": "Incluye", "value": "Flexibles de 40 cm"}]'::jsonb, 5, 16, 13, 'wall', null, null, null, 33) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-033-01', null, 7, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-033-02', 276000, 37, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-033-03', 264000, 23, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-033-04', 310000, 16, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-GRI-033-05', 310000, 39, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-GRI-033-06', 288000, 16, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-GRI-033-07', 276000, 24, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería monocontrol alta para lavamanos de sobreponer', 'griferia', 'Lavamanos', 'unidad', '', 'DEMO-GRI-034', 360000, 'Cuerpo alto para lavamanos tipo vessel.', '[{"label": "Cartucho", "value": "Cerámico 35 mm"}]'::jsonb, 5, 30, 18, 'wall', null, null, null, 34) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-034-01', null, 25, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-034-02', 432000, 23, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-034-03', 414000, 19, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-034-04', 486000, 27, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-GRI-034-05', 486000, 5, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-GRI-034-06', 450000, 29, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-GRI-034-07', 432000, 16, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería de lavamanos 4" dos llaves', 'griferia', 'Lavamanos', 'unidad', '', 'DEMO-GRI-035', 160000, 'Llaves separadas para agua fría y caliente, centro a centro de 4".', '[{"label": "Centros", "value": "4\" (10 cm)"}]'::jsonb, 16, 10, 12, 'wall', null, null, null, 35) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-035-01', null, 29, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-035-02', 192000, 41, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-035-03', 184000, 6, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-035-04', 216000, 40, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mezclador de lavamanos 8" tres piezas', 'griferia', 'Lavamanos', 'unidad', '', 'DEMO-GRI-036', 420000, 'Pico y dos manijas separadas, centros de 8".', '[{"label": "Centros", "value": "8\" (20 cm)"}]'::jsonb, 20, 15, 14, 'wall', null, null, null, 36) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-036-01', null, 24, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-036-02', 504000, 14, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-036-03', 483000, 17, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-036-04', 567000, 37, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-GRI-036-05', 567000, 30, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-GRI-036-06', 525000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-GRI-036-07', 504000, 34, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería de pared para lavamanos (empotrar)', 'griferia', 'Lavamanos', 'unidad', '', 'DEMO-GRI-037', 480000, 'Pico que sale de la pared; el cuerpo va empotrado.', '[{"label": "Incluye", "value": "Cuerpo de empotrar"}]'::jsonb, 18, 8, 20, 'wall', null, null, null, 37) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-037-01', null, 0, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-037-02', 576000, 20, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-037-03', 552000, 23, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-037-04', 648000, 22, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-GRI-037-05', 648000, 29, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-GRI-037-06', 600000, 9, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-GRI-037-07', 576000, 26, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería temporizada push', 'griferia', 'Lavamanos', 'unidad', '', 'DEMO-GRI-038', 210000, 'Se cierra sola: ahorro de agua para baños de alto tráfico.', '[{"label": "Tiempo", "value": "≈ 7 s"}]'::jsonb, 5, 12, 12, 'wall', null, null, null, 38) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-038-01', null, 0, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-038-02', 252000, 36, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-038-03', 241000, 40, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-038-04', 284000, 39, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería con sensor', 'griferia', 'Lavamanos', 'unidad', '', 'DEMO-GRI-039', 650000, 'Abre con el movimiento de las manos, sin tocar.', '[{"label": "Alimentación", "value": "Baterías"}]'::jsonb, 5, 16, 13, 'wall', null, null, null, 39) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-039-01', null, 14, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-039-02', 780000, 37, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-039-03', 748000, 29, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mezclador monocontrol de ducha (empotrar)', 'griferia', 'Ducha', 'unidad', '', 'DEMO-GRI-040', 340000, 'Controla temperatura y caudal con una manija.', '[{"label": "Salidas", "value": "1"}]'::jsonb, 16, 16, 8, 'wall', null, null, null, 40) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-040-01', null, 15, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-040-02', 408000, 33, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-040-03', 391000, 32, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-040-04', 459000, 31, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-GRI-040-05', 459000, 26, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-GRI-040-06', 425000, 30, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-GRI-040-07', 408000, 5, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mezclador de ducha con desviador', 'griferia', 'Ducha', 'unidad', '', 'DEMO-GRI-041', 520000, 'Monocontrol con desviador para regadera y ducha teléfono.', '[{"label": "Salidas", "value": "2"}]'::jsonb, 16, 26, 9, 'wall', null, null, null, 41) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-041-01', null, 37, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-041-02', 624000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-041-03', 598000, 13, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-041-04', 702000, 0, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-GRI-041-05', 702000, 13, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-GRI-041-06', 650000, 31, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-GRI-041-07', 624000, 4, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mezclador termostático', 'griferia', 'Ducha', 'unidad', '', 'DEMO-GRI-042', 980000, 'Mantiene la temperatura fija aunque cambie la presión.', '[{"label": "Salidas", "value": "2"}]'::jsonb, 30, 10, 10, 'wall', null, null, null, 42) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-042-01', null, 24, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-042-02', 1176000, 21, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-042-03', 1127000, 7, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-042-04', 1323000, 23, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Llaves de ducha dos manijas', 'griferia', 'Ducha', 'juego', '', 'DEMO-GRI-043', 150000, 'Juego clásico de llave de agua fría y caliente.', '[{"label": "Incluye", "value": "2 llaves + chapetones"}]'::jsonb, 30, 8, 8, 'wall', null, null, null, 43) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-043-01', null, 4, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-043-02', 180000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-043-03', 172000, 23, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-043-04', 202000, 36, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería de tina con ducha teléfono', 'griferia', 'Tina', 'unidad', '', 'DEMO-GRI-044', 690000, 'Mezclador para tina con desviador a ducha teléfono.', '[{"label": "Montaje", "value": "Pared"}]'::jsonb, 30, 15, 15, 'wall', null, null, null, 44) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-044-01', null, 28, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-044-02', 828000, 15, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-044-03', 793000, 19, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-044-04', 932000, 41, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-GRI-044-05', 932000, 5, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-GRI-044-06', 862000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-GRI-044-07', 828000, 0, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Grifería para bidé', 'griferia', 'Bidé', 'unidad', '', 'DEMO-GRI-045', 260000, 'Monocontrol con aireador orientable.', '[]'::jsonb, 5, 14, 12, 'wall', null, null, null, 45) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-045-01', null, 17, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-GRI-045-02', 312000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-GRI-045-03', 299000, 42, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-GRI-045-04', 351000, 11, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Fluxómetro para orinal', 'griferia', 'Orinal', 'unidad', '', 'DEMO-GRI-046', 390000, 'Válvula de descarga para orinal.', '[]'::jsonb, 8, 30, 12, 'wall', null, null, null, 46) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-GRI-046-01', null, 31, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Regadera tipo lluvia redonda 20 cm', 'duchas', 'Regadera', 'unidad', '', 'DEMO-DUC-047', 120000, 'Regadera ancha que cae como lluvia.', '[{"label": "Diámetro", "value": "20 cm"}, {"label": "Boquillas", "value": "Antisarro"}]'::jsonb, 20, 1, 20, 'wall', null, null, null, 47) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-047-01', null, 24, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-047-02', 144000, 4, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-047-03', 138000, 18, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-047-04', 162000, 11, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-047-05', 162000, 0, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-047-06', 150000, 6, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-047-07', 144000, 9, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Regadera tipo lluvia redonda 30 cm', 'duchas', 'Regadera', 'unidad', '', 'DEMO-DUC-048', 210000, 'Mayor cobertura de agua.', '[{"label": "Diámetro", "value": "30 cm"}]'::jsonb, 30, 1, 30, 'wall', null, null, null, 48) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-048-01', null, 14, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-048-02', 252000, 20, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-048-03', 241000, 0, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-048-04', 284000, 24, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-048-05', 284000, 23, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-048-06', 262000, 24, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-048-07', 252000, 29, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Regadera tipo lluvia cuadrada 25×25', 'duchas', 'Regadera', 'unidad', '', 'DEMO-DUC-049', 190000, 'Diseño cuadrado, estilo moderno.', '[]'::jsonb, 25, 1, 25, 'wall', null, null, null, 49) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-049-01', null, 3, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-049-02', 228000, 30, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-049-03', 218000, 27, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-049-04', 257000, 0, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-049-05', 257000, 38, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-049-06', 238000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-049-07', 228000, 28, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Regadera de techo empotrada 40×40', 'duchas', 'Regadera', 'unidad', '', 'DEMO-DUC-050', 620000, 'Se empotra en el cielo raso.', '[]'::jsonb, 40, 1, 40, 'wall', null, null, null, 50) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-050-01', null, 22, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-050-02', 744000, 33, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-050-03', 713000, 33, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-050-04', 837000, 33, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Brazo de ducha de pared 40 cm', 'duchas', 'Brazo', 'unidad', '', 'DEMO-DUC-051', 75000, 'Sostiene la regadera desde la pared.', '[]'::jsonb, 4, 4, 40, 'wall', null, null, null, 51) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-051-01', null, 5, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-051-02', 90000, 5, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-051-03', 86000, 10, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-051-04', 101000, 12, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-051-05', 101000, 41, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-051-06', 94000, 5, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-051-07', 90000, 35, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Brazo de ducha de techo 30 cm', 'duchas', 'Brazo', 'unidad', '', 'DEMO-DUC-052', 85000, 'Bajante para regadera desde el techo.', '[]'::jsonb, 4, 30, 4, 'wall', null, null, null, 52) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-052-01', null, 0, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-052-02', 102000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-052-03', 98000, 20, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-052-04', 115000, 15, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-052-05', 115000, 19, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-052-06', 106000, 30, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-052-07', 102000, 0, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Ducha teléfono con manguera 1,5 m', 'duchas', 'Teléfono', 'unidad', '', 'DEMO-DUC-053', 95000, 'Ducha de mano con soporte de pared.', '[{"label": "Funciones", "value": "3"}]'::jsonb, 8, 25, 5, 'wall', null, null, null, 53) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-053-01', null, 29, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-053-02', 114000, 7, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-053-03', 109000, 0, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-053-04', 128000, 19, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-053-05', 128000, 7, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-053-06', 119000, 13, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-053-07', 114000, 13, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Barra deslizable con ducha teléfono', 'duchas', 'Barra', 'unidad', '', 'DEMO-DUC-054', 230000, 'La altura de la ducha de mano se ajusta.', '[]'::jsonb, 8, 70, 8, 'wall', null, null, null, 54) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-054-01', null, 22, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-054-02', 276000, 12, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-054-03', 264000, 16, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-054-04', 310000, 30, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-054-05', 310000, 24, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-054-06', 288000, 12, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-054-07', 276000, 18, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Columna de ducha completa', 'duchas', 'Sistema', 'unidad', '', 'DEMO-DUC-055', 890000, 'Regadera lluvia, ducha teléfono y mezclador en un solo sistema.', '[{"label": "Incluye", "value": "Mezclador, regadera, teléfono"}]'::jsonb, 25, 115, 45, 'wall', null, null, null, 55) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-055-01', null, 20, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-055-02', 1068000, 34, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-055-03', 1023000, 34, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-DUC-055-04', 1202000, 21, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-DUC-055-05', 1202000, 4, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-DUC-055-06', 1112000, 15, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-DUC-055-07', 1068000, 25, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Ducha eléctrica', 'duchas', 'Eléctrica', 'unidad', '', 'DEMO-DUC-056', 110000, 'Calienta el agua en el punto.', '[{"label": "Voltaje", "value": "120 V"}, {"label": "Potencia", "value": "3500 W"}]'::jsonb, 16, 18, 10, 'wall', null, null, null, 56) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'brillante', 'DEMO-DUC-056-01', null, 3, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Nicho de ducha empotrado 30×60', 'duchas', 'Nicho', 'unidad', '', 'DEMO-DUC-057', 280000, 'Repisa empotrada en la pared de la ducha.', '[{"label": "Material", "value": "Acero inoxidable"}]'::jsonb, 30, 60, 10, 'wall', null, null, null, 57) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DUC-057-01', null, 6, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DUC-057-02', 336000, 8, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-DUC-057-03', 322000, 17, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('División de baño corrediza 1,20 m', 'divisiones', 'Corrediza', 'unidad', '', 'DEMO-DIV-058', 980000, 'Vidrio templado con puerta corrediza: ahorra espacio.', '[{"label": "Vidrio", "value": "Templado 8 mm"}, {"label": "Ancho", "value": "Ajustable 110–120 cm"}]'::jsonb, 120, 190, 4, 'floor', null, null, null, 58) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Transparente', '#dfeef0', 'templado 8 mm', 'DEMO-DIV-058-01', null, 0, 0),
  ((select id from p), 'Esmerilado', '#eef2f2', 'templado 8 mm', 'DEMO-DIV-058-02', 1078000, 36, 1),
  ((select id from p), 'Fumé', '#7d8085', 'templado 8 mm', 'DEMO-DIV-058-03', 1176000, 0, 2),
  ((select id from p), 'Bronce', '#a07e5c', 'templado 8 mm', 'DEMO-DIV-058-04', 1176000, 19, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('División de baño batiente (abatible) 0,90 m', 'divisiones', 'Batiente', 'unidad', '', 'DEMO-DIV-059', 820000, 'Puerta que abre hacia afuera.', '[{"label": "Vidrio", "value": "Templado 8 mm"}]'::jsonb, 90, 190, 4, 'floor', null, null, null, 59) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Transparente', '#dfeef0', 'templado 8 mm', 'DEMO-DIV-059-01', null, 24, 0),
  ((select id from p), 'Esmerilado', '#eef2f2', 'templado 8 mm', 'DEMO-DIV-059-02', 902000, 7, 1),
  ((select id from p), 'Fumé', '#7d8085', 'templado 8 mm', 'DEMO-DIV-059-03', 984000, 6, 2),
  ((select id from p), 'Bronce', '#a07e5c', 'templado 8 mm', 'DEMO-DIV-059-04', 984000, 0, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Panel fijo walk-in 0,90 m', 'divisiones', 'Panel fijo', 'unidad', '', 'DEMO-DIV-060', 690000, 'Vidrio fijo sin puerta, estilo moderno.', '[{"label": "Vidrio", "value": "Templado 8 mm"}, {"label": "Incluye", "value": "Barra de soporte"}]'::jsonb, 90, 200, 4, 'floor', null, null, null, 60) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Transparente', '#dfeef0', 'templado 8 mm', 'DEMO-DIV-060-01', null, 17, 0),
  ((select id from p), 'Esmerilado', '#eef2f2', 'templado 8 mm', 'DEMO-DIV-060-02', 759000, 40, 1),
  ((select id from p), 'Fumé', '#7d8085', 'templado 8 mm', 'DEMO-DIV-060-03', 828000, 33, 2),
  ((select id from p), 'Bronce', '#a07e5c', 'templado 8 mm', 'DEMO-DIV-060-04', 828000, 24, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('División esquinera cuadrada 90×90', 'divisiones', 'Esquinera', 'unidad', '', 'DEMO-DIV-061', 1350000, 'Para duchas en esquina, con dos puertas corredizas.', '[{"label": "Vidrio", "value": "Templado 6 mm"}]'::jsonb, 90, 190, 90, 'floor', null, null, null, 61) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Transparente', '#dfeef0', 'templado 8 mm', 'DEMO-DIV-061-01', null, 20, 0),
  ((select id from p), 'Esmerilado', '#eef2f2', 'templado 8 mm', 'DEMO-DIV-061-02', 1485000, 23, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Perfilería para división de baño', 'divisiones', 'Perfilería', 'juego', '', 'DEMO-DIV-062', 180000, 'Rieles, rodachines y herrajes para la división.', '[{"label": "Material", "value": "Aluminio"}]'::jsonb, null, null, null, 'none', null, null, null, 62) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-DIV-062-01', null, 12, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-DIV-062-02', 207000, 28, 1),
  ((select id from p), 'Dorado', '#c8a96a', 'cepillado', 'DEMO-DIV-062-03', 234000, 21, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Cortina de baño con barra extensible', 'divisiones', 'Cortina', 'juego', '', 'DEMO-DIV-063', 75000, 'Opción económica en lugar de la división de vidrio.', '[{"label": "Barra", "value": "Extensible 110–200 cm"}]'::jsonb, 120, 180, 2, 'floor', null, null, null, 63) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanca', '#f4f4f2', 'tela', 'DEMO-DIV-063-01', null, 4, 0),
  ((select id from p), 'Gris', '#9c9c99', 'tela', 'DEMO-DIV-063-02', null, 17, 1),
  ((select id from p), 'Rayas', '#c9b79c', 'tela', 'DEMO-DIV-063-03', null, 12, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Tina acrílica de empotrar 1,50 m', 'tinas', 'Tina', 'unidad', '', 'DEMO-TIN-064', 1250000, 'Tina rectangular para enchapar el frente.', '[{"label": "Capacidad", "value": "180 L"}]'::jsonb, 150, 50, 70, 'floor', null, null, null, 64) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-TIN-064-01', null, 39, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-TIN-064-02', 1312000, 0, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Tina exenta (freestanding) 1,60 m', 'tinas', 'Tina', 'unidad', '', 'DEMO-TIN-065', 3600000, 'Tina independiente, protagonista del baño.', '[{"label": "Capacidad", "value": "220 L"}]'::jsonb, 160, 58, 75, 'floor', null, null, null, 65) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-TIN-065-01', null, 21, 0),
  ((select id from p), 'Negro mate exterior', '#222222', 'mate', 'DEMO-TIN-065-02', 4140000, 23, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Tina de hidromasaje 1,70 m', 'tinas', 'Tina', 'unidad', '', 'DEMO-TIN-066', 5900000, 'Con jets de masaje y motor.', '[{"label": "Jets", "value": "6"}, {"label": "Voltaje", "value": "120 V"}]'::jsonb, 170, 60, 80, 'floor', null, null, null, 66) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-TIN-066-01', null, 31, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-TIN-066-02', 6195000, 0, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Plato de ducha acrílico 80×80', 'tinas', 'Plato de ducha', 'unidad', '', 'DEMO-TIN-067', 390000, 'Receptáculo para ducha cuadrada.', '[{"label": "Desagüe", "value": "Incluido"}]'::jsonb, 80, 6, 80, 'floor', null, null, null, 67) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f7f7f5', 'brillante', 'DEMO-TIN-067-01', null, 26, 0),
  ((select id from p), 'Hueso', '#ece4d3', 'brillante', 'DEMO-TIN-067-02', 410000, 40, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Plato de ducha en resina 70×120', 'tinas', 'Plato de ducha', 'unidad', '', 'DEMO-TIN-068', 980000, 'Textura pizarra antideslizante, extraplano.', '[{"label": "Desagüe", "value": "Incluido"}]'::jsonb, 120, 3, 70, 'floor', null, null, null, 68) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f1f1ee', 'pizarra', 'DEMO-TIN-068-01', null, 37, 0),
  ((select id from p), 'Gris', '#8f8d88', 'pizarra', 'DEMO-TIN-068-02', null, 0, 1),
  ((select id from p), 'Negro', '#2a2a2a', 'pizarra', 'DEMO-TIN-068-03', null, 30, 2),
  ((select id from p), 'Beige', '#d9c9ad', 'pizarra', 'DEMO-TIN-068-04', null, 42, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mueble de lavamanos suspendido 60 cm', 'muebles', 'Mueble de lavamanos', 'unidad', '', 'DEMO-MUE-069', 680000, 'Mueble flotante con cajón y lavamanos integrado.', '[{"label": "Incluye", "value": "Lavamanos integrado"}, {"label": "Cajones", "value": "1"}]'::jsonb, 60, 50, 46, 'wall', null, null, null, 69) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-MUE-069-01', null, 27, 0),
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-MUE-069-02', 734000, 0, 1),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-MUE-069-03', 734000, 7, 2),
  ((select id from p), 'Wengue', '#3b2a20', 'texturizado', 'DEMO-MUE-069-04', 734000, 21, 3),
  ((select id from p), 'Gris grafito', '#55585c', 'mate', 'DEMO-MUE-069-05', 714000, 19, 4),
  ((select id from p), 'Verde salvia', '#8fa58f', 'mate', 'DEMO-MUE-069-06', 762000, 22, 5),
  ((select id from p), 'Negro', '#1f1f1f', 'mate', 'DEMO-MUE-069-07', 748000, 0, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mueble de lavamanos suspendido 80 cm', 'muebles', 'Mueble de lavamanos', 'unidad', '', 'DEMO-MUE-070', 890000, 'Dos cajones y lavamanos integrado.', '[{"label": "Cajones", "value": "2"}]'::jsonb, 80, 50, 46, 'wall', null, null, null, 70) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-MUE-070-01', null, 41, 0),
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-MUE-070-02', 961000, 21, 1),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-MUE-070-03', 961000, 9, 2),
  ((select id from p), 'Wengue', '#3b2a20', 'texturizado', 'DEMO-MUE-070-04', 961000, 22, 3),
  ((select id from p), 'Gris grafito', '#55585c', 'mate', 'DEMO-MUE-070-05', 934000, 14, 4),
  ((select id from p), 'Verde salvia', '#8fa58f', 'mate', 'DEMO-MUE-070-06', 997000, 12, 5),
  ((select id from p), 'Negro', '#1f1f1f', 'mate', 'DEMO-MUE-070-07', 979000, 0, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mueble de lavamanos de piso 100 cm doble', 'muebles', 'Mueble de lavamanos', 'unidad', '', 'DEMO-MUE-071', 1650000, 'Para dos lavamanos, con puertas y entrepaño.', '[{"label": "Lavamanos", "value": "2 (no incluidos)"}]'::jsonb, 100, 85, 48, 'floor', null, null, null, 71) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-MUE-071-01', null, 0, 0),
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-MUE-071-02', 1782000, 36, 1),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-MUE-071-03', 1782000, 33, 2),
  ((select id from p), 'Wengue', '#3b2a20', 'texturizado', 'DEMO-MUE-071-04', 1782000, 9, 3),
  ((select id from p), 'Gris grafito', '#55585c', 'mate', 'DEMO-MUE-071-05', 1732000, 19, 4),
  ((select id from p), 'Verde salvia', '#8fa58f', 'mate', 'DEMO-MUE-071-06', 1848000, 33, 5),
  ((select id from p), 'Negro', '#1f1f1f', 'mate', 'DEMO-MUE-071-07', 1815000, 0, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mueble esquinero de piso 45 cm', 'muebles', 'Mueble de lavamanos', 'unidad', '', 'DEMO-MUE-072', 420000, 'Aprovecha la esquina en baños pequeños.', '[]'::jsonb, 45, 82, 45, 'floor', null, null, null, 72) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-MUE-072-01', null, 0, 0),
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-MUE-072-02', 454000, 18, 1),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-MUE-072-03', 454000, 6, 2),
  ((select id from p), 'Wengue', '#3b2a20', 'texturizado', 'DEMO-MUE-072-04', 454000, 23, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Torre organizadora 30 cm', 'muebles', 'Organizador', 'unidad', '', 'DEMO-MUE-073', 520000, 'Mueble alto para toallas y productos.', '[{"label": "Entrepaños", "value": "4"}]'::jsonb, 30, 160, 30, 'floor', null, null, null, 73) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-MUE-073-01', null, 42, 0),
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-MUE-073-02', 562000, 0, 1),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-MUE-073-03', 562000, 29, 2),
  ((select id from p), 'Wengue', '#3b2a20', 'texturizado', 'DEMO-MUE-073-04', 562000, 28, 3),
  ((select id from p), 'Gris grafito', '#55585c', 'mate', 'DEMO-MUE-073-05', 546000, 40, 4),
  ((select id from p), 'Verde salvia', '#8fa58f', 'mate', 'DEMO-MUE-073-06', 582000, 37, 5),
  ((select id from p), 'Negro', '#1f1f1f', 'mate', 'DEMO-MUE-073-07', 572000, 38, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mueble sobre sanitario', 'muebles', 'Organizador', 'unidad', '', 'DEMO-MUE-074', 360000, 'Estantería que aprovecha el espacio arriba del sanitario.', '[]'::jsonb, 60, 170, 22, 'floor', null, null, null, 74) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-MUE-074-01', null, 0, 0),
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-MUE-074-02', 389000, 6, 1),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-MUE-074-03', 389000, 24, 2),
  ((select id from p), 'Wengue', '#3b2a20', 'texturizado', 'DEMO-MUE-074-04', 389000, 11, 3),
  ((select id from p), 'Gris grafito', '#55585c', 'mate', 'DEMO-MUE-074-05', 378000, 21, 4);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Gabinete botiquín con espejo 60 cm', 'muebles', 'Botiquín', 'unidad', '', 'DEMO-MUE-075', 390000, 'Espejo con almacenamiento detrás.', '[{"label": "Puertas", "value": "1"}]'::jsonb, 60, 70, 14, 'wall', null, null, null, 75) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-MUE-075-01', null, 17, 0),
  ((select id from p), 'Roble claro', '#c4a27a', 'texturizado', 'DEMO-MUE-075-02', 421000, 16, 1),
  ((select id from p), 'Nogal', '#6e4b33', 'texturizado', 'DEMO-MUE-075-03', 421000, 19, 2),
  ((select id from p), 'Wengue', '#3b2a20', 'texturizado', 'DEMO-MUE-075-04', 421000, 30, 3),
  ((select id from p), 'Gris grafito', '#55585c', 'mate', 'DEMO-MUE-075-05', 410000, 3, 4);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Mesón en cuarzo para lavamanos (metro lineal)', 'muebles', 'Mesón', 'metro', '', 'DEMO-MUE-076', 620000, 'Mesón a medida en cuarzo, 2 cm de espesor.', '[{"label": "Espesor", "value": "2 cm"}, {"label": "Profundidad", "value": "50 cm"}]'::jsonb, 100, 2, 50, 'floor', null, null, null, 76) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco polar', '#f2f2f0', 'pulido', 'DEMO-MUE-076-01', null, 27, 0),
  ((select id from p), 'Calacatta', '#efe9df', 'pulido', 'DEMO-MUE-076-02', 775000, 36, 1),
  ((select id from p), 'Gris concreto', '#9a9893', 'mate', 'DEMO-MUE-076-03', 682000, 28, 2),
  ((select id from p), 'Negro absoluto', '#1d1d1d', 'pulido', 'DEMO-MUE-076-04', 682000, 21, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Espejo redondo 60 cm', 'espejos', 'Redondo', 'unidad', '', 'DEMO-ESP-077', 180000, 'Espejo circular con o sin marco.', '[]'::jsonb, 60, 60, 3, 'wall', null, null, null, 77) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Sin marco', '#dfe5e6', 'bisel', 'DEMO-ESP-077-01', null, 25, 0),
  ((select id from p), 'Marco negro', '#1f1f1f', 'mate', 'DEMO-ESP-077-02', 207000, 38, 1),
  ((select id from p), 'Marco dorado', '#c8a96a', 'cepillado', 'DEMO-ESP-077-03', 225000, 23, 2),
  ((select id from p), 'Marco madera', '#a37b52', 'natural', 'DEMO-ESP-077-04', 216000, 15, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Espejo rectangular 60×80', 'espejos', 'Rectangular', 'unidad', '', 'DEMO-ESP-078', 160000, 'Espejo de bisel o con marco.', '[]'::jsonb, 60, 80, 3, 'wall', null, null, null, 78) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Sin marco', '#dfe5e6', 'bisel', 'DEMO-ESP-078-01', null, 25, 0),
  ((select id from p), 'Marco negro', '#1f1f1f', 'mate', 'DEMO-ESP-078-02', 184000, 0, 1),
  ((select id from p), 'Marco dorado', '#c8a96a', 'cepillado', 'DEMO-ESP-078-03', 200000, 36, 2),
  ((select id from p), 'Marco madera', '#a37b52', 'natural', 'DEMO-ESP-078-04', 192000, 14, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Espejo LED antiempañante 60×80', 'espejos', 'LED', 'unidad', '', 'DEMO-ESP-079', 520000, 'Iluminación LED perimetral, antiempañante y botón táctil.', '[{"label": "Luz", "value": "Fría / cálida / neutra"}, {"label": "Voltaje", "value": "120 V"}]'::jsonb, 60, 80, 4, 'wall', null, null, null, 79) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Sin marco', '#dfe5e6', 'LED', 'DEMO-ESP-079-01', null, 32, 0),
  ((select id from p), 'Marco negro', '#1f1f1f', 'LED', 'DEMO-ESP-079-02', 572000, 16, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Espejo LED redondo 70 cm', 'espejos', 'LED', 'unidad', '', 'DEMO-ESP-080', 590000, 'Espejo redondo con luz posterior.', '[{"label": "Voltaje", "value": "120 V"}]'::jsonb, 70, 70, 4, 'wall', null, null, null, 80) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Sin marco', '#dfe5e6', 'LED', 'DEMO-ESP-080-01', null, 32, 0),
  ((select id from p), 'Marco negro', '#1f1f1f', 'LED', 'DEMO-ESP-080-02', 649000, 37, 1),
  ((select id from p), 'Marco dorado', '#c8a96a', 'LED', 'DEMO-ESP-080-03', 708000, 19, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Espejo orgánico 50×80', 'espejos', 'Orgánico', 'unidad', '', 'DEMO-ESP-081', 240000, 'Forma irregular, tendencia decorativa.', '[]'::jsonb, 50, 80, 3, 'wall', null, null, null, 81) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Sin marco', '#dfe5e6', 'bisel', 'DEMO-ESP-081-01', null, 17, 0),
  ((select id from p), 'Marco negro', '#1f1f1f', 'mate', 'DEMO-ESP-081-02', 276000, 42, 1),
  ((select id from p), 'Marco dorado', '#c8a96a', 'cepillado', 'DEMO-ESP-081-03', 300000, 0, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Espejo ovalado tipo cápsula 50×90', 'espejos', 'Ovalado', 'unidad', '', 'DEMO-ESP-082', 230000, 'Forma de cápsula con marco metálico.', '[]'::jsonb, 50, 90, 3, 'wall', null, null, null, 82) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Sin marco', '#dfe5e6', 'bisel', 'DEMO-ESP-082-01', null, 0, 0),
  ((select id from p), 'Marco negro', '#1f1f1f', 'mate', 'DEMO-ESP-082-02', 264000, 0, 1),
  ((select id from p), 'Marco dorado', '#c8a96a', 'cepillado', 'DEMO-ESP-082-03', 288000, 18, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Toallero de barra 60 cm', 'accesorios', 'Toallero', 'unidad', '', 'DEMO-ACC-083', 85000, 'Barra para colgar toallas.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 60, 6, 8, 'wall', null, null, null, 83) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-083-01', null, 0, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-083-02', 102000, 27, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-083-03', 98000, 19, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-083-04', 115000, 24, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-083-05', 115000, 36, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-083-06', 106000, 36, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-083-07', 102000, 20, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Toallero de aro', 'accesorios', 'Toallero', 'unidad', '', 'DEMO-ACC-084', 55000, 'Aro para toalla de manos junto al lavamanos.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 18, 20, 6, 'wall', null, null, null, 84) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-084-01', null, 26, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-084-02', 66000, 28, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-084-03', 63000, 41, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-084-04', 74000, 37, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-084-05', 74000, 41, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-084-06', 69000, 4, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-084-07', 66000, 34, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Toallero doble con repisa', 'accesorios', 'Toallero', 'unidad', '', 'DEMO-ACC-085', 160000, 'Repisa superior y barra para toallas.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 60, 10, 24, 'wall', null, null, null, 85) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-085-01', null, 28, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-085-02', 192000, 22, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-085-03', 184000, 17, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-085-04', 216000, 0, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-085-05', 216000, 20, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-085-06', 200000, 32, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-085-07', 192000, 33, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Portarrollo de papel higiénico', 'accesorios', 'Portarrollo', 'unidad', '', 'DEMO-ACC-086', 45000, 'Soporte de pared para el papel.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 15, 8, 8, 'wall', null, null, null, 86) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-086-01', null, 16, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-086-02', 54000, 17, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-086-03', 52000, 24, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-086-04', 61000, 16, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-086-05', 61000, 39, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-086-06', 56000, 17, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-086-07', 54000, 31, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Gancho doble (percha)', 'accesorios', 'Gancho', 'unidad', '', 'DEMO-ACC-087', 30000, 'Para batas y toallas.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 5, 6, 6, 'wall', null, null, null, 87) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-087-01', null, 4, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-087-02', 36000, 8, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-087-03', 34000, 39, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-087-04', 40000, 13, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-087-05', 40000, 10, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-087-06', 38000, 36, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-087-07', 36000, 40, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Jabonera de pared', 'accesorios', 'Jabonera', 'unidad', '', 'DEMO-ACC-088', 40000, 'Con plato desmontable.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 12, 5, 11, 'wall', null, null, null, 88) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-088-01', null, 41, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-088-02', 48000, 40, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-088-03', 46000, 0, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-088-04', 54000, 4, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-088-05', 54000, 4, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-088-06', 50000, 21, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-088-07', 48000, 13, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Dispensador de jabón de pared', 'accesorios', 'Dispensador', 'unidad', '', 'DEMO-ACC-089', 65000, 'Dispensador de jabón líquido de 300 ml.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 8, 18, 10, 'wall', null, null, null, 89) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-089-01', null, 11, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-089-02', 78000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-089-03', 75000, 32, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-089-04', 88000, 25, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-089-05', 88000, 21, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-089-06', 81000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-089-07', 78000, 4, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Repisa de vidrio 50 cm', 'accesorios', 'Repisa', 'unidad', '', 'DEMO-ACC-090', 70000, 'Repisa de vidrio templado con soportes.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 50, 4, 12, 'wall', null, null, null, 90) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-090-01', null, 24, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-090-02', 84000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-090-03', 80000, 18, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-090-04', 94000, 14, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-090-05', 94000, 38, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-090-06', 88000, 41, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-090-07', 84000, 19, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Repisa esquinera para ducha', 'accesorios', 'Repisa', 'unidad', '', 'DEMO-ACC-091', 75000, 'Esquinera de dos niveles.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 20, 5, 20, 'wall', null, null, null, 91) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-091-01', null, 0, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-091-02', 90000, 21, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-091-03', 86000, 29, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-091-04', 101000, 0, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-091-05', 101000, 0, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-091-06', 94000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-091-07', 90000, 0, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Barra de apoyo 60 cm', 'accesorios', 'Seguridad', 'unidad', '', 'DEMO-ACC-092', 120000, 'Barra de seguridad para adultos mayores y movilidad reducida.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, 60, 8, 8, 'wall', null, null, null, 92) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-092-01', null, 42, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-092-02', 144000, 24, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-092-03', 138000, 15, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-092-04', 162000, 0, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-092-05', 162000, 10, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-092-06', 150000, 7, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-092-07', 144000, 25, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Juego de accesorios 5 piezas', 'accesorios', 'Set', 'juego', '', 'DEMO-ACC-093', 230000, 'Toallero, aro, portarrollo, jabonera y gancho de la misma línea.', '[{"label": "Material", "value": "Acero inoxidable / zamak"}]'::jsonb, null, null, null, 'none', null, null, null, 93) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-093-01', null, 19, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-093-02', 276000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-093-03', 264000, 20, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-093-04', 310000, 5, 3),
  ((select id from p), 'Oro rosa', '#c99a86', 'cepillado', 'DEMO-ACC-093-05', 310000, 31, 4),
  ((select id from p), 'Grafito', '#4a4c50', 'cepillado', 'DEMO-ACC-093-06', 288000, 0, 5),
  ((select id from p), 'Blanco mate', '#f2f2f0', 'mate', 'DEMO-ACC-093-07', 276000, 16, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Papelera con pedal 5 L', 'accesorios', 'Papelera', 'unidad', '', 'DEMO-ACC-094', 75000, 'Cesta de basura con tapa de pedal.', '[]'::jsonb, 20, 28, 20, 'floor', null, null, null, 94) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-094-01', null, 18, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-094-02', 90000, 33, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-094-03', 86000, 31, 2),
  ((select id from p), 'Blanco', '#f4f4f2', 'mate', 'DEMO-ACC-094-04', null, 0, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Extractor de olores 4"', 'accesorios', 'Extractor', 'unidad', '', 'DEMO-ACC-095', 95000, 'Ventilación forzada para baños sin ventana.', '[{"label": "Voltaje", "value": "120 V"}, {"label": "Caudal", "value": "90 m³/h"}]'::jsonb, 18, 18, 10, 'wall', null, null, null, 95) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-ACC-095-01', null, 13, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Aplique LED para espejo 40 cm', 'accesorios', 'Iluminación', 'unidad', '', 'DEMO-ACC-096', 130000, 'Lámpara de pared sobre el espejo.', '[{"label": "Potencia", "value": "8 W"}]'::jsonb, 40, 4, 8, 'wall', null, null, null, 96) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-ACC-096-01', null, 36, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-ACC-096-02', 156000, 20, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-ACC-096-03', 150000, 19, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-ACC-096-04', 176000, 41, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Manguera flexible para lavamanos 1/2" × 40 cm', 'instalacion', 'Flexibles', 'unidad', '', 'DEMO-INS-097', 14000, 'Conecta la llave de paso con la grifería del lavamanos.', '[{"label": "Rosca", "value": "1/2\" × 1/2\""}, {"label": "Malla", "value": "Acero inoxidable"}]'::jsonb, null, null, null, 'none', null, null, null, 97) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), '40 cm', null, '', 'DEMO-INS-097-01', null, 3, 0),
  ((select id from p), '60 cm', null, '', 'DEMO-INS-097-02', 17000, 6, 1),
  ((select id from p), '30 cm', null, '', 'DEMO-INS-097-03', 13000, 26, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Manguera flexible para sanitario 7/8" × 1/2"', 'instalacion', 'Flexibles', 'unidad', '', 'DEMO-INS-098', 15000, 'Conecta la llave de paso con el tanque del sanitario.', '[{"label": "Rosca", "value": "7/8\" × 1/2\""}]'::jsonb, null, null, null, 'none', null, null, null, 98) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), '40 cm', null, '', 'DEMO-INS-098-01', null, 42, 0),
  ((select id from p), '30 cm', null, '', 'DEMO-INS-098-02', 14000, 40, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Manguera flexible para mezclador monocontrol M10', 'instalacion', 'Flexibles', 'juego', '', 'DEMO-INS-099', 22000, 'Par de flexibles con rosca M10 para grifería monocontrol.', '[{"label": "Rosca", "value": "M10 × 1/2\""}]'::jsonb, null, null, null, 'none', null, null, null, 99) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), '40 cm', null, '', 'DEMO-INS-099-01', null, 33, 0),
  ((select id from p), '60 cm', null, '', 'DEMO-INS-099-02', 26000, 28, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Llave de paso angular 1/2" (control)', 'instalacion', 'Llaves de paso', 'unidad', '', 'DEMO-INS-100', 28000, 'Válvula para cerrar el agua del lavamanos o del sanitario.', '[{"label": "Rosca", "value": "1/2\" × 1/2\""}]'::jsonb, null, null, null, 'none', null, null, null, 100) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-INS-100-01', null, 21, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-INS-100-02', 34000, 41, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Válvula de bola 1/2" de empotrar', 'instalacion', 'Llaves de paso', 'unidad', '', 'DEMO-INS-101', 38000, 'Registro general del baño.', '[{"label": "Rosca", "value": "1/2\""}]'::jsonb, null, null, null, 'none', null, null, null, 101) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Bronce', '#b08d57', '', 'DEMO-INS-101-01', null, 33, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sifón flexible para lavamanos 1 1/4"', 'instalacion', 'Sifones', 'unidad', '', 'DEMO-INS-102', 18000, 'Sifón en PVC, económico y fácil de instalar.', '[{"label": "Diámetro", "value": "1 1/4\""}]'::jsonb, null, null, null, 'none', null, null, null, 102) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-INS-102-01', null, 16, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sifón de botella cromado para lavamanos', 'instalacion', 'Sifones', 'unidad', '', 'DEMO-INS-103', 95000, 'Sifón decorativo para lavamanos sin pedestal.', '[{"label": "Diámetro", "value": "1 1/4\""}]'::jsonb, null, null, null, 'none', null, null, null, 103) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-INS-103-01', null, 7, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-INS-103-02', 114000, 0, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-INS-103-03', 109000, 22, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-INS-103-04', 128000, 37, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Desagüe push (clic-clac) con rebose', 'instalacion', 'Desagües', 'unidad', '', 'DEMO-INS-104', 45000, 'Tapón que abre y cierra presionando.', '[{"label": "Para", "value": "Lavamanos con rebose"}]'::jsonb, null, null, null, 'none', null, null, null, 104) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-INS-104-01', null, 3, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-INS-104-02', 54000, 16, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-INS-104-03', 52000, 32, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-INS-104-04', 61000, 0, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Desagüe push (clic-clac) sin rebose', 'instalacion', 'Desagües', 'unidad', '', 'DEMO-INS-105', 48000, 'Para lavamanos de sobreponer sin rebose.', '[{"label": "Para", "value": "Lavamanos sin rebose"}]'::jsonb, null, null, null, 'none', null, null, null, 105) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-INS-105-01', null, 10, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-INS-105-02', 58000, 39, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-INS-105-03', 55000, 40, 2),
  ((select id from p), 'Dorado cepillado', '#c8a96a', 'cepillado', 'DEMO-INS-105-04', 65000, 9, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Rejilla de piso cuadrada 10×10 con sifón', 'instalacion', 'Rejillas', 'unidad', '', 'DEMO-INS-106', 35000, 'Desagüe de piso para la ducha.', '[{"label": "Salida", "value": "2\""}]'::jsonb, null, null, null, 'none', null, null, null, 106) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-INS-106-01', null, 34, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-INS-106-02', 42000, 16, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-INS-106-03', 40000, 23, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Rejilla lineal para ducha 60 cm', 'instalacion', 'Rejillas', 'unidad', '', 'DEMO-INS-107', 210000, 'Canal de desagüe largo y discreto.', '[{"label": "Material", "value": "Acero inoxidable 304"}]'::jsonb, null, null, null, 'none', null, null, null, 107) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-INS-107-01', null, 0, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-INS-107-02', 252000, 28, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-INS-107-03', 241000, 22, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Rejilla lineal para ducha 80 cm', 'instalacion', 'Rejillas', 'unidad', '', 'DEMO-INS-108', 250000, 'Canal de desagüe largo y discreto.', '[{"label": "Material", "value": "Acero inoxidable 304"}]'::jsonb, null, null, null, 'none', null, null, null, 108) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Cromo', '#c0c4c8', 'brillante', 'DEMO-INS-108-01', null, 10, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', 'mate', 'DEMO-INS-108-02', 300000, 34, 1),
  ((select id from p), 'Níquel cepillado', '#a8a49c', 'cepillado', 'DEMO-INS-108-03', 288000, 34, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Kit de anclaje para sanitario', 'instalacion', 'Sanitario', 'juego', '', 'DEMO-INS-109', 12000, 'Tornillos, chazos y tapas para fijar el sanitario al piso.', '[]'::jsonb, null, null, null, 'none', null, null, null, 109) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-INS-109-01', null, 9, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Sello de cera para sanitario', 'instalacion', 'Sanitario', 'unidad', '', 'DEMO-INS-110', 14000, 'Empaque entre la taza y el desagüe.', '[]'::jsonb, null, null, null, 'none', null, null, null, 110) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-110-01', null, 0, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Válvula de entrada (llenado) para tanque', 'instalacion', 'Sanitario', 'unidad', '', 'DEMO-INS-111', 32000, 'Repuesto universal de llenado.', '[]'::jsonb, null, null, null, 'none', null, null, null, 111) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-111-01', null, 11, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Válvula de descarga doble pulsador', 'instalacion', 'Sanitario', 'unidad', '', 'DEMO-INS-112', 55000, 'Repuesto de descarga para tanque.', '[]'::jsonb, null, null, null, 'none', null, null, null, 112) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-112-01', null, 3, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Acople de salida para sanitario', 'instalacion', 'Sanitario', 'unidad', '', 'DEMO-INS-113', 18000, 'Conexión del sanitario al tubo de 4".', '[{"label": "Diámetro", "value": "4\""}]'::jsonb, null, null, null, 'none', null, null, null, 113) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-113-01', null, 32, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Tubo PVC sanitario 2" × 3 m', 'instalacion', 'Tubería', 'unidad', '', 'DEMO-INS-114', 32000, 'Desagüe de lavamanos y ducha.', '[]'::jsonb, null, null, null, 'none', null, null, null, 114) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-114-01', null, 20, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Tubo PVC presión 1/2" × 6 m', 'instalacion', 'Tubería', 'unidad', '', 'DEMO-INS-115', 22000, 'Red de agua fría.', '[]'::jsonb, null, null, null, 'none', null, null, null, 115) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-115-01', null, 28, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Tubo CPVC 1/2" × 3 m (agua caliente)', 'instalacion', 'Tubería', 'unidad', '', 'DEMO-INS-116', 28000, 'Red de agua caliente.', '[]'::jsonb, null, null, null, 'none', null, null, null, 116) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-116-01', null, 25, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Cinta teflón 1/2"', 'instalacion', 'Sellantes', 'unidad', '', 'DEMO-INS-117', 3000, 'Sella las roscas.', '[]'::jsonb, null, null, null, 'none', null, null, null, 117) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-INS-117-01', null, 5, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Silicona antihongos 280 ml', 'instalacion', 'Sellantes', 'tubo', '', 'DEMO-INS-118', 26000, 'Sella juntas entre lavamanos, tina, división y pared.', '[]'::jsonb, null, null, null, 'none', null, null, null, 118) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Transparente', '#e9eeee', '', 'DEMO-INS-118-01', null, 35, 0),
  ((select id from p), 'Blanca', '#f4f4f2', '', 'DEMO-INS-118-02', null, 14, 1),
  ((select id from p), 'Negra', '#1f1f1f', '', 'DEMO-INS-118-03', 27000, 42, 2);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Pegante cerámico interior 25 kg', 'pegantes', 'Pegantes', 'bulto', '', 'DEMO-PEG-119', 28000, 'Para cerámica de pared y piso en interiores.', '[{"label": "Rendimiento", "value": "≈ 4–5 m²"}]'::jsonb, null, null, null, 'none', null, null, null, 119) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Gris', '#9c9c99', '', 'DEMO-PEG-119-01', null, 26, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Pegante para porcelanato 25 kg', 'pegantes', 'Pegantes', 'bulto', '', 'DEMO-PEG-120', 62000, 'Alta adherencia para porcelanato y gran formato.', '[{"label": "Rendimiento", "value": "≈ 3–4 m²"}]'::jsonb, null, null, null, 'none', null, null, null, 120) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Gris', '#9c9c99', '', 'DEMO-PEG-120-01', null, 21, 0),
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-PEG-120-02', 71000, 17, 1);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Pegante para zonas húmedas y piscinas 25 kg', 'pegantes', 'Pegantes', 'bulto', '', 'DEMO-PEG-121', 75000, 'Para duchas y zonas en contacto permanente con el agua.', '[]'::jsonb, null, null, null, 'none', null, null, null, 121) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Gris', '#9c9c99', '', 'DEMO-PEG-121-01', null, 8, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Boquilla (fragüe) sin arena 2 kg', 'pegantes', 'Boquillas', 'unidad', '', 'DEMO-PEG-122', 9000, 'Para juntas de 1 a 3 mm.', '[{"label": "Junta", "value": "1–3 mm"}]'::jsonb, null, null, null, 'none', null, null, null, 122) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-PEG-122-01', null, 0, 0),
  ((select id from p), 'Gris claro', '#bdbdb8', '', 'DEMO-PEG-122-02', null, 36, 1),
  ((select id from p), 'Gris basalto', '#5f6163', '', 'DEMO-PEG-122-03', null, 0, 2),
  ((select id from p), 'Negro', '#232323', '', 'DEMO-PEG-122-04', 9400, 25, 3),
  ((select id from p), 'Beige', '#d6c6a8', '', 'DEMO-PEG-122-05', null, 11, 4),
  ((select id from p), 'Café', '#6b4f3a', '', 'DEMO-PEG-122-06', null, 14, 5),
  ((select id from p), 'Terracota', '#b5653d', '', 'DEMO-PEG-122-07', 9400, 42, 6);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Boquilla con arena 5 kg', 'pegantes', 'Boquillas', 'unidad', '', 'DEMO-PEG-123', 18000, 'Para juntas de 3 a 10 mm.', '[{"label": "Junta", "value": "3–10 mm"}]'::jsonb, null, null, null, 'none', null, null, null, 123) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-PEG-123-01', null, 28, 0),
  ((select id from p), 'Gris claro', '#bdbdb8', '', 'DEMO-PEG-123-02', null, 23, 1),
  ((select id from p), 'Gris basalto', '#5f6163', '', 'DEMO-PEG-123-03', null, 0, 2),
  ((select id from p), 'Negro', '#232323', '', 'DEMO-PEG-123-04', 19000, 22, 3),
  ((select id from p), 'Beige', '#d6c6a8', '', 'DEMO-PEG-123-05', null, 39, 4);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Boquilla epóxica 2 kg', 'pegantes', 'Boquillas', 'unidad', '', 'DEMO-PEG-124', 115000, 'Impermeable y antimanchas, ideal para duchas.', '[{"label": "Junta", "value": "1–10 mm"}]'::jsonb, null, null, null, 'none', null, null, null, 124) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-PEG-124-01', null, 32, 0),
  ((select id from p), 'Gris claro', '#bdbdb8', '', 'DEMO-PEG-124-02', null, 5, 1),
  ((select id from p), 'Gris basalto', '#5f6163', '', 'DEMO-PEG-124-03', null, 0, 2),
  ((select id from p), 'Negro', '#232323', '', 'DEMO-PEG-124-04', 121000, 0, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Impermeabilizante flexible para duchas', 'pegantes', 'Impermeabilizantes', 'galon', '', 'DEMO-PEG-125', 98000, 'Se aplica antes de enchapar la zona húmeda.', '[{"label": "Rendimiento", "value": "≈ 4 m² a 2 manos"}]'::jsonb, null, null, null, 'none', null, null, null, 125) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-PEG-125-01', null, 29, 0);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Perfil esquinero de aluminio 2,5 m', 'pegantes', 'Remates', 'unidad', '', 'DEMO-PEG-126', 22000, 'Remate para esquinas de cerámica.', '[{"label": "Altura", "value": "10 mm"}]'::jsonb, null, null, null, 'none', null, null, null, 126) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Plata mate', '#b9bbbd', '', 'DEMO-PEG-126-01', null, 10, 0),
  ((select id from p), 'Negro mate', '#1f1f1f', '', 'DEMO-PEG-126-02', 26000, 0, 1),
  ((select id from p), 'Dorado', '#c8a96a', '', 'DEMO-PEG-126-03', 29000, 8, 2),
  ((select id from p), 'Blanco', '#f4f4f2', '', 'DEMO-PEG-126-04', null, 24, 3);

with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ('Crucetas niveladoras 2 mm (100 und)', 'pegantes', 'Herramienta', 'unidad', '', 'DEMO-PEG-127', 8000, 'Separadores para juntas parejas.', '[]'::jsonb, null, null, null, 'none', null, null, null, 127) returning id)
insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values
  ((select id from p), 'Único', null, '', 'DEMO-PEG-127-01', null, 29, 0);

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

-- Resumen: ceramica 13, sanitarios 12, lavamanos 9, griferia 14, duchas 17, divisiones 6, tinas 5, muebles 8, espejos 6, accesorios 14, instalacion 22, pegantes 9 · 135 productos, 546 variantes.
