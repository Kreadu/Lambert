"""Genera supabase/004-catalogo-demo.sql: catálogo de referencia de todo lo que lleva un baño.

Productos genéricos (sin marca) con los modelos, medidas y colores comunes en el mercado colombiano.
Los PRECIOS son de referencia aproximada en COP y el STOCK es de prueba: reemplázalos por los reales.
Todos los SKU empiezan por DEMO-, así el SQL puede borrarlos y volver a cargarlos sin tocar lo tuyo.

Uso: python3 tools/generar_catalogo.py
"""
import hashlib
import json
from pathlib import Path

# ── Paletas (nombre, color hex, acabado, factor de precio) ──
METAL = [
    ("Cromo", "#c0c4c8", "brillante", 1.0),
    ("Negro mate", "#1f1f1f", "mate", 1.2),
    ("Níquel cepillado", "#a8a49c", "cepillado", 1.15),
    ("Dorado cepillado", "#c8a96a", "cepillado", 1.35),
    ("Oro rosa", "#c99a86", "cepillado", 1.35),
    ("Grafito", "#4a4c50", "cepillado", 1.25),
    ("Blanco mate", "#f2f2f0", "mate", 1.2),
]
METAL_BASIC = METAL[:4]
LOZA = [
    ("Blanco", "#f7f7f5", "brillante", 1.0),
    ("Hueso", "#ece4d3", "brillante", 1.05),
    ("Negro mate", "#222222", "mate", 1.45),
    ("Gris mate", "#8d8f91", "mate", 1.4),
]
LOZA_BASIC = LOZA[:2]
MADERA = [
    ("Blanco", "#f4f4f2", "mate", 1.0),
    ("Roble claro", "#c4a27a", "texturizado", 1.08),
    ("Nogal", "#6e4b33", "texturizado", 1.08),
    ("Wengue", "#3b2a20", "texturizado", 1.08),
    ("Gris grafito", "#55585c", "mate", 1.05),
    ("Verde salvia", "#8fa58f", "mate", 1.12),
    ("Negro", "#1f1f1f", "mate", 1.1),
]
PERFIL = [("Cromo", "#c0c4c8", "brillante", 1.0), ("Negro mate", "#1f1f1f", "mate", 1.15), ("Dorado", "#c8a96a", "cepillado", 1.3)]
VIDRIO = [("Transparente", "#dfeef0", "templado 8 mm", 1.0), ("Esmerilado", "#eef2f2", "templado 8 mm", 1.1), ("Fumé", "#7d8085", "templado 8 mm", 1.2), ("Bronce", "#a07e5c", "templado 8 mm", 1.2)]
MARCO = [("Sin marco", "#dfe5e6", "bisel", 1.0), ("Marco negro", "#1f1f1f", "mate", 1.15), ("Marco dorado", "#c8a96a", "cepillado", 1.25), ("Marco madera", "#a37b52", "natural", 1.2)]
BOQUILLA = [
    ("Blanco", "#f4f4f2", "", 1.0), ("Gris claro", "#bdbdb8", "", 1.0), ("Gris basalto", "#5f6163", "", 1.0),
    ("Negro", "#232323", "", 1.05), ("Beige", "#d6c6a8", "", 1.0), ("Café", "#6b4f3a", "", 1.0), ("Terracota", "#b5653d", "", 1.05),
]
UNICO = [("Único", None, "", 1.0)]


def v(*items):
    return list(items)


# ── Catálogo ──
# (categoría, subcategoría, nombre, unidad, precio base COP, medidas (ancho, alto, fondo) cm | None,
#  pieza cerámica (ancho, alto, uso) | None, ubicación 3D | None (= la de la categoría), descripción,
#  ficha técnica [(dato, valor)], variantes [(nombre, hex, acabado, factor)])
P = []


def add(cat, sub, name, unit, price, dims, desc, feats, variants, tile=None, placement=None):
    P.append(dict(cat=cat, sub=sub, name=name, unit=unit, price=price, dims=dims, tile=tile,
                  placement=placement, desc=desc, feats=feats, variants=variants))


# Cerámica y baldosas (precio por m²)
def tile(sub, name, price, tw, th, use, desc, feats, variants):
    add("ceramica", sub, name, "m2", price, None, desc, feats, variants, tile=(tw, th, use))


tile("Porcelanato", "Porcelanato liso 60×60", 62000, 60, 60, "both",
     "Porcelanato esmaltado de formato cuadrado, para piso y pared. Junta mínima de 2 mm.",
     [("Espesor", "9 mm"), ("Tráfico", "Alto (PEI 4)"), ("Absorción", "< 0,5 %"), ("Piezas por caja", "4 (1,44 m²)")],
     v(("Blanco", "#f1f1ee", "mate", 1), ("Gris claro", "#c9c9c6", "mate", 1), ("Gris oscuro", "#6b6b6b", "mate", 1),
       ("Beige", "#d9c9ad", "mate", 1), ("Negro", "#2a2a2a", "mate", 1.1), ("Blanco brillante", "#f6f6f4", "brillante", 1.05)))
tile("Porcelanato", "Porcelanato tipo mármol 60×120", 118000, 60, 120, "both",
     "Gran formato con veta de mármol. Pocas juntas: el baño se ve más amplio.",
     [("Espesor", "9 mm"), ("Rectificado", "Sí"), ("Piezas por caja", "2 (1,44 m²)")],
     v(("Carrara", "#e9e9e6", "brillante", 1), ("Calacatta", "#efe9df", "brillante", 1.1), ("Negro Marquina", "#1c1c1c", "brillante", 1.15),
       ("Travertino", "#d8c7a8", "mate", 1.05), ("Gris Pulpis", "#8a8580", "mate", 1.05)))
