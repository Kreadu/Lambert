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

## Pendiente

Analizar Planner 5D y un fabricante (Roca o Villeroy & Boch).
