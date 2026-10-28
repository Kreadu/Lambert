# Lambert · diseñadores de baño de la competencia

Ideas para mejorar Lambert observando diseñadores 3D públicos. Solo se mira cómo funcionan; no se copia código.

## Programas parecidos (2026-10-27)

| Programa | Para quién | Precio | Diferencia con Lambert |
|---|---|---|---|
| HomeByMe Bathroom Planner (Dassault) | Tiendas de baño | A cotizar | El más parecido: catálogo de la tienda, 3D en el navegador y presupuesto. Sin demo pública (se pide a ventas). |
| Cyncly SimpliPlan / Innoplus | Tiendas e instaladores | A cotizar | Fuerte en cerámica: patrones, cortes, planos de instalación y margen. Lo usa el vendedor. |
| Maticad (DomuS3D) | Tiendas de cerámica | A cotizar | Renders de calidad; programa instalado que maneja un vendedor. |
| 3D Cloud / Threekit | Fabricantes y tiendas | A cotizar | Configuradores 3D y "diseño desde foto", integración a medida. |
| Planner 5D / Cedreo | Público general | Gratis o mensual | Buen 3D, sin catálogo ni stock de la tienda ni presupuesto. |
| Genroom / Roomvo | Tiendas de cerámica | Mensual | Cerámica sobre una foto del baño del cliente; no es diseño 3D completo. |
| Sodimac (asesoría) | Clientes de Sodimac | Pagado | Lo hace un decorador, no el cliente solo. |

Lo que Lambert tiene y casi ninguno: el cliente diseña solo, con lo que hay en stock, y sale con presupuesto en
cajas, pegante y boquilla, código BA-XXXX y WhatsApp; multitienda, modo kiosco y en español.

## Victorian Plumbing (analizado con REA, 2026-10-27)

https://bathroomplanner.victorianplumbing.co.uk/en-GB/ — público, sin cuenta. Hecho por DigitalBridge ("Aspect"):
Angular + **three.js** (el mismo motor de Lambert), con servicios propios en `*.digitalbridgehq.com` y `fixtuur.io`.

**Recorrido del cliente**
1. Forma del baño: cuadrado, rectangular o en L.
2. Medidas arrastrando las paredes en un plano, o escribiendo los números (se puede saltar).
3. Editor: categorías a la izquierda; cada producto con foto, ancho, precio, "More info" y "Add to Room"; paginado
   y con filtro. Total siempre visible arriba. Nombre del diseño editable.
4. Vistas 2D, 3D y HD. Guardado automático en el aparato.

**Técnicas encontradas en su código** (presencia en el código, no verificada en pantalla)
- Sombras horneadas en los modelos: `aoMap` y `lightMap`.
- Materiales: `clearcoat` (esmalte), `normalMap`, `MeshPhysicalMaterial`, ambiente HDR (`PMREM`).
- Modelos y texturas comprimidos: `.glb` con Draco y texturas KTX2/Basis.
- `EffectComposer` + `OutlinePass` (contorno del objeto elegido) y lógica de ajuste ("snap").

**Límites:** en Chromium headless el 3D quedó en blanco y "Add to Room" respondió "Something went wrong"; no se
pudo ver ni comparar la calidad visual. No se sabe si "HD" se renderiza en el servidor o en el navegador.

## Ideas para Lambert (por impacto)

1. **Sombras horneadas en los modelos** (`aoMap`/`lightMap`), preparadas en Blender al hacer cada `.glb`.
   Va con la etapa de modelos reales.
2. **Esmalte sobre relieve** en la cerámica: `clearcoat` + `normalMap` (sigue a "brillo y relieve según el acabado").
3. **Botón "Foto HD"**: imagen de alta resolución para descargar o mandar por WhatsApp.
4. **Contorno del producto elegido** (`OutlinePass`).
5. **Modelos comprimidos** con Draco y KTX2 (carga rápida en celulares).
6. **Medidas arrastrando las paredes** y baños en L (ya en "Después" del plan).

## Roca (analizado con agent-browser + REA, 2026-10-28) — **el modelo a seguir en realismo**

https://www.roca.es/configurador-de-banos-3d → `configurador-banos-3d.roca.es`. Público, sin cuenta (guardar y
compartir sí piden cuenta/correo). Hecho por **Cyncly IdealSpaces** ("SFx Spaces Flex"): **three.js r185** + un motor
propio en WebAssembly (`3DEngine_Renderer_MT…wasm`). Desde un navegador automático sin ventana bloquea; con
`agent-browser --headed` entra normal.

**Recorrido:** galería de inspiración → tipo de baño (Estándar, Pequeño, Familiar, Accesible, Industrial, Vintage,
Hotel…) → 4 estilos ya armados por tipo → editor. Barra: Plano de planta, Añadir elementos, Visualizar, Guardar,
Deshacer/Rehacer, 2D, Compartir, **Lista de elementos con precio total siempre visible** (2651,17 €), Finalizar.

**Por qué se ve tan real** (encontrado en su código):
- **Niveles de render**: Líneas, Clásico, Clásico con bordes, **Premium** y **Premium Plus = trazado de rayos en el
  navegador** que va afinando la imagen cuadro a cuadro (multipaso).
- **Render en la nube ("HD")**: el servidor genera la foto en modo Premium, PhotoRender o PhotoRealistic, a 16:9 u
  otras proporciones, hasta **4K**, y también **panorámica 360°**. Campo de visión, perspectiva de 2 puntos y
  **fondo de ventana a elegir** (Día 00, Día 01…).
