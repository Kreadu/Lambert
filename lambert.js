// Lógica compartida del catálogo (catalogo.html y admin.html).
// Requiere config.js y supabase-js (UMD) cargados antes.
(function () {
  const C = window.LAMBERT;
  const configured = Boolean(C.supabaseUrl && C.supabaseKey);
  const db = configured ? window.supabase.createClient(C.supabaseUrl, C.supabaseKey) : null;

  // ── Países: código para el teléfono y moneda por defecto ──
  const COUNTRIES = [
    ["AR", "Argentina", "54", "ARS"], ["BO", "Bolivia", "591", "BOB"], ["BR", "Brasil", "55", "BRL"],
    ["CA", "Canadá", "1", "CAD"], ["CL", "Chile", "56", "CLP"], ["CO", "Colombia", "57", "COP"],
    ["CR", "Costa Rica", "506", "CRC"], ["CU", "Cuba", "53", "CUP"], ["EC", "Ecuador", "593", "USD"],
    ["SV", "El Salvador", "503", "USD"], ["ES", "España", "34", "EUR"], ["US", "Estados Unidos", "1", "USD"],
    ["GT", "Guatemala", "502", "GTQ"], ["HN", "Honduras", "504", "HNL"], ["MX", "México", "52", "MXN"],
    ["NI", "Nicaragua", "505", "NIO"], ["PA", "Panamá", "507", "USD"], ["PY", "Paraguay", "595", "PYG"],
    ["PE", "Perú", "51", "PEN"], ["PT", "Portugal", "351", "EUR"], ["PR", "Puerto Rico", "1", "USD"],
    ["DO", "República Dominicana", "1", "DOP"], ["UY", "Uruguay", "598", "UYU"], ["VE", "Venezuela", "58", "VES"],
  ].map(([iso, name, dial, currency]) => ({
    iso, name, dial, currency,
    flag: String.fromCodePoint(...[...iso].map((ch) => 0x1f1a5 + ch.charCodeAt(0))),
  }));
  const countryOf = (iso) => COUNTRIES.find((c) => c.iso === iso) || COUNTRIES.find((c) => c.iso === "CO");
  const CURRENCIES = [...new Set(COUNTRIES.map((c) => c.currency))].sort();
  // monedas en las que los precios se escriben sin decimales
  const WHOLE = ["COP", "CLP", "PYG", "CRC", "ARS"];

  // `money` es siempre el mismo objeto: cambia de moneda cuando se carga la tienda
  let fmt;
  function setCurrency(currency, locale) {
    try { fmt = new Intl.NumberFormat(locale, { style: "currency", currency, minimumFractionDigits: 0, maximumFractionDigits: WHOLE.includes(currency) ? 0 : 2 }); }
    catch { fmt = new Intl.NumberFormat("es-CO", { style: "currency", currency: "COP", maximumFractionDigits: 0 }); }
  }
  setCurrency(C.currency || "COP", C.locale || "es-CO");
  const money = { format: (v) => fmt.format(v) };

  // Categorías del baño. placement: dónde va en el diseñador 3D (floor | wall | surface | none).
  // Se cargan de la tabla `categories` (005); esta lista es el respaldo si aún no existe.
  // Es la misma lista (se reemplaza su contenido), así que quien la desestructuró ve los cambios.
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

  async function loadCategories() {
    const { data, error } = await db.from("categories").select("slug, label, placement").eq("store_id", C.storeId).order("position").order("label");
    if (!error && data?.length) CATEGORIES.splice(0, CATEGORIES.length, ...data);
    return { error };
  }

  /** Nombre → identificador: "Calentadores de agua" → "calentadores-de-agua". */
  const slugify = (t) => t.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");

  const UNITS = { unidad: "unidad", m2: "m²", caja: "caja", bulto: "bulto", kg: "kg", galon: "galón", metro: "metro", juego: "juego", tubo: "tubo" };
  const unitLabel = (u) => UNITS[u] ?? u;

  function esc(v) {
    return String(v ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  }

  function fileUrl(path) {
    return db.storage.from(C.bucket).getPublicUrl(path).data.publicUrl;
  }

  // ── La tienda (empresa) que se está viendo: ?t=<slug> o la de config.js ──
  const qsStore = () => new URLSearchParams(location.search).get("t");
  const storeSlug = () => qsStore() || C.store || "lambert";
  const S = { store: null };
  function useStore(s) {
    S.store = s;
    const c = countryOf(s.country);
    Object.assign(C, {
      storeId: s.id, storeSlug: s.slug, storeName: s.name, country: c.iso, dial: s.whatsapp_cc || c.dial,
      currency: s.currency, locale: `es-${c.iso}`,
      whatsapp: s.whatsapp ? `${s.whatsapp_cc}${s.whatsapp}` : "",
      logo: s.logo_path ? fileUrl(s.logo_path) : null,
    });
    setCurrency(C.currency, C.locale);
  }
  async function loadStore(slug = storeSlug()) {
    const { data, error } = await db.from("stores").select("*").eq("slug", slug).maybeSingle();
    if (error || !data) return { error: error || new Error("Tienda no encontrada") };
    useStore(data);
    return { store: data };
  }
  /** Marca de la tienda (logo y nombre) en el elemento dado. */
  function renderBrand(el) {
    if (!el) return;
    el.innerHTML = (C.logo ? `<img class="brand-logo" src="${esc(C.logo)}" alt="">` : "") + `<span>${esc(C.storeName)}</span>`;
  }
  // los enlaces entre páginas conservan la tienda (?t=…) cuando no es la de config.js
  function withStore(href) {
    const t = qsStore();
    if (!t || !href || !/^[\w-]+\.html/.test(href)) return href;
    const u = new URL(href, location.href);
    if (!u.searchParams.has("t")) u.searchParams.set("t", t);
    return u.pathname.split("/").pop() + u.search + u.hash;
  }
  document.addEventListener("click", (e) => {
    const a = e.target.closest?.("a[href]");
    if (a) a.setAttribute("href", withStore(a.getAttribute("href")));
  }, true);

  // ── Teléfono con código de país ──
  /** <select> de país (bandera y +código) junto al número. `iso` = país elegido. */
  function phoneField(id, iso, number = "", attrs = "") {
    return `<div class="phone-field"><select class="input" id="${id}-cc" aria-label="Código de país">${COUNTRIES.map((c) =>
      `<option value="${c.iso}"${c.iso === iso ? " selected" : ""}>${c.flag} +${c.dial}</option>`).join("")}</select>
      <input class="input" id="${id}" inputmode="tel" autocomplete="tel-national" value="${esc(number)}" ${attrs}></div>`;
  }
  /** El país de un código guardado ("57" → CO), prefiriendo el de la tienda cuando comparten código (+1). */
  const isoOfDial = (dial, prefer = C.country) => (countryOf(prefer).dial === dial ? prefer : COUNTRIES.find((c) => c.dial === dial)?.iso) || prefer;
  /** Solo los dígitos del número, sin el 0 inicial de marcación nacional. */
  const phoneDigits = (number) => String(number || "").replace(/\D/g, "").replace(/^0+/, "");
  /** { dial, number } del campo, o null si está vacío. */
  function phoneValue(id) {
    const number = phoneDigits(document.getElementById(id).value);
    return number ? { dial: countryOf(document.getElementById(`${id}-cc`).value).dial, number } : null;
  }

  // ── Sedes: puntos de venta de la tienda, cada uno con su stock (y su precio, si lo pone) ──
  /** Sedes activas de la tienda; [] si no tiene o falta correr supabase/012-sedes.sql. */
  async function loadBranches() {
    const { data, error } = await db.from("store_branches").select("*").eq("store_id", C.storeId).eq("active", true).order("position").order("name");
    return error ? [] : data;
  }
  const branchKey = () => `lambert_sede_${storeSlug()}`;
  /** La sede elegida: ?sede=<id> en la dirección (pantalla de la tienda) o la última que eligió el cliente. */
  function pickBranch(branches) {
    let id = new URLSearchParams(location.search).get("sede");
    if (!id) try { id = localStorage.getItem(branchKey()); } catch { /* sin almacenamiento */ }
    return branches.find((b) => b.id === id) || null;
  }
  /** "Comprando en: …"; al cambiar de sede se vuelve a cargar la página con su stock. */
  function branchPicker(el, branches, current) {
    if (!el || !branches.length) return;
    el.innerHTML = `<label class="branch-pick"><span>Comprando en</span><select class="input" aria-label="Sede">
      ${current ? "" : `<option value="">Elige tu sede…</option>`}${branches.map((b) =>
        `<option value="${b.id}"${b.id === current?.id ? " selected" : ""}>${esc(b.name)}${b.city ? ` · ${esc(b.city)}` : ""}</option>`).join("")}</select></label>`;
    el.querySelector("select").onchange = (e) => {
      try { localStorage.setItem(branchKey(), e.target.value); } catch { /* sin almacenamiento */ }
      const u = new URL(location.href);
      u.searchParams.delete("sede");
      location.href = u.href;
    };
  }

  /** Productos con su media agrupada: { photos:[url], spin:[url], model:url|null }.
   *  Con `branch`, el stock y el precio son los de esa sede (lo que no tiene dato propio queda con el general). */
  async function loadProducts({ branch } = {}) {
    const own = new Map();
    if (branch) {
      const { data: bs } = await db.from("branch_stock").select("variant_id, stock, price").eq("branch_id", branch.id);
      (bs || []).forEach((r) => own.set(r.variant_id, r));
    }
    const [, { data, error }] = await Promise.all([loadCategories(), db
      .from("products")
      .select("*, product_media(id, kind, path, position), product_variants(*)")
      .eq("store_id", C.storeId)
      .order("position")
      .order("created_at", { ascending: false })]);
    if (error) throw error;
    return data.map((p) => {
      const media = (p.product_media || []).slice().sort((a, b) => a.position - b.position);
      const of = (k) => media.filter((m) => m.kind === k);
      const variants = (p.product_variants || []).slice().sort((a, b) => a.position - b.position)
        .map((v) => { const o = own.get(v.id); return o ? { ...v, stock: o.stock, price: o.price ?? v.price } : v; })
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

  window.Lambert = { C, db, configured, S, COUNTRIES, CURRENCIES, countryOf, loadStore, useStore, storeSlug, renderBrand, withStore, phoneField, isoOfDial, phoneDigits, phoneValue, CATEGORIES, categoryLabel, loadCategories, slugify, UNITS, unitLabel, money, esc, fileUrl, loadProducts, loadBranches, pickBranch, branchPicker, mountSpin, mountModel, compressImage };
})();