tile("Porcelanato", "Porcelanato tipo madera 20×120", 79000, 20, 120, "floor",
     "Tablón con textura de madera, cálido y resistente al agua.",
     [("Espesor", "9 mm"), ("Antideslizante", "R10"), ("Piezas por caja", "6 (1,44 m²)")],
     v(("Roble claro", "#c4a27a", "texturizado", 1), ("Nogal", "#6e4b33", "texturizado", 1), ("Gris ceniza", "#9a948c", "texturizado", 1),
       ("Miel", "#b98a52", "texturizado", 1)))
tile("Porcelanato", "Porcelanato tipo cemento 60×60", 66000, 60, 60, "both",
     "Acabado de cemento pulido, estilo industrial.",
     [("Espesor", "9 mm"), ("Tráfico", "Alto"), ("Piezas por caja", "4 (1,44 m²)")],
     v(("Cemento claro", "#b9b6af", "mate", 1), ("Cemento gris", "#8f8d88", "mate", 1), ("Antracita", "#4b4b4a", "mate", 1)))
tile("Cerámica de pared", "Cerámica de pared 30×60", 39000, 30, 60, "wall",
     "Revestimiento de pared para zonas húmedas. Fácil de cortar e instalar.",
     [("Espesor", "8 mm"), ("Piezas por caja", "8 (1,44 m²)")],
     v(("Blanco brillante", "#f6f6f4", "brillante", 1), ("Blanco mate", "#efefec", "mate", 1), ("Gris perla", "#d2d2cf", "mate", 1),
       ("Beige arena", "#ddd0b8", "mate", 1), ("Blanco con relieve", "#f1f1ee", "relieve", 1.15)))
tile("Cerámica de pared", "Cerámica de pared 25×40", 29000, 25, 40, "wall",
     "Formato económico y clásico para paredes de baño.",
     [("Espesor", "7 mm"), ("Piezas por caja", "15 (1,5 m²)")],
     v(("Blanco", "#f6f6f4", "brillante", 1), ("Hueso", "#ece4d3", "brillante", 1), ("Gris", "#c9c9c6", "brillante", 1)))
tile("Cerámica de piso", "Cerámica de piso 45×45", 34000, 45, 45, "floor",
     "Piso cerámico de tráfico medio, económico.",
     [("Tráfico", "Medio (PEI 3)"), ("Piezas por caja", "10 (2,02 m²)")],
     v(("Blanco", "#efefec", "mate", 1), ("Beige", "#d9c9ad", "mate", 1), ("Gris", "#a9a9a6", "mate", 1), ("Tipo piedra", "#b3a891", "rústico", 1.05)))
tile("Antideslizante", "Piso antideslizante para ducha 30×30", 48000, 30, 30, "floor",
     "Baldosa con textura antideslizante para la zona de ducha.",
     [("Antideslizante", "R11"), ("Piezas por caja", "11 (1 m²)")],
     v(("Blanco", "#efefec", "antideslizante", 1), ("Gris", "#9c9c99", "antideslizante", 1), ("Beige", "#d9c9ad", "antideslizante", 1),
       ("Negro", "#2a2a2a", "antideslizante", 1.05)))
tile("Subway / metro", "Subway metro 7,5×15", 85000, 7.5, 15, "wall",
     "Ladrillo biselado tipo metro, ideal para la pared de la ducha o detrás del lavamanos.",
     [("Biselado", "Sí"), ("m² por caja", "0,5")],
     v(("Blanco", "#f6f6f4", "brillante", 1), ("Negro", "#1f1f1f", "brillante", 1), ("Verde botella", "#3f6650", "brillante", 1.05),
       ("Azul petróleo", "#2f5566", "brillante", 1.05), ("Rosa empolvado", "#e3c4bd", "brillante", 1.05), ("Gris", "#a5a7a8", "mate", 1)))
tile("Mosaico", "Mosaico de vidrio 30×30 (malla)", 95000, 30, 30, "wall",
     "Pastillas de vidrio en malla, para franjas decorativas y nichos.",
     [("Pastilla", "2,5 × 2,5 cm"), ("Mallas por m²", "11")],
     v(("Azul mar", "#3d7ea6", "vidrio", 1), ("Verde agua", "#7fb7a8", "vidrio", 1), ("Blanco perla", "#eeeeea", "vidrio", 1),
       ("Mix grises", "#8f9396", "vidrio", 1), ("Mix dorado", "#c3a46c", "vidrio", 1.25)))
tile("Mosaico", "Mosaico hexagonal 26×30 (malla)", 110000, 26, 30, "both",
     "Hexágonos en malla, para piso de ducha o pared de acento.",
     [("Hexágono", "5 cm"), ("Mallas por m²", "13")],
     v(("Blanco", "#f1f1ee", "mate", 1), ("Negro", "#232323", "mate", 1), ("Mármol Carrara", "#e6e6e3", "pulido", 1.4),
       ("Terrazo", "#d8d2c8", "mate", 1.15)))
tile("Decorado", "Listelo / cenefa decorativa 8×60", 18000, 8, 60, "wall",
     "Franja decorativa que se combina con la cerámica de pared. Se vende por pieza.",
     [("Uso", "Franja horizontal")],
     v(("Vidrio plata", "#c9ccce", "vidrio", 1), ("Vidrio dorado", "#c8a96a", "vidrio", 1.1), ("Piedra", "#a69a86", "natural", 1.2),
       ("Metálico negro", "#2a2a2a", "metálico", 1.1)))
