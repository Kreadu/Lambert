# Lambert · plan del catálogo y diseñador de baños

## Visión
Catálogo de productos de baño (cerámica, sanitarios, lavamanos, duchas, grifería, muebles, espejos, tinas,
accesorios) que el usuario carga con todo su detalle. Desde el catálogo, el cliente pasa a un **diseñador 3D**
donde arma su baño con esos productos y cambia colores y acabados **solo entre lo que hay en stock**.
Más adelante, el stock y los precios vendrán de Miel, enlazados por el SKU de cada variante.

## Etapas
1. **Catálogo de baño** (hecha): categorías, medidas, cerámica
   (tamaño de la pieza y textura), variantes con SKU, precio y stock.
2. **Diseñador 3D** (hecho: `disenar.html` + `tienda.html`, baños de muestra amoblados, vista de planta, modo tienda):
   - **El baño**: el cliente puede traer las medidas o no.
     - **Baños estándar** para elegir (ancho × largo, alto 2,40 m):
       - Medio baño (social, sin ducha): 1,20 × 1,50 m
       - Baño pequeño: 1,50 × 2,00 m
       - Baño estándar: 1,80 × 2,40 m
       - Baño principal: 2,50 × 3,00 m
     - **Medidas propias**: ancho, largo y alto en metros. Se parte de un estándar y se ajusta.
     - Puerta en una de las paredes (posición ajustable).
   - Cerámica del catálogo en el piso y las paredes, a escala real según el tamaño de la pieza.
   - Agregar productos del catálogo y **arrastrarlos libremente** (piso o pared, según su ubicación), girarlos y borrarlos.
   - Tocar un producto para cambiar su color o acabado entre las variantes con stock.
   - Si un producto no tiene modelo 3D, se muestra una caja con sus medidas y su color.
3. **Cotización** (hecha): total con cerámica en m², código BA-XXXX con QR, WhatsApp e impresión (`006`).
   En `admin.html` se ven los diseños guardados (buscar, abrir, escribir al cliente por WhatsApp, eliminar).
4. **Después**: baños en L, ventanas, varias paredes de ducha (vidrio), vista en realidad aumentada y
   conexión del stock con Miel.

## Modelos 3D
Del fabricante, escaneados con el celular (Polycam, KIRI) o genéricos para empezar. Formato `.glb`.

## Dónde quedamos (2026-10-13)
- Supabase (`kakkqkidixddqjzucrzv`): migraciones `setup` y `002`–`007` aplicadas; registro de usuarios cerrado.
  Catálogo demo de 135 productos (SKU `DEMO-…`, precios de referencia y stock de prueba).
- Páginas: `catalogo.html`, `admin.html` (con importación Excel/CSV, fotos en lote y diseños guardados), `disenar.html`
  (pasos, baños de muestra, planta, código BA-XXXX, ampliar a pantalla completa, zoom, cerámica distinta en
  cada pared, lista "En tu baño" para cambiar el color de cada producto, blancos neutros) y `tienda.html` (kiosco).
- Pie de Kreadu (desarrollador) en todas las páginas: `kreadu.js`, mismos datos que Miel.
- WhatsApp: "Enviármelo por WhatsApp" manda al cliente su diseño y presupuesto (en la tienda, con un QR).
  "Hablar con un asesor" aparece solo cuando la tienda pone su WhatsApp en "Mi empresa".
- Varias tiendas (`008` + función `crear-tienda`): cada empresa con sus datos, logo, país, moneda, catálogo y
  diseños. Teléfonos con código de país. "Nueva tienda" en admin.html para los administradores de la plataforma.
- 008 aplicada; la función está publicada como `swift-api`.
- Cotización (`009`): cerámica en cajas completas, pegante y boquilla calculados, y cotización impresa con
  logo, datos de la tienda, vista 3D y planta, validez y notas.
- Materiales de instalación por producto en un presupuesto adjunto, código de barras por variante e ingreso de
  inventario con la cámara (`010`, `escaner.js`). El cliente edita los accesorios recomendados.
- `index.html` es la página de inicio de Lambert (se quitó la plantilla de ropa); `tienda.html` la abre en modo kiosco.
- Seguimiento de diseños, límite de guardado, tiendas activas/inactivas y recuperar contraseña (`011`).
  Excel con código de barras, m² por caja y rendimiento. Pruebas automáticas: `npm test` (16 pruebas).
- `011` aplicada (2026-10-14).
- Publicado en GitHub Pages (https, se actualiza con cada push): https://kreadu.github.io/Lambert/
  Redirect URLs y Site URL de Supabase apuntan ahí (2026-10-14).
- Fotos de prueba (Wikimedia Commons, licencias libres) listas en `~/Escritorio/Lambert-fotos-prueba`
  (fuera del repo): 11 fotos nombradas por SKU para "Subir fotos en lote" y 2 texturas (mármol Carrara,
  baldosa Floral azul) para subir en cada color; LEEME.txt y CREDITOS.txt. Subidas (2026-10-14) salvo correcciones: textura de baldosa en Porcelanato liso/Blanco (quitar), textura Floral azul en Geométrico gris, y fotos de catálogo de CER-001/002/013.
  Vista previa del catálogo con fotos: se ve bien. Falta revisar el diseñador 3D con las texturas reales.
- Pendiente: WhatsApp de la tienda en "Mi empresa";
  cargar precios, fotos y referencias reales (exportar → editar en Excel → importar).
