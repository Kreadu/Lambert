# Lambert

- `index.html`: tienda (catálogo de ejemplo, carrito, pedidos por WhatsApp, chat y reseñas), publicada en Netlify.
- `catalogo.html`: catálogo de productos de baño (cerámica, sanitarios, lavamanos, duchas, grifería…), que lee de Supabase. Tiene variantes de color con stock, medidas, fotos, vista 360° y modelo 3D.
- `tienda.html`: pantalla de inicio para la tienda (modo kiosco): baños de muestra, "Tengo mis medidas", catálogo y "Tengo un código".
- `disenar.html`: diseñador 3D por pasos (baño, piso y paredes, productos, resumen) con vista 3D y de planta; guarda el diseño con un código y QR, imprime y envía por WhatsApp. Con `?modo=tienda` vuelve al inicio si nadie lo usa.
- `admin.html`: panel con clave para crear productos (precio, medidas, ficha técnica, variantes con SKU y stock, y textura para la cerámica) y subir fotos, vista 360° y modelo 3D (.glb).

## Puesta en marcha (catálogo, pruebas)

1. Crea un proyecto en [Supabase](https://supabase.com) (ej: `lambert-pruebas`).
2. **SQL Editor** → pega `supabase/setup.sql` → **Run**, y luego, en orden, `002` a `006` de la carpeta `supabase/` → **Run** cada uno. Después corre esto con tu correo:
   `insert into public.admins (email) values ('tu-correo@ejemplo.com');`
3. **Authentication → Users → Add user**: tu correo y una contraseña, marcando *Auto Confirm User*.
   Recomendado: en **Authentication → Sign In / Providers**, desactiva *Allow new users to sign up*.
4. En `config.js`, completa `supabaseUrl` y `supabaseKey`. Los dos están en **Project Settings → API Keys**: usa la **Publishable key** (o la *anon* legacy). La clave secreta nunca va aquí.
5. Prueba en local: `python3 -m http.server 8080` y abre http://localhost:8080/admin.html.

## Varias tiendas (empresas)

Desde `008` la plataforma tiene varias tiendas. Cada una tiene sus datos, su logo, su país y moneda, su catálogo
y sus diseños, y no ve los de las demás. Las páginas muestran la tienda de la dirección (`catalogo.html?t=mi-tienda`)
o la de `store` en `config.js`.

1. **SQL Editor** → pega `supabase/008-multiempresa.sql` → **Run**. Lo que ya existía queda en la tienda `lambert`.
2. **Edge Functions → Deploy a new function → Via Editor**, nombre `crear-tienda` (si Supabase le pone otro, como `swift-api`, escríbelo en `createStoreFunction` de `config.js`): pega
   `supabase/functions/crear-tienda/index.ts`, desactiva *Verify JWT* y **Deploy**.
3. En `admin.html`, quien esté en la tabla `admins` (Kreadu) ve la pestaña **Tiendas** → **+ Nueva tienda**: nombre,
   país, correo y contraseña del dueño. El dueño entra a `admin.html` con ese correo y solo ve su tienda.
4. Cada tienda llena **Mi empresa**: logo, razón social, país, moneda, WhatsApp y teléfono con código de país.

## Cotización: cajas, pegante y boquilla (009)

**SQL Editor** → pega `supabase/009-cajas-e-insumos.sql` → **Run**. Agrega:
- **m² por caja** en la cerámica: la cotización redondea a cajas completas (se llena sola con la ficha técnica
  "Piezas por caja: 8 (1,44 m²)"; sin ese dato se vende por m²).
- **Insumos**: en el producto (categoría que "no se dibuja"), "En la cotización del diseñador" = pegante,
  pegante para porcelanato o boquilla, y cuántos m² rinde cada unidad. La boquilla sale del color más
  parecido a la cerámica.
- **Mi empresa → Cotización impresa**: días de validez y notas al pie. "Imprimir" en el diseñador guarda el
  diseño (para que lleve código y QR) e imprime una cotización con logo, datos de la tienda, vista 3D y planta.

## Materiales de instalación y código de barras (010)

**SQL Editor** → pega `supabase/010-instalacion-y-codigos.sql` → **Run** (después de 009).
- **🔧 Instalación** (admin): qué materiales lleva cada producto (por cada sanitario, lavamanos, mueble…) y qué
  lleva el baño una vez (tubería, rejilla, cinta, silicona). El diseñador los suma en un **presupuesto adjunto**,
  aparte de la cotización, con su propio total y el total con instalación (también en la cotización impresa y
  en WhatsApp). Trae kits de muestra para Lambert.
- **Código de barras** del proveedor en cada color o variante (único por tienda), con botón 📷 para escanearlo.
- **📦 Ingresar inventario** (admin): escanea con la cámara del celular o un lector USB/Bluetooth, pon la
  cantidad y "Ingresar al inventario" suma el stock y deja el registro. Un código que no está se asigna a su
  producto una sola vez. Mismo lector que Miel: el del navegador, y en iPhone `barcode-detector` (zxing).

## En la tienda

Abre `tienda.html` en la pantalla del local y toca **⛶ Pantalla completa**. Si nadie la usa, vuelve sola al inicio.
Para que aparezca "Hablar con un asesor", pon el WhatsApp en admin.html → **Mi empresa**.

## Fotos 3D

- **Vista 360°**: 12 a 36 fotos alrededor del producto, a la misma distancia y altura. Se suben juntas y se ordenan por nombre de archivo.
- **Modelo 3D**: archivo `.glb` (máx. 50 MB) hecho con una app de escaneo (Polycam, Luma AI, KIRI Engine). En el celular se puede ver en realidad aumentada.