P[-1]["unit"] = "unidad"
tile("Decorado", "Baldosa hidráulica 20×20", 140000, 20, 20, "both",
     "Diseños geométricos estilo hidráulico, para piso o pared de acento.",
     [("Espesor", "9 mm"), ("Piezas por caja", "25 (1 m²)")],
     v(("Geométrico gris", "#9b9d9f", "mate", 1), ("Floral azul", "#4d6f96", "mate", 1), ("Estrella negro y blanco", "#5a5a5a", "mate", 1),
       ("Terracota", "#b5653d", "mate", 1)))

# Sanitarios
add("sanitarios", "One piece", "Sanitario one piece alongado", "unidad", 890000, (38, 72, 70),
    "Tanque y taza en una sola pieza: más fácil de limpiar. Descarga de doble pulsador.",
    [("Consumo", "4,8 L / 3 L doble descarga"), ("Distancia a pared (rough)", "30 cm"), ("Asiento", "Cierre lento incluido")], LOZA)
add("sanitarios", "Dos piezas", "Sanitario dos piezas redondo", "unidad", 380000, (37, 76, 68),
    "Modelo clásico de tanque y taza separados. Económico y de fácil mantenimiento.",
    [("Consumo", "6 L"), ("Distancia a pared (rough)", "30 cm"), ("Asiento", "Incluido")], LOZA_BASIC)
add("sanitarios", "Dos piezas", "Sanitario dos piezas alongado ahorrador", "unidad", 520000, (38, 78, 72),
    "Taza alongada más cómoda, con tanque ahorrador.",
    [("Consumo", "4,8 L"), ("Distancia a pared (rough)", "30 cm")], LOZA)
add("sanitarios", "Suspendido", "Sanitario suspendido de pared", "unidad", 1150000, (36, 36, 54),
    "Se cuelga de la pared con tanque oculto: libera el piso y se ve moderno. Requiere estructura empotrada.",
    [("Consumo", "4,5 L / 3 L"), ("Requiere", "Tanque empotrado y bastidor")], LOZA, placement="wall")
add("sanitarios", "Smart", "Sanitario inteligente con bidé", "unidad", 3900000, (40, 50, 70),
    "Asiento calefactado, bidé integrado con agua tibia, secado y descarga automática.",
    [("Alimentación", "110 V"), ("Funciones", "Bidé, secado, asiento calefactado, luz nocturna")],
    v(("Blanco", "#f7f7f5", "brillante", 1), ("Negro mate", "#222222", "mate", 1.1)))
add("sanitarios", "Infantil", "Sanitario infantil", "unidad", 450000, (32, 56, 52),
    "Altura reducida para jardines, colegios y baños de niños.",
    [("Altura de la taza", "30 cm")], v(("Blanco", "#f7f7f5", "brillante", 1)))
add("sanitarios", "Bidé", "Bidé de piso", "unidad", 420000, (36, 40, 54),
    "Complemento para la higiene personal. Se combina con el sanitario de la misma línea.",
    [("Grifería", "No incluida")], LOZA)
add("sanitarios", "Orinal", "Orinal de pared", "unidad", 480000, (36, 60, 33),
    "Orinal con fluxómetro o con sensor (fluxómetro aparte).", [("Consumo", "1 L")], LOZA_BASIC, placement="wall")
add("sanitarios", "Asiento", "Asiento sanitario con cierre lento", "unidad", 120000, (36, 5, 46),
    "Tapa de repuesto con bisagras de cierre lento y desmonte rápido.", [("Material", "Polipropileno")], LOZA, placement="none")
add("sanitarios", "Tanque", "Tanque empotrado con pulsador para sanitario suspendido", "unidad", 980000, (50, 112, 12),
    "Bastidor y tanque que van dentro del muro, con pulsador de doble descarga.",
    [("Incluye", "Bastidor, tanque, pulsador")], METAL[:3], placement="none")

# Lavamanos
add("lavamanos", "De pedestal", "Lavamanos de pedestal", "unidad", 260000, (55, 85, 45),
    "Lavamanos con columna que oculta el sifón. Clásico y económico.",
    [("Perforación grifería", "Monocontrol o 4\""), ("Rebose", "Sí")], LOZA, placement="floor")
add("lavamanos", "Semipedestal", "Lavamanos de semipedestal", "unidad", 310000, (50, 45, 44),
    "Va colgado a la pared con medio pedestal: deja libre el piso.",
    [("Perforación grifería", "Monocontrol")], LOZA)
add("lavamanos", "De sobreponer", "Lavamanos de sobreponer redondo", "unidad", 290000, (40, 14, 40),
    "Lavamanos tipo vessel que va encima del mueble o mesón. Requiere grifería alta o de pared.",
    [("Rebose", "No"), ("Grifería", "Alta o de pared")],
    v(("Blanco", "#f7f7f5", "brillante", 1), ("Negro mate", "#222222", "mate", 1.3), ("Gris mate", "#8d8f91", "mate", 1.3),
      ("Piedra natural", "#9c968a", "natural", 2.2), ("Terrazo", "#d8d2c8", "mate", 1.6)))
add("lavamanos", "De sobreponer", "Lavamanos de sobreponer rectangular", "unidad", 320000, (50, 13, 38),
    "Vessel rectangular de líneas rectas.", [("Rebose", "No")], LOZA)