- Materiales PBR completos: `clearcoat`, `transmission` (vidrio), `sheen`, mapas Diffuse/Roughness/Normal; acabados
  **Mate / Semi Brillo / Alto Brillo** que elige el cliente.
- Post-proceso: tone mapping **AgX**, TAA/SMAA/FXAA (bordes suaves), SSR (reflejos), SSAO/GTAO (sombra de contacto),
  Draco y KTX2.
- **Luz controlable**: iluminación interior automática con intensidad, sol con altura y orientación.
- **Calidad automática**: baja la calidad sola si el equipo es lento y avisa ("Calidad de renderizado ajustada").
- En el PC de prueba (Intel HD 3000) el 3D quedó **negro**: un equipo viejo no lo mueve. Lambert debe funcionar
  en esos equipos y subir de calidad donde se pueda.

## Villeroy & Boch (analizado, 2026-10-28)

`bathroomplanner.villeroy-boch.co.uk/3DPlanerWeb` — público. Motor **Compusoft "Winner"** (C++ → WebAssembly).
- Pasos fijos arriba: **Inicio → Habitación → Amueblar → Terminado**. Inicio con 7 plantillas con foto y 10 cuartos vacíos.
- Amueblar en 3 pestañas: Colecciones → Productos → Colores; "artículos que combinan con esta colección".
- Final: lista de productos con imagen, checklist y **PDF del plan enviado por correo** (pide nombre y correo: capta
  clientes). **No muestra precios.**
- Visual sencillo (sin reflejos, sombras suaves), vista isométrica de "casa de muñecas" con paredes recortadas.

## Planner 5D

Pide cuenta (Google/Apple/correo) antes del editor. No analizado.

## Ideas nuevas para Lambert (2026-10-28)

7. **Botón "Foto realista"**: render de alta calidad que se va afinando (trazado de rayos progresivo en el navegador,
   p. ej. `three-gpu-pathtracer`) con el cliente quieto; resultado para descargar o WhatsApp. Es lo que da el look Roca.
8. **Calidad automática** según el equipo (Básica / Alta / Foto), con aviso como Roca.
9. **Post-proceso**: AgX, SSAO/GTAO, SMAA y reflejos en espejo y grifería.
10. **Fondo de ventana** (día/tarde) y control de luz (intensidad, sol).
11. **Estilos listos por tipo de baño** (Pequeño, Familiar, Accesible…) con foto realista de portada.
12. **Pasos numerados** arriba (Inicio → Medidas → Diseñar → Presupuesto), como V&B.
13. Al final: **PDF del diseño** con plano, foto y lista con precios (V&B no da precios; Lambert sí).

## Hecho (2026-10-28) — las 13 ideas en `disenar.html`

| # | Idea | Estado |
|---|---|---|
| 1 | Sombras horneadas | El cargador ya aplica el mapa de oclusión de cada `.glb`. Falta hornearlo en Blender (Cycles → Bake → Ambient Occlusion → exportar con el `.glb`) cuando haya modelos reales. |
| 2 | Esmalte sobre relieve | Cerámica y loza con `MeshPhysicalMaterial` + `clearcoat`: brillante/pulido/esmaltado = capa lisa encima del relieve. Ajuste: `finishOf()`. |
| 3 | Imagen HD | ☀ Luz → "Descargar imagen HD" (2560 px). En el celular "Enviar" abre Compartir (WhatsApp con la foto). |
| 4 | Contorno del elegido | `OutlinePass` azul en calidad Alta; en Básica y en planta sigue la caja. |
| 5 | Modelos comprimidos | `GLTFLoader` con Draco y KTX2 (decodificadores del CDN de three 0.169). |
| 6 | Medidas arrastrando paredes | En **Planta** se arrastra una pared (cada 5 cm); la habitación sigue centrada. Baños en L: pendiente. |
| 7 | Foto realista | 📷 trazado de rayos con `three-gpu-pathtracer@0.0.23`: se afina mientras la cámara está quieta; luego Guardar/Enviar y va al presupuesto. En tarjetas viejas o sin tarjeta congela la página → ahí entrega la imagen HD (`?foto=forzar` lo intenta igual). **Sin probar en un equipo con tarjeta moderna.** |
| 8 | Calidad automática | Auto/Básica/Alta en ☀ Luz. Auto elige por la tarjeta de video y baja sola si va a menos de 24 cuadros/s, con aviso. |
| 9 | Post-proceso | Alta: GTAO (sombra de contacto), SMAA, contorno. Se mantuvo tone mapping Neutral (AgX y ACES vuelven beige el blanco). Reflejo real en espejos: pendiente. |
| 10 | Luz y ventana | Día / Tarde / Noche, intensidad y ventana en la pared opuesta a la puerta (el cielo cambia con la hora). Se guarda con el diseño. |
| 11 | Estilos listos | Paso 1 → "Dale un estilo": Blanco moderno, Madera cálida, Mármol, Industrial, Clásico, con cerámica en stock; cambia también el color de grifería y la hora. |
| 12 | Pasos numerados | Ya existían (1 Tu baño · 2 Piso y paredes · 3 Productos · 4 Resumen). |
| 13 | PDF con foto | "Imprimir / PDF"; si se sacó la foto realista o HD, esa va en el presupuesto. |
