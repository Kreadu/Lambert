# Lambert

- `index.html`: tienda (catálogo de ejemplo, carrito, pedidos por WhatsApp, chat y reseñas), publicada en Netlify.
- `catalogo.html`: catálogo de productos de baño (cerámica, sanitarios, lavamanos, duchas, grifería…), que lee de Supabase. Tiene variantes de color con stock, medidas, fotos, vista 360° y modelo 3D.
- `admin.html`: panel con clave para crear productos (precio, medidas, ficha técnica, variantes con SKU y stock, y textura para la cerámica) y subir fotos, vista 360° y modelo 3D (.glb).

## Puesta en marcha (catálogo, pruebas)

1. Crea un proyecto en [Supabase](https://supabase.com) (ej: `lambert-pruebas`).
2. **SQL Editor** → pega `supabase/setup.sql` → **Run**, y luego `supabase/002-catalogo-bano.sql` → **Run**. Después corre esto con tu correo:
   `insert into public.admins (email) values ('tu-correo@ejemplo.com');`
3. **Authentication → Users → Add user**: tu correo y una contraseña, marcando *Auto Confirm User*.
   Recomendado: en **Authentication → Sign In / Providers**, desactiva *Allow new users to sign up*.
4. En `config.js`, completa `supabaseUrl` y `supabaseKey`. Los dos están en **Project Settings → API Keys**: usa la **Publishable key** (o la *anon* legacy). La clave secreta nunca va aquí.
5. Prueba en local: `python3 -m http.server 8080` y abre http://localhost:8080/admin.html.

## Fotos 3D

- **Vista 360°**: 12 a 36 fotos alrededor del producto, a la misma distancia y altura. Se suben juntas y se ordenan por nombre de archivo.
- **Modelo 3D**: archivo `.glb` (máx. 50 MB) hecho con una app de escaneo (Polycam, Luma AI, KIRI Engine). En el celular se puede ver en realidad aumentada.