add("lavamanos", "De empotrar", "Lavamanos de empotrar bajo cubierta", "unidad", 230000, (49, 18, 36),
    "Se instala debajo del mesón de piedra o cuarzo: superficie continua, fácil de limpiar.",
    [("Requiere", "Mesón con corte")], LOZA_BASIC)
add("lavamanos", "De empotrar", "Lavamanos de empotrar sobre cubierta", "unidad", 240000, (52, 18, 42),
    "El borde queda apoyado sobre el mesón.", [("Perforación grifería", "Monocontrol")], LOZA_BASIC)
add("lavamanos", "Suspendido", "Lavamanos suspendido de pared", "unidad", 360000, (60, 15, 45),
    "Se fija directo a la pared, sin mueble ni pedestal.", [("Perforación grifería", "Monocontrol")], LOZA)
add("lavamanos", "Esquinero", "Lavamanos esquinero", "unidad", 210000, (42, 15, 42),
    "Para baños pequeños: aprovecha la esquina.", [("Perforación grifería", "Monocontrol")], LOZA_BASIC)
add("lavamanos", "Integrado", "Lavamanos integrado para mueble", "unidad", 280000, (61, 12, 46),
    "Lavamanos de cerámica que encaja en el mueble del mismo ancho.", [("Para mueble de", "60 cm")], LOZA_BASIC)

# Grifería
add("griferia", "Lavamanos", "Grifería monocontrol baja para lavamanos", "unidad", 230000, (5, 16, 13),
    "Una sola manija para agua fría y caliente. Cartucho cerámico.",
    [("Cartucho", "Cerámico 35 mm"), ("Incluye", "Flexibles de 40 cm")], METAL)
add("griferia", "Lavamanos", "Grifería monocontrol alta para lavamanos de sobreponer", "unidad", 360000, (5, 30, 18),
    "Cuerpo alto para lavamanos tipo vessel.", [("Cartucho", "Cerámico 35 mm")], METAL)
add("griferia", "Lavamanos", "Grifería de lavamanos 4\" dos llaves", "unidad", 160000, (16, 10, 12),
    "Llaves separadas para agua fría y caliente, centro a centro de 4\".", [("Centros", "4\" (10 cm)")], METAL_BASIC)
add("griferia", "Lavamanos", "Mezclador de lavamanos 8\" tres piezas", "unidad", 420000, (20, 15, 14),
    "Pico y dos manijas separadas, centros de 8\".", [("Centros", "8\" (20 cm)")], METAL)
add("griferia", "Lavamanos", "Grifería de pared para lavamanos (empotrar)", "unidad", 480000, (18, 8, 20),
    "Pico que sale de la pared; el cuerpo va empotrado.", [("Incluye", "Cuerpo de empotrar")], METAL)
add("griferia", "Lavamanos", "Grifería temporizada push", "unidad", 210000, (5, 12, 12),
    "Se cierra sola: ahorro de agua para baños de alto tráfico.", [("Tiempo", "≈ 7 s")], METAL_BASIC)
add("griferia", "Lavamanos", "Grifería con sensor", "unidad", 650000, (5, 16, 13),
    "Abre con el movimiento de las manos, sin tocar.", [("Alimentación", "Baterías")], METAL[:3])
add("griferia", "Ducha", "Mezclador monocontrol de ducha (empotrar)", "unidad", 340000, (16, 16, 8),
    "Controla temperatura y caudal con una manija.", [("Salidas", "1")], METAL)
add("griferia", "Ducha", "Mezclador de ducha con desviador", "unidad", 520000, (16, 26, 9),
    "Monocontrol con desviador para regadera y ducha teléfono.", [("Salidas", "2")], METAL)
add("griferia", "Ducha", "Mezclador termostático", "unidad", 980000, (30, 10, 10),
    "Mantiene la temperatura fija aunque cambie la presión.", [("Salidas", "2")], METAL[:4])
add("griferia", "Ducha", "Llaves de ducha dos manijas", "juego", 150000, (30, 8, 8),
    "Juego clásico de llave de agua fría y caliente.", [("Incluye", "2 llaves + chapetones")], METAL_BASIC)
add("griferia", "Tina", "Grifería de tina con ducha teléfono", "unidad", 690000, (30, 15, 15),
    "Mezclador para tina con desviador a ducha teléfono.", [("Montaje", "Pared")], METAL)
add("griferia", "Bidé", "Grifería para bidé", "unidad", 260000, (5, 14, 12), "Monocontrol con aireador orientable.", [], METAL_BASIC)
add("griferia", "Orinal", "Fluxómetro para orinal", "unidad", 390000, (8, 30, 12), "Válvula de descarga para orinal.", [], METAL[:1])

# Duchas
add("duchas", "Regadera", "Regadera tipo lluvia redonda 20 cm", "unidad", 120000, (20, 1, 20),
    "Regadera ancha que cae como lluvia.", [("Diámetro", "20 cm"), ("Boquillas", "Antisarro")], METAL)
