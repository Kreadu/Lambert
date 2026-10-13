// Lógica compartida del catálogo (catalogo.html y admin.html).
// Requiere config.js y supabase-js (UMD) cargados antes.
(function () {
  const C = window.LAMBERT;
  const configured = Boolean(C.supabaseUrl && C.supabaseKey);
  const db = configured ? window.supabase.createClient(C.supabaseUrl, C.supabaseKey) : null;

  const money = new Intl.NumberFormat(C.locale, { style: "currency", currency: C.currency, maximumFractionDigits: 0 });

  // Categorías del baño. placement: dónde va en el diseñador 3D (floor | wall | surface | none).
  const CATEGORIES = [
    { slug: "ceramica", label: "Cerámica y baldosas", placement: "surface" },
    { slug: "sanitarios", label: "Sanitarios", placement: "floor" },
    { slug: "lavamanos", label: "Lavamanos", placement: "wall" },
    { slug: "griferia", label: "Grifería", placement: "wall" },
    { slug: "duchas", label: "Duchas", placement: "wall" },
    { slug: "divisiones", label: "Divisiones de baño", placement: "floor" },
    { slug: "tinas", label: "Tinas y platos de ducha", placement: "floor" },
    { slug: "muebles", label: "Muebles", placement: "floor" },
    { slug: "espejos", label: "Espejos", placement: "wall" },
    { slug: "accesorios", label: "Accesorios", placement: "wall" },
    { slug: "instalacion", label: "Instalación y plomería", placement: "none" },
    { slug: "pegantes", label: "Pegantes y boquillas", placement: "none" },
  ];
  const categoryLabel = (slug) => CATEGORIES.find((c) => c.slug === slug)?.label ?? slug;

  const UNITS = { unidad: "unidad", m2: "m²", caja: "caja", bulto: "bulto", kg: "kg", galon: "galón", metro: "metro", juego: "juego", tubo: "tubo" };
  const unitLabel = (u) => UNITS[u] ?? u;

  function esc(v) {
    return String(v ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  }

  function fileUrl(path) {
    return db.storage.from(C.bucket).getPublicUrl(path).data.publicUrl;
  }

  /** Productos con su media agrupada: { photos:[url], spin:[url], model:url|null }. */
  async function loadProducts() {
    const { data, error } = await db
      .from("products")
      .select("*, product_media(id, kind, path, position), product_variants(*)")
      .order("position")
      .order("created_at", { ascending: false });
    if (error) throw error;
    return data.map((p) => {
      const media = (p.product_media || []).slice().sort((a, b) => a.position - b.position);
      const of = (k) => media.filter((m) => m.kind === k);
      const variants = (p.product_variants || []).slice().sort((a, b) => a.position - b.position)
        .map((v) => ({ ...v, finalPrice: v.price ?? p.price, texture: v.texture_path ? fileUrl(v.texture_path) : null }));
      const inStock = variants.filter((v) => v.active && v.stock > 0);
      const prices = (variants.length ? inStock : [p]).map((v) => v.finalPrice ?? v.price);
      return {
        ...p,
        media,
        variants,
        inStock,
        // sin variantes: el producto se vende con su precio; con variantes: solo lo que hay en stock
        available: variants.length ? inStock.length > 0 : true,
        fromPrice: prices.length ? Math.min(...prices) : p.price,
        photos: of("photo").map((m) => fileUrl(m.path)),
        spin: of("spin").map((m) => fileUrl(m.path)),
        model: of("model").map((m) => fileUrl(m.path))[0] || null,
      };
    });
  }

  // ── Vista 360°: arrastrar cambia de foto ──
  function mountSpin(el, urls) {
    el.classList.add("spin");
    el.innerHTML = `<img alt="Vista 360°" draggable="false"><span class="spin-hint">↔ Arrastra para girar</span>`;
    const img = el.querySelector("img");
    urls.forEach((u) => { const i = new Image(); i.src = u; }); // precarga
    let frame = 0, startX = 0, startFrame = 0, dragging = false;
    const show = (f) => { frame = ((f % urls.length) + urls.length) % urls.length; img.src = urls[frame]; };
    show(0);
    const pxPerFrame = () => Math.max(4, el.clientWidth / urls.length / 1.5);
    el.addEventListener("pointerdown", (e) => {
      dragging = true; startX = e.clientX; startFrame = frame;
      el.setPointerCapture(e.pointerId);
      el.querySelector(".spin-hint")?.remove();
    });
    el.addEventListener("pointermove", (e) => {
      if (dragging) show(startFrame - Math.round((e.clientX - startX) / pxPerFrame()));
    });
    const stop = () => { dragging = false; };
    el.addEventListener("pointerup", stop);
    el.addEventListener("pointercancel", stop);
  }

  // ── Modelo 3D (.glb) con <model-viewer>, cargado solo si hace falta ──
  let mvLoading = null;
  function ensureModelViewer() {
    if (customElements.get("model-viewer")) return Promise.resolve();
    if (!mvLoading) {
      mvLoading = new Promise((resolve, reject) => {
        const s = document.createElement("script");
        s.type = "module";
        s.src = "https://cdn.jsdelivr.net/npm/@google/model-viewer@3.5.0/dist/model-viewer.min.js";
        s.onload = resolve;
        s.onerror = reject;
        document.head.appendChild(s);
      });
    }
    return mvLoading;
  }

  async function mountModel(el, url, alt) {
    await ensureModelViewer();
    el.innerHTML = `<model-viewer src="${esc(url)}" alt="${esc(alt)}" camera-controls touch-action="pan-y"
      auto-rotate shadow-intensity="1" ar ar-modes="webxr scene-viewer quick-look"
      style="width:100%;height:100%;background:transparent"></model-viewer>`;
  }

  // ── Comprimir fotos antes de subir (el celular saca fotos de 3–8 MB) ──
  async function compressImage(file, maxSide) {
    if (!file.type.startsWith("image/")) return file;
    const bmp = await createImageBitmap(file);
    const scale = Math.min(1, maxSide / Math.max(bmp.width, bmp.height));
    const canvas = document.createElement("canvas");
    canvas.width = Math.round(bmp.width * scale);
    canvas.height = Math.round(bmp.height * scale);
    canvas.getContext("2d").drawImage(bmp, 0, 0, canvas.width, canvas.height);
    const blob = await new Promise((r) => canvas.toBlob(r, "image/webp", 0.85));
    return blob && blob.size < file.size ? blob : file;
  }

  window.Lambert = { C, db, configured, CATEGORIES, categoryLabel, UNITS, unitLabel, money, esc, fileUrl, loadProducts, mountSpin, mountModel, compressImage };
})();