add("duchas", "Regadera", "Regadera tipo lluvia redonda 30 cm", "unidad", 210000, (30, 1, 30), "Mayor cobertura de agua.", [("Diámetro", "30 cm")], METAL)
add("duchas", "Regadera", "Regadera tipo lluvia cuadrada 25×25", "unidad", 190000, (25, 1, 25), "Diseño cuadrado, estilo moderno.", [], METAL)
add("duchas", "Regadera", "Regadera de techo empotrada 40×40", "unidad", 620000, (40, 1, 40), "Se empotra en el cielo raso.", [], METAL[:4])
add("duchas", "Brazo", "Brazo de ducha de pared 40 cm", "unidad", 75000, (4, 4, 40), "Sostiene la regadera desde la pared.", [], METAL)
add("duchas", "Brazo", "Brazo de ducha de techo 30 cm", "unidad", 85000, (4, 30, 4), "Bajante para regadera desde el techo.", [], METAL)
add("duchas", "Teléfono", "Ducha teléfono con manguera 1,5 m", "unidad", 95000, (8, 25, 5), "Ducha de mano con soporte de pared.", [("Funciones", "3")], METAL)
add("duchas", "Barra", "Barra deslizable con ducha teléfono", "unidad", 230000, (8, 70, 8), "La altura de la ducha de mano se ajusta.", [], METAL)
add("duchas", "Sistema", "Columna de ducha completa", "unidad", 890000, (25, 115, 45),
    "Regadera lluvia, ducha teléfono y mezclador en un solo sistema.", [("Incluye", "Mezclador, regadera, teléfono")], METAL)
add("duchas", "Eléctrica", "Ducha eléctrica", "unidad", 110000, (16, 18, 10), "Calienta el agua en el punto.", [("Voltaje", "120 V"), ("Potencia", "3500 W")],
    v(("Blanco", "#f4f4f2", "brillante", 1)))
add("duchas", "Nicho", "Nicho de ducha empotrado 30×60", "unidad", 280000, (30, 60, 10), "Repisa empotrada en la pared de la ducha.", [("Material", "Acero inoxidable")],
    METAL[:3])

# Divisiones
add("divisiones", "Corrediza", "División de baño corrediza 1,20 m", "unidad", 980000, (120, 190, 4),
    "Vidrio templado con puerta corrediza: ahorra espacio.", [("Vidrio", "Templado 8 mm"), ("Ancho", "Ajustable 110–120 cm")], VIDRIO)
add("divisiones", "Batiente", "División de baño batiente (abatible) 0,90 m", "unidad", 820000, (90, 190, 4),
    "Puerta que abre hacia afuera.", [("Vidrio", "Templado 8 mm")], VIDRIO)
add("divisiones", "Panel fijo", "Panel fijo walk-in 0,90 m", "unidad", 690000, (90, 200, 4),
    "Vidrio fijo sin puerta, estilo moderno.", [("Vidrio", "Templado 8 mm"), ("Incluye", "Barra de soporte")], VIDRIO)
add("divisiones", "Esquinera", "División esquinera cuadrada 90×90", "unidad", 1350000, (90, 190, 90),
    "Para duchas en esquina, con dos puertas corredizas.", [("Vidrio", "Templado 6 mm")], VIDRIO[:2])
add("divisiones", "Perfilería", "Perfilería para división de baño", "juego", 180000, None,
    "Rieles, rodachines y herrajes para la división.", [("Material", "Aluminio")], PERFIL, placement="none")
add("divisiones", "Cortina", "Cortina de baño con barra extensible", "juego", 75000, (120, 180, 2),
    "Opción económica en lugar de la división de vidrio.", [("Barra", "Extensible 110–200 cm")],
    v(("Blanca", "#f4f4f2", "tela", 1), ("Gris", "#9c9c99", "tela", 1), ("Rayas", "#c9b79c", "tela", 1)))

# Tinas y platos de ducha
add("tinas", "Tina", "Tina acrílica de empotrar 1,50 m", "unidad", 1250000, (150, 50, 70), "Tina rectangular para enchapar el frente.", [("Capacidad", "180 L")], LOZA_BASIC)
add("tinas", "Tina", "Tina exenta (freestanding) 1,60 m", "unidad", 3600000, (160, 58, 75), "Tina independiente, protagonista del baño.", [("Capacidad", "220 L")],
    v(("Blanco", "#f7f7f5", "brillante", 1), ("Negro mate exterior", "#222222", "mate", 1.15)))
add("tinas", "Tina", "Tina de hidromasaje 1,70 m", "unidad", 5900000, (170, 60, 80), "Con jets de masaje y motor.", [("Jets", "6"), ("Voltaje", "120 V")], LOZA_BASIC)
add("tinas", "Plato de ducha", "Plato de ducha acrílico 80×80", "unidad", 390000, (80, 6, 80), "Receptáculo para ducha cuadrada.", [("Desagüe", "Incluido")], LOZA_BASIC)
add("tinas", "Plato de ducha", "Plato de ducha en resina 70×120", "unidad", 980000, (120, 3, 70), "Textura pizarra antideslizante, extraplano.", [("Desagüe", "Incluido")],
    v(("Blanco", "#f1f1ee", "pizarra", 1), ("Gris", "#8f8d88", "pizarra", 1), ("Negro", "#2a2a2a", "pizarra", 1), ("Beige", "#d9c9ad", "pizarra", 1)))

# Muebles
add("muebles", "Mueble de lavamanos", "Mueble de lavamanos suspendido 60 cm", "unidad", 680000, (60, 50, 46),
    "Mueble flotante con cajón y lavamanos integrado.", [("Incluye", "Lavamanos integrado"), ("Cajones", "1")], MADERA, placement="wall")
add("muebles", "Mueble de lavamanos", "Mueble de lavamanos suspendido 80 cm", "unidad", 890000, (80, 50, 46),
    "Dos cajones y lavamanos integrado.", [("Cajones", "2")], MADERA, placement="wall")
add("muebles", "Mueble de lavamanos", "Mueble de lavamanos de piso 100 cm doble", "unidad", 1650000, (100, 85, 48),
    "Para dos lavamanos, con puertas y entrepaño.", [("Lavamanos", "2 (no incluidos)")], MADERA)
add("muebles", "Mueble de lavamanos", "Mueble esquinero de piso 45 cm", "unidad", 420000, (45, 82, 45), "Aprovecha la esquina en baños pequeños.", [], MADERA[:4])
add("muebles", "Organizador", "Torre organizadora 30 cm", "unidad", 520000, (30, 160, 30), "Mueble alto para toallas y productos.", [("Entrepaños", "4")], MADERA)
add("muebles", "Organizador", "Mueble sobre sanitario", "unidad", 360000, (60, 170, 22), "Estantería que aprovecha el espacio arriba del sanitario.", [], MADERA[:5])
add("muebles", "Botiquín", "Gabinete botiquín con espejo 60 cm", "unidad", 390000, (60, 70, 14), "Espejo con almacenamiento detrás.", [("Puertas", "1")], MADERA[:5], placement="wall")
add("muebles", "Mesón", "Mesón en cuarzo para lavamanos (metro lineal)", "metro", 620000, (100, 2, 50),
    "Mesón a medida en cuarzo, 2 cm de espesor.", [("Espesor", "2 cm"), ("Profundidad", "50 cm")],
    v(("Blanco polar", "#f2f2f0", "pulido", 1), ("Calacatta", "#efe9df", "pulido", 1.25), ("Gris concreto", "#9a9893", "mate", 1.1), ("Negro absoluto", "#1d1d1d", "pulido", 1.1)))

# Espejos
add("espejos", "Redondo", "Espejo redondo 60 cm", "unidad", 180000, (60, 60, 3), "Espejo circular con o sin marco.", [], MARCO)
add("espejos", "Rectangular", "Espejo rectangular 60×80", "unidad", 160000, (60, 80, 3), "Espejo de bisel o con marco.", [], MARCO)
add("espejos", "LED", "Espejo LED antiempañante 60×80", "unidad", 520000, (60, 80, 4), "Iluminación LED perimetral, antiempañante y botón táctil.",
    [("Luz", "Fría / cálida / neutra"), ("Voltaje", "120 V")], v(("Sin marco", "#dfe5e6", "LED", 1), ("Marco negro", "#1f1f1f", "LED", 1.1)))
add("espejos", "LED", "Espejo LED redondo 70 cm", "unidad", 590000, (70, 70, 4), "Espejo redondo con luz posterior.", [("Voltaje", "120 V")],
    v(("Sin marco", "#dfe5e6", "LED", 1), ("Marco negro", "#1f1f1f", "LED", 1.1), ("Marco dorado", "#c8a96a", "LED", 1.2)))
add("espejos", "Orgánico", "Espejo orgánico 50×80", "unidad", 240000, (50, 80, 3), "Forma irregular, tendencia decorativa.", [], MARCO[:3])
add("espejos", "Ovalado", "Espejo ovalado tipo cápsula 50×90", "unidad", 230000, (50, 90, 3), "Forma de cápsula con marco metálico.", [], MARCO[:3])

# Accesorios
for sub, name, price, dims, desc in [
    ("Toallero", "Toallero de barra 60 cm", 85000, (60, 6, 8), "Barra para colgar toallas."),
    ("Toallero", "Toallero de aro", 55000, (18, 20, 6), "Aro para toalla de manos junto al lavamanos."),
    ("Toallero", "Toallero doble con repisa", 160000, (60, 10, 24), "Repisa superior y barra para toallas."),
    ("Portarrollo", "Portarrollo de papel higiénico", 45000, (15, 8, 8), "Soporte de pared para el papel."),
    ("Gancho", "Gancho doble (percha)", 30000, (5, 6, 6), "Para batas y toallas."),
    ("Jabonera", "Jabonera de pared", 40000, (12, 5, 11), "Con plato desmontable."),
    ("Dispensador", "Dispensador de jabón de pared", 65000, (8, 18, 10), "Dispensador de jabón líquido de 300 ml."),
    ("Repisa", "Repisa de vidrio 50 cm", 70000, (50, 4, 12), "Repisa de vidrio templado con soportes."),
    ("Repisa", "Repisa esquinera para ducha", 75000, (20, 5, 20), "Esquinera de dos niveles."),
    ("Seguridad", "Barra de apoyo 60 cm", 120000, (60, 8, 8), "Barra de seguridad para adultos mayores y movilidad reducida."),
    ("Set", "Juego de accesorios 5 piezas", 230000, None, "Toallero, aro, portarrollo, jabonera y gancho de la misma línea."),
]:
    add("accesorios", sub, name, "juego" if sub == "Set" else "unidad", price, dims, desc, [("Material", "Acero inoxidable / zamak")],
        METAL, placement="none" if sub == "Set" else None)
add("accesorios", "Papelera", "Papelera con pedal 5 L", "unidad", 75000, (20, 28, 20), "Cesta de basura con tapa de pedal.", [], METAL[:3] + [("Blanco", "#f4f4f2", "mate", 1)], placement="floor")
add("accesorios", "Extractor", "Extractor de olores 4\"", "unidad", 95000, (18, 18, 10), "Ventilación forzada para baños sin ventana.", [("Voltaje", "120 V"), ("Caudal", "90 m³/h")],
    v(("Blanco", "#f4f4f2", "", 1)))
add("accesorios", "Iluminación", "Aplique LED para espejo 40 cm", "unidad", 130000, (40, 4, 8), "Lámpara de pared sobre el espejo.", [("Potencia", "8 W")], METAL[:4])

# Instalación y plomería (no se dibujan en el 3D)
for sub, name, unit, price, desc, feats, variants in [
    ("Flexibles", "Manguera flexible para lavamanos 1/2\" × 40 cm", "unidad", 14000, "Conecta la llave de paso con la grifería del lavamanos.",
     [("Rosca", "1/2\" × 1/2\""), ("Malla", "Acero inoxidable")], v(("40 cm", None, "", 1), ("60 cm", None, "", 1.2), ("30 cm", None, "", 0.9))),
    ("Flexibles", "Manguera flexible para sanitario 7/8\" × 1/2\"", "unidad", 15000, "Conecta la llave de paso con el tanque del sanitario.",
     [("Rosca", "7/8\" × 1/2\"")], v(("40 cm", None, "", 1), ("30 cm", None, "", 0.9))),
    ("Flexibles", "Manguera flexible para mezclador monocontrol M10", "juego", 22000, "Par de flexibles con rosca M10 para grifería monocontrol.",
     [("Rosca", "M10 × 1/2\"")], v(("40 cm", None, "", 1), ("60 cm", None, "", 1.2))),
    ("Llaves de paso", "Llave de paso angular 1/2\" (control)", "unidad", 28000, "Válvula para cerrar el agua del lavamanos o del sanitario.",
     [("Rosca", "1/2\" × 1/2\"")], METAL_BASIC[:2]),
    ("Llaves de paso", "Válvula de bola 1/2\" de empotrar", "unidad", 38000, "Registro general del baño.", [("Rosca", "1/2\"")], v(("Bronce", "#b08d57", "", 1))),
    ("Sifones", "Sifón flexible para lavamanos 1 1/4\"", "unidad", 18000, "Sifón en PVC, económico y fácil de instalar.", [("Diámetro", "1 1/4\"")], v(("Blanco", "#f4f4f2", "", 1))),
    ("Sifones", "Sifón de botella cromado para lavamanos", "unidad", 95000, "Sifón decorativo para lavamanos sin pedestal.", [("Diámetro", "1 1/4\"")], METAL[:4]),
    ("Desagües", "Desagüe push (clic-clac) con rebose", "unidad", 45000, "Tapón que abre y cierra presionando.", [("Para", "Lavamanos con rebose")], METAL[:4]),
    ("Desagües", "Desagüe push (clic-clac) sin rebose", "unidad", 48000, "Para lavamanos de sobreponer sin rebose.", [("Para", "Lavamanos sin rebose")], METAL[:4]),
    ("Rejillas", "Rejilla de piso cuadrada 10×10 con sifón", "unidad", 35000, "Desagüe de piso para la ducha.", [("Salida", "2\"")], METAL[:3]),
    ("Rejillas", "Rejilla lineal para ducha 60 cm", "unidad", 210000, "Canal de desagüe largo y discreto.", [("Material", "Acero inoxidable 304")], METAL[:3]),
    ("Rejillas", "Rejilla lineal para ducha 80 cm", "unidad", 250000, "Canal de desagüe largo y discreto.", [("Material", "Acero inoxidable 304")], METAL[:3]),
    ("Sanitario", "Kit de anclaje para sanitario", "juego", 12000, "Tornillos, chazos y tapas para fijar el sanitario al piso.", [], v(("Blanco", "#f4f4f2", "", 1))),
    ("Sanitario", "Sello de cera para sanitario", "unidad", 14000, "Empaque entre la taza y el desagüe.", [], UNICO),
    ("Sanitario", "Válvula de entrada (llenado) para tanque", "unidad", 32000, "Repuesto universal de llenado.", [], UNICO),
    ("Sanitario", "Válvula de descarga doble pulsador", "unidad", 55000, "Repuesto de descarga para tanque.", [], UNICO),
    ("Sanitario", "Acople de salida para sanitario", "unidad", 18000, "Conexión del sanitario al tubo de 4\".", [("Diámetro", "4\"")], UNICO),
    ("Tubería", "Tubo PVC sanitario 2\" × 3 m", "unidad", 32000, "Desagüe de lavamanos y ducha.", [], UNICO),
    ("Tubería", "Tubo PVC presión 1/2\" × 6 m", "unidad", 22000, "Red de agua fría.", [], UNICO),
    ("Tubería", "Tubo CPVC 1/2\" × 3 m (agua caliente)", "unidad", 28000, "Red de agua caliente.", [], UNICO),
    ("Sellantes", "Cinta teflón 1/2\"", "unidad", 3000, "Sella las roscas.", [], UNICO),
    ("Sellantes", "Silicona antihongos 280 ml", "tubo", 26000, "Sella juntas entre lavamanos, tina, división y pared.", [],
     v(("Transparente", "#e9eeee", "", 1), ("Blanca", "#f4f4f2", "", 1), ("Negra", "#1f1f1f", "", 1.05))),
]:
    add("instalacion", sub, name, unit, price, None, desc, feats, variants)

# Pegantes y boquillas
for sub, name, unit, price, desc, feats, variants in [
    ("Pegantes", "Pegante cerámico interior 25 kg", "bulto", 28000, "Para cerámica de pared y piso en interiores.", [("Rendimiento", "≈ 4–5 m²")], v(("Gris", "#9c9c99", "", 1))),
    ("Pegantes", "Pegante para porcelanato 25 kg", "bulto", 62000, "Alta adherencia para porcelanato y gran formato.", [("Rendimiento", "≈ 3–4 m²")],
     v(("Gris", "#9c9c99", "", 1), ("Blanco", "#f4f4f2", "", 1.15))),
    ("Pegantes", "Pegante para zonas húmedas y piscinas 25 kg", "bulto", 75000, "Para duchas y zonas en contacto permanente con el agua.", [], v(("Gris", "#9c9c99", "", 1))),
    ("Boquillas", "Boquilla (fragüe) sin arena 2 kg", "unidad", 9000, "Para juntas de 1 a 3 mm.", [("Junta", "1–3 mm")], BOQUILLA),
    ("Boquillas", "Boquilla con arena 5 kg", "unidad", 18000, "Para juntas de 3 a 10 mm.", [("Junta", "3–10 mm")], BOQUILLA[:5]),
    ("Boquillas", "Boquilla epóxica 2 kg", "unidad", 115000, "Impermeable y antimanchas, ideal para duchas.", [("Junta", "1–10 mm")], BOQUILLA[:4]),
    ("Impermeabilizantes", "Impermeabilizante flexible para duchas", "galon", 98000, "Se aplica antes de enchapar la zona húmeda.", [("Rendimiento", "≈ 4 m² a 2 manos")], UNICO),
    ("Remates", "Perfil esquinero de aluminio 2,5 m", "unidad", 22000, "Remate para esquinas de cerámica.", [("Altura", "10 mm")],
     v(("Plata mate", "#b9bbbd", "", 1), ("Negro mate", "#1f1f1f", "", 1.2), ("Dorado", "#c8a96a", "", 1.3), ("Blanco", "#f4f4f2", "", 1))),
    ("Herramienta", "Crucetas niveladoras 2 mm (100 und)", "unidad", 8000, "Separadores para juntas parejas.", [], UNICO),
]:
    add("pegantes", sub, name, unit, price, None, desc, feats, variants)


# ── SQL ──
def q(s):
    return "null" if s is None else "'" + str(s).replace("'", "''") + "'"


def n(x):
    return "null" if x is None else repr(x)


def stock(sku):
    h = int(hashlib.md5(sku.encode()).hexdigest(), 16)
    return 0 if h % 7 == 0 else 3 + h % 40  # ~1 de cada 7 agotado, para probar


def round_price(x):
    return int(round(x / 1000.0) * 1000) if x >= 10000 else int(round(x / 100.0) * 100)


CAT_PLACEMENT = {"ceramica": "surface", "sanitarios": "floor", "lavamanos": "wall", "griferia": "wall", "duchas": "wall",
                 "divisiones": "floor", "tinas": "floor", "muebles": "floor", "espejos": "wall", "accesorios": "wall",
                 "instalacion": "none", "pegantes": "none"}

out = [
    "-- Lambert · 004 · catálogo de referencia de baño (GENERADO por tools/generar_catalogo.py; no editar a mano).",
    "-- Productos genéricos con modelos, medidas y colores comunes. PRECIOS de referencia aproximada en COP y STOCK de prueba:",
    "-- reemplázalos por los reales desde admin.html. Correr después de 003. Se puede repetir: borra y recarga solo los DEMO-.",
    "",
    "begin;",
    "delete from public.products where sku like 'DEMO-%';",
    "",
]
counts = {}
for i, p in enumerate(P, 1):
    counts[p["cat"]] = counts.get(p["cat"], 0) + 1
    sku = f"DEMO-{p['cat'][:3].upper()}-{i:03d}"
    w, h, d = p["dims"] or (None, None, None)
    tw, th, use = p["tile"] or (None, None, None)
    placement = p["placement"] or CAT_PLACEMENT[p["cat"]]
    feats = json.dumps([{"label": a, "value": b} for a, b in p["feats"]], ensure_ascii=False)
    out.append(
        "with p as (insert into public.products (name, category, subcategory, unit, brand, sku, price, description, features, "
        "width_cm, height_cm, depth_cm, placement, tile_width_cm, tile_height_cm, surface_use, position) values ("
        f"{q(p['name'])}, {q(p['cat'])}, {q(p['sub'])}, {q(p['unit'])}, '', {q(sku)}, {p['price']}, {q(p['desc'])}, {q(feats)}::jsonb, "
        f"{n(w)}, {n(h)}, {n(d)}, {q(placement)}, {n(tw)}, {n(th)}, {q(use)}, {i}) returning id)"
    )
    rows = []
    for j, (vn, hex_, fin, factor) in enumerate(p["variants"]):
        vsku = f"{sku}-{j + 1:02d}"
        vprice = None if factor == 1 else round_price(p["price"] * factor)
        rows.append(f"((select id from p), {q(vn)}, {q(hex_)}, {q(fin)}, {q(vsku)}, {n(vprice)}, {stock(vsku)}, {j})")
    out.append("insert into public.product_variants (product_id, name, color_hex, finish, sku, price, stock, position) values")
    out.append(",\n".join("  " + r for r in rows) + ";")
    out.append("")
out.append("commit;")
out.append("")
out.append("-- Resumen: " + ", ".join(f"{k} {v}" for k, v in counts.items()) +
           f" · {len(P)} productos, {sum(len(p['variants']) for p in P)} variantes.")

dest = Path(__file__).resolve().parent.parent / "supabase" / "004-catalogo-demo.sql"
dest.write_text("\n".join(out) + "\n", encoding="utf-8")
print(f"{dest.name}: {len(P)} productos, {sum(len(p['variants']) for p in P)} variantes")
print(counts)
