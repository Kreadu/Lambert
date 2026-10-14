// Panel de administración: exportar el catálogo, importar precios/stock (Excel o CSV) y subir fotos en lote.
// Se inicia desde admin.html con LambertImport.init(ctx).
(function () {
  const XLSX_URL = "https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js";
  let ctx;
  const $ = (id) => document.getElementById(id);
  const norm = (t) => String(t ?? "").normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase().trim();

  // ── Columnas: nombres que se aceptan para cada dato ──
  const COLUMNS = {
    sku: ["sku", "referencia", "ref", "codigo", "cod", "referencia variante"],
    barcode: ["codigo de barras", "codigo barras", "cod barras", "cod. barras", "ean", "ean13", "upc", "barcode"],
    m2_per_box: ["m2 por caja", "m² por caja", "m2 caja", "m² caja", "metros por caja"],
    coverage_m2: ["rinde", "rinde m2", "rinde m²", "rendimiento", "rendimiento m2", "rendimiento m²"],
    name: ["nombre", "producto", "articulo", "nombre del producto"],
    variant: ["color", "variante", "acabado", "color / acabado", "color/acabado"],
    price: ["precio", "precio venta", "precio de venta", "pvp", "valor", "precio unitario", "precio publico"],
    stock: ["stock", "existencia", "existencias", "cantidad", "inventario", "disponible"],
    category: ["categoria"],
    subcategory: ["subcategoria", "tipo", "linea"],
    brand: ["marca"],
    unit: ["unidad", "um", "unidad de venta"],
    description: ["descripcion", "detalle"],
    width: ["ancho", "ancho cm"],
    height: ["alto", "alto cm"],
    depth: ["fondo", "profundidad", "fondo cm"],
    color_hex: ["color hex", "hex", "codigo color"],
  };
  const HEADERS = ["sku", "nombre", "color / acabado", "precio", "stock", "categoria", "subcategoria", "marca", "unidad", "descripcion", "ancho", "alto", "fondo", "color hex",
    "codigo de barras", "m2 por caja", "rinde (m2)"];
  // columnas nuevas (009 y 010): solo se importan si la base ya las tiene
  const hasBarcode = () => ctx.products().some((p) => p.variants.some((v) => "barcode" in v));
  const hasBoxes = () => ctx.products().some((p) => "m2_per_box" in p);

  function mapHeader(h) {
    const n = norm(h).replace(/\s*\(.*\)$/, "");
    return Object.keys(COLUMNS).find((k) => COLUMNS[k].includes(n)) || null;
  }

  // "$ 1.250.000" → 1250000 · "1.250,50" → 1250.5 · "1,250.50" → 1250.5 · "45000" → 45000
  function parseNumber(v) {
    if (typeof v === "number") return v;
    let s = String(v ?? "").replace(/[^\d.,-]/g, "");
    if (!s) return null;
    const lastDot = s.lastIndexOf("."), lastComma = s.lastIndexOf(",");
    if (lastDot >= 0 && lastComma >= 0) {
      const dec = lastDot > lastComma ? "." : ",";
      s = s.replace(dec === "." ? /,/g : /\./g, "").replace(dec, ".");
    } else if (lastComma >= 0 || lastDot >= 0) {
      const sep = lastComma >= 0 ? "," : ".";
      const parts = s.split(sep);
      // "1.250.000" o "45.000": separador de miles; "12,5": decimal
      s = parts.length > 2 || parts[parts.length - 1].length === 3 ? parts.join("") : parts.join(".");
    }
    const n = Number(s);
    return Number.isFinite(n) ? n : null;
  }

  // CSV con comas o punto y coma (Excel en español usa ;), con comillas
  function parseCSV(text) {
    text = text.replace(/^﻿/, "");
    const first = text.split(/\r?\n/, 1)[0];
    const sep = (first.match(/;/g) || []).length > (first.match(/,/g) || []).length ? ";" : (first.includes("\t") ? "\t" : ",");
    const rows = [];
    let row = [], cell = "", q = false;
    for (let i = 0; i < text.length; i++) {
      const ch = text[i];
      if (q) {
        if (ch === '"' && text[i + 1] === '"') { cell += '"'; i++; }
        else if (ch === '"') q = false;
        else cell += ch;
      } else if (ch === '"') q = true;
      else if (ch === sep) { row.push(cell); cell = ""; }
      else if (ch === "\n" || ch === "\r") {
        if (ch === "\r" && text[i + 1] === "\n") i++;
        row.push(cell); rows.push(row); row = []; cell = "";
      } else cell += ch;
    }
    if (cell || row.length) { row.push(cell); rows.push(row); }
    return rows.filter((r) => r.some((c) => String(c).trim()));
  }

  let xlsxLoading;
  function loadXLSX() {
    if (window.XLSX) return Promise.resolve(window.XLSX);
    xlsxLoading ||= new Promise((res, rej) => {
      const s = document.createElement("script");
      s.src = XLSX_URL; s.onload = () => res(window.XLSX); s.onerror = rej;
      document.head.appendChild(s);
    });
    return xlsxLoading;
  }

  async function readTable(file) {
    if (/\.(csv|txt)$/i.test(file.name)) return parseCSV(await file.text());
    const XLSX = await loadXLSX();
    const wb = XLSX.read(await file.arrayBuffer(), { type: "array" });
    return XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]], { header: 1, raw: true, defval: "" });
  }

  function toCSV(rows) {
    const cell = (v) => { const s = String(v ?? ""); return /[;"\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s; };
    // ; y BOM para que Excel en español lo abra en columnas y con tildes
    return "﻿" + rows.map((r) => r.map(cell).join(";")).join("\r\n");
  }
  function download(name, content) {
    const a = document.createElement("a");
    a.href = URL.createObjectURL(new Blob([content], { type: "text/csv;charset=utf-8" }));
    a.download = name;
    a.click();
    setTimeout(() => URL.revokeObjectURL(a.href), 1000);
  }

  // ── Exportar ──
  function exportCatalog() {
    const { categoryLabel } = window.Lambert;
    const rows = [HEADERS];
    for (const p of ctx.products()) {
      const base = [p.name, null, null, null, categoryLabel(p.category), p.subcategory, p.brand, p.unit, p.description, p.width_cm ?? "", p.height_cm ?? "", p.depth_cm ?? ""];
      const list = p.variants.length ? p.variants : [null];
      for (const v of list) {
        rows.push([v?.sku || p.sku || "", base[0], v?.name ?? "", v ? (v.price ?? p.price) : p.price, v ? v.stock : "", ...base.slice(4), v?.color_hex ?? "",
          v?.barcode ?? "", p.m2_per_box ?? "", p.coverage_m2 ?? ""]);
      }
    }
    download(`catalogo-${new Date().toISOString().slice(0, 10)}.csv`, toCSV(rows));
  }

  function downloadTemplate() {
    download("plantilla-catalogo.csv", toCSV([
      HEADERS,
      ["COR-SAN-001-BL", "Sanitario one piece alongado", "Blanco", "890.000", "12", "Sanitarios", "One piece", "Corona", "unidad", "Doble descarga 4,8 L", "38", "72", "70", "#f7f7f5", "7702004003508", "", ""],
      ["COR-SAN-001-NE", "Sanitario one piece alongado", "Negro mate", "1.290.000", "3", "Sanitarios", "One piece", "Corona", "unidad", "", "", "", "", "#222222", "7702004003515", "", ""],
      ["POR-MAR-60120-CA", "Porcelanato tipo mármol 60×120", "Carrara", "118.000", "40", "Cerámica y baldosas", "Porcelanato", "", "m2", "", "", "", "", "#ecebe7", "", "1,44", ""],
      ["PEG-POR-25", "Pegante para porcelanato 25 kg", "Gris", "62.000", "20", "Pegantes y boquillas", "Pegantes", "", "bulto", "", "", "", "", "", "", "", "3"],
    ]));
  }

  // ── Importar: armar el plan (qué cambia) antes de tocar la base ──
  let plan = null;

  function buildPlan(table, createNew) {
    const [head, ...body] = table;
    const cols = head.map(mapHeader);
    if (!cols.includes("sku") && !cols.includes("name")) throw new Error("No encontré la columna de referencia (SKU) ni la de nombre. Revisa la primera fila o descarga la plantilla.");
    const products = ctx.products();
    const bySkuV = new Map(), bySkuP = new Map(), byName = new Map();
    const byBarcode = new Map();
    for (const p of products) {
      if (p.sku) bySkuP.set(norm(p.sku), p);
      byName.set(norm(p.name), p);
      for (const v of p.variants) {
        if (v.sku) bySkuV.set(norm(v.sku), { p, v });
        if (v.barcode) byBarcode.set(String(v.barcode).trim(), { p, v });
      }
    }
    const useBarcode = hasBarcode(), useBoxes = hasBoxes();
    const touchedProducts = new Set();
    const { CATEGORIES, slugify } = window.Lambert;
    const findCat = (t) => { const n = norm(t); return CATEGORIES.find((c) => c.slug === slugify(t) || norm(c.label) === n)?.slug; };

    const out = { updates: [], creates: [], same: 0, errors: [], newProducts: new Map() };
    body.forEach((cells, i) => {
      const line = i + 2;
      const r = {};
      cols.forEach((k, j) => { if (k && String(cells[j] ?? "").trim() !== "") r[k] = String(cells[j]).trim(); });
      if (!Object.keys(r).length) return;
      const price = r.price != null ? parseNumber(r.price) : null;
      const stock = r.stock != null ? parseNumber(r.stock) : null;
      if (r.price != null && (price == null || price < 0)) return out.errors.push(`Fila ${line}: precio "${r.price}" no es un número.`);
      if (r.stock != null && (stock == null || stock < 0 || !Number.isInteger(stock))) return out.errors.push(`Fila ${line}: stock "${r.stock}" debe ser un número entero.`);
      const barcode = useBarcode && r.barcode ? String(r.barcode).replace(/\.0+$/, "").trim() : null; // Excel a veces lo vuelve número
      if (barcode && !/^[0-9A-Za-z. -]{1,64}$/.test(barcode)) return out.errors.push(`Fila ${line}: el código de barras "${r.barcode}" tiene caracteres no válidos.`);
      const m2box = useBoxes && r.m2_per_box != null ? parseNumber(r.m2_per_box) : null;
      const cover = useBoxes && r.coverage_m2 != null ? parseNumber(r.coverage_m2) : null;
      if ((r.m2_per_box != null && useBoxes && !(m2box > 0)) || (r.coverage_m2 != null && useBoxes && !(cover > 0))) return out.errors.push(`Fila ${line}: "m² por caja" y "rinde" deben ser números mayores que 0.`);
      // datos del producto (m² por caja, rendimiento): una sola vez por producto
      const productChange = (p) => {
        if (!p || touchedProducts.has(p.id)) return;
        const change = {};
        if (m2box != null && m2box !== Number(p.m2_per_box)) change.m2_per_box = m2box;
        if (cover != null && cover !== Number(p.coverage_m2)) change.coverage_m2 = cover;
        if (!Object.keys(change).length) return;
        touchedProducts.add(p.id);
        out.updates.push({ line, kind: "product", id: p.id, label: p.name, from: { m2_per_box: p.m2_per_box, coverage_m2: p.coverage_m2 }, change });
      };

      // 0) código de barras · 1) SKU de variante · 2) SKU de producto (+ color) · 3) nombre (+ color)
      let hit = (barcode && byBarcode.get(barcode)) || (r.sku && bySkuV.get(norm(r.sku)));
      let p = hit?.p || (r.sku && bySkuP.get(norm(r.sku))) || (r.name && byName.get(norm(r.name)));
      let v = hit?.v || (p && r.variant ? p.variants.find((x) => norm(x.name) === norm(r.variant)) : null);
      if (p && !v && p.variants.length === 1 && !r.variant) v = p.variants[0];

      if (p && v) {
        const change = {};
        const cur = v.price ?? p.price;
        if (price != null && price !== cur) change.price = price;
        if (stock != null && stock !== v.stock) change.stock = stock;
        if (barcode && barcode !== v.barcode) change.barcode = barcode;
        productChange(p);
        if (Object.keys(change).length) out.updates.push({ line, kind: "variant", id: v.id, label: `${p.name} · ${v.name}`, from: { price: cur, stock: v.stock, barcode: v.barcode }, change });
        else out.same++;
        return;
      }
      if (p && !r.variant && !p.variants.length) {
        if (price != null && price !== p.price) out.updates.push({ line, kind: "product", id: p.id, label: p.name, from: { price: p.price }, change: { price } });
        else out.same++;
        productChange(p);
        if (stock != null) out.creates.push({ line, kind: "variant", productId: p.id, label: `${p.name} · Único`, row: { name: "Único", sku: r.sku || null, stock, price: null, ...(barcode ? { barcode } : {}) } });
        return;
      }
      if (p && r.variant) {
        productChange(p);
        out.creates.push({ line, kind: "variant", productId: p.id, label: `${p.name} · ${r.variant}`, row: { name: r.variant, sku: r.sku || null, stock: stock ?? 0, price: price != null && price !== p.price ? price : null, color_hex: /^#[0-9a-f]{6}$/i.test(r.color_hex || "") ? r.color_hex : null, ...(barcode ? { barcode } : {}) } });
        return;
      }
      // producto nuevo
      if (!createNew) return out.errors.push(`Fila ${line}: "${r.name || r.sku}" no está en el catálogo (activa "Crear los que no existan" para agregarlo).`);
      if (!r.name) return out.errors.push(`Fila ${line}: para crear un producto nuevo falta el nombre.`);
      const cat = r.category ? findCat(r.category) : null;
      if (!cat) return out.errors.push(`Fila ${line}: la categoría "${r.category || "(vacía)"}" no existe. Créala con + o corrige el nombre.`);
      if (price == null) return out.errors.push(`Fila ${line}: para crear "${r.name}" falta el precio.`);
      const key = norm(r.name);
      let np = out.newProducts.get(key);
      if (!np) {
        const catRow = CATEGORIES.find((c) => c.slug === cat);
        np = { line, label: r.name, row: {
          name: r.name, category: cat, subcategory: r.subcategory || "", brand: r.brand || "", unit: window.Lambert.UNITS[norm(r.unit)] ? norm(r.unit) : (norm(r.unit) === "m²" ? "m2" : (catRow.placement === "surface" ? "m2" : "unidad")),
          price, description: r.description || "", sku: r.variant ? null : (r.sku || null),
          width_cm: parseNumber(r.width), height_cm: parseNumber(r.height), depth_cm: parseNumber(r.depth),
          placement: catRow.placement, surface_use: catRow.placement === "surface" ? "both" : null,
          ...(m2box != null && catRow.placement === "surface" ? { m2_per_box: m2box } : {}),
          ...(cover != null ? { coverage_m2: cover } : {}),
        }, variants: [] };
        out.newProducts.set(key, np);
      }
      if (r.variant || stock != null) np.variants.push({ name: r.variant || "Único", sku: r.sku || null, stock: stock ?? 0, price: price !== np.row.price ? price : null, color_hex: /^#[0-9a-f]{6}$/i.test(r.color_hex || "") ? r.color_hex : null, ...(barcode ? { barcode } : {}) });
    });
    return out;
  }

  function renderPlan() {
    const m = window.Lambert.money;
    const esc = window.Lambert.esc;
    const nNew = plan.newProducts.size;
    const LABEL = { stock: "stock", barcode: "código", m2_per_box: "m²/caja", coverage_m2: "rinde" };
    const fmt = (u) => Object.entries(u.change).map(([k, val]) => k === "price"
      ? `precio ${m.format(u.from.price)} → <b>${m.format(val)}</b>` : `${LABEL[k] || k} ${esc(u.from[k] ?? "—")} → <b>${esc(val)}</b>`).join(" · ");
    $("impPlan").innerHTML = `
      <div class="notice" style="margin:10px 0">
        <b>${plan.updates.length}</b> cambios de precio o stock · <b>${plan.creates.length}</b> colores nuevos ·
        <b>${nNew}</b> productos nuevos · ${plan.same} sin cambios · <span style="color:var(--danger)">${plan.errors.length} con problemas</span>
      </div>
      ${plan.errors.length ? `<details open><summary class="muted">Filas con problemas (no se importan)</summary><ul style="font-size:13px;margin:6px 0 10px 18px">${plan.errors.slice(0, 50).map((e) => `<li>${esc(e)}</li>`).join("")}${plan.errors.length > 50 ? `<li>… y ${plan.errors.length - 50} más</li>` : ""}</ul></details>` : ""}
      ${plan.updates.length ? `<details ${plan.updates.length <= 30 ? "open" : ""}><summary class="muted">Cambios</summary><div style="max-height:260px;overflow:auto;font-size:13px">${plan.updates.map((u) =>
        `<div class="summary-row" style="display:flex;justify-content:space-between;gap:8px;padding:4px 0;border-bottom:1px solid var(--border)"><span>${esc(u.label)}</span><span>${fmt(u)}</span></div>`).join("")}</div></details>` : ""}
      ${plan.creates.length || nNew ? `<details><summary class="muted">Nuevos</summary><ul style="font-size:13px;margin:6px 0 10px 18px">${[...plan.creates.map((c) => c.label), ...[...plan.newProducts.values()].map((n) => `${n.label} (producto nuevo, ${n.variants.length || 0} colores)`)].slice(0, 100).map((t) => `<li>${esc(t)}</li>`).join("")}</ul></details>` : ""}
      <div class="row" style="margin-top:10px">
        <button class="btn btn-primary" id="impApply" ${plan.updates.length + plan.creates.length + nNew ? "" : "disabled"}>Aplicar cambios</button>
        <button class="btn" id="impCancel">Cancelar</button>
      </div>`;
    $("impApply").onclick = applyPlan;
    $("impCancel").onclick = () => { plan = null; $("impPlan").innerHTML = ""; $("impFile").value = ""; };
  }

  async function applyPlan() {
    const { db, C } = ctx;
    $("impApply").disabled = true;
    const st = (msg, kind = "") => { $("impStatus").textContent = msg; $("impStatus").className = `status ${kind}`; };
    const fails = [];
    const total = plan.updates.length + plan.creates.length + plan.newProducts.size;
    let done = 0;
    const tick = () => st(`Aplicando ${++done} de ${total}…`);
    const now = new Date().toISOString();
    // de a 8 en paralelo para no saturar
    const run = async (items, fn) => { for (let i = 0; i < items.length; i += 8) await Promise.all(items.slice(i, i + 8).map(async (x) => { try { await fn(x); } catch (e) { fails.push(`Fila ${x.line}: ${e.message}`); } tick(); })); };
    const check = ({ error }) => { if (error) throw new Error(error.code === "23505" ? (/barcode/.test(error.message) ? "ese código de barras ya es de otra variante" : "ese SKU ya existe") : error.message); };

    await run(plan.updates, async (u) => check(await db.from(u.kind === "variant" ? "product_variants" : "products").update({ ...u.change, updated_at: now }).eq("id", u.id)));
    await run(plan.creates, async (c) => check(await db.from("product_variants").insert({ product_id: c.productId, ...c.row })));
    await run([...plan.newProducts.values()], async (n) => {
      const { data, error } = await db.from("products").insert({ ...n.row, store_id: C.storeId }).select("id").single();
      check({ error });
      if (n.variants.length) check(await db.from("product_variants").insert(n.variants.map((v, i) => ({ ...v, product_id: data.id, position: i }))));
    });
    plan = null;
    $("impPlan").innerHTML = "";
    $("impFile").value = "";
    await ctx.refresh();
    if (fails.length) {
      st(`Listo con ${fails.length} error(es): ${fails.slice(0, 3).join(" · ")}${fails.length > 3 ? " …" : ""}`, "err");
    } else st(`Listo ✓ ${total} cambio(s) aplicados.`, "ok");
  }

  // ── Fotos en lote: el nombre del archivo dice a qué producto va ──
  let photoPlan = [];
  function matchPhotos(files) {
    const { slugify } = window.Lambert;
    const products = ctx.products();
    const bySku = new Map(), bySlug = new Map();
    for (const p of products) {
      if (p.sku) bySku.set(norm(p.sku), p);
      for (const v of p.variants) if (v.sku) bySku.set(norm(v.sku), p);
      bySlug.set(slugify(p.name), p);
    }
    return files.map((f) => {
      const base = f.name.replace(/\.[^.]+$/, "").trim();
      // "COR-SAN-001-2" o "COR-SAN-001 (2)": el número final es el orden de la foto
      const key = base.replace(/\s*\(\d+\)$/, "").replace(/[-_ ]\d{1,2}$/, "");
      const p = bySku.get(norm(base)) || bySku.get(norm(key)) || bySlug.get(slugify(base)) || bySlug.get(slugify(key));
      const order = Number((base.match(/[-_ (](\d{1,2})\)?$/) || [])[1] || 0);
      return { file: f, product: p || null, order };
    }).sort((a, b) => a.order - b.order);
  }

  function renderPhotoPlan() {
    const esc = window.Lambert.esc;
    const ok = photoPlan.filter((x) => x.product);
    const miss = photoPlan.filter((x) => !x.product);
    $("phPlan").innerHTML = `
      <div class="notice" style="margin:10px 0"><b>${ok.length}</b> fotos encontraron su producto · <span style="color:var(--danger)">${miss.length} sin coincidencia</span></div>
      ${ok.length ? `<div style="max-height:220px;overflow:auto;font-size:13px">${ok.map((x) => `<div style="padding:3px 0;border-bottom:1px solid var(--border)">${esc(x.file.name)} → <b>${esc(x.product.name)}</b></div>`).join("")}</div>` : ""}
      ${miss.length ? `<p class="muted" style="margin-top:8px">Sin coincidencia: ${miss.slice(0, 20).map((x) => esc(x.file.name)).join(", ")}${miss.length > 20 ? "…" : ""}. Renómbralas con la referencia (SKU) o el nombre del producto.</p>` : ""}
      <label class="row" style="font-size:14px;margin-top:8px"><input type="checkbox" id="phReplace"> Reemplazar las fotos que ya tenga cada producto</label>
      <div class="row" style="margin-top:10px">
        <button class="btn btn-primary" id="phApply" ${ok.length ? "" : "disabled"}>Subir ${ok.length} foto(s)</button>
        <button class="btn" id="phCancel">Cancelar</button>
      </div>`;
    $("phApply").onclick = uploadPhotos;
    $("phCancel").onclick = () => { photoPlan = []; $("phPlan").innerHTML = ""; $("phFiles").value = ""; };
  }

  async function uploadPhotos() {
    const { db, C } = ctx;
    const { compressImage } = window.Lambert;
    const replace = $("phReplace").checked;
    const items = photoPlan.filter((x) => x.product);
    $("phApply").disabled = true;
    const st = (msg, kind = "") => { $("phStatus").textContent = msg; $("phStatus").className = `status ${kind}`; };
    const byProduct = new Map();
    for (const x of items) { if (!byProduct.has(x.product.id)) byProduct.set(x.product.id, []); byProduct.get(x.product.id).push(x); }
    let n = 0, fails = 0;
    for (const [pid, list] of byProduct) {
      const p = list[0].product;
      let start = p.media.filter((m) => m.kind === "photo").length;
      if (replace) {
        const old = p.media.filter((m) => m.kind === "photo");
        if (old.length) {
          await db.storage.from(C.bucket).remove(old.map((m) => m.path));
          await db.from("product_media").delete().in("id", old.map((m) => m.id));
        }
        start = 0;
      }
      const rows = [];
      for (const x of list) {
        st(`Subiendo ${++n} de ${items.length}…`);
        const body = await compressImage(x.file, 1600);
        const ext = body.type === "image/webp" ? "webp" : (x.file.name.split(".").pop() || "jpg").toLowerCase();
        const path = `${pid}/photo/${crypto.randomUUID()}.${ext}`;
        const { error } = await db.storage.from(C.bucket).upload(path, body, { contentType: body.type || x.file.type, cacheControl: "31536000" });
        if (error) { fails++; continue; }
        rows.push({ product_id: pid, kind: "photo", path, position: start + rows.length });
      }
      if (rows.length) { const { error } = await db.from("product_media").insert(rows); if (error) fails += rows.length; }
    }
    photoPlan = [];
    $("phPlan").innerHTML = "";
    $("phFiles").value = "";
    await ctx.refresh();
    st(fails ? `Listo, pero ${fails} foto(s) fallaron.` : `Listo ✓ ${items.length} foto(s) subidas.`, fails ? "err" : "ok");
  }

  function init(c) {
    ctx = c;
    if (c.headless) return;
    $("expBtn").onclick = exportCatalog;
    $("tplBtn").onclick = downloadTemplate;
    $("impFile").onchange = async (e) => {
      const f = e.target.files[0];
      if (!f) return;
      $("impStatus").textContent = "Leyendo…"; $("impStatus").className = "status";
      try {
        plan = buildPlan(await readTable(f), $("impCreate").checked);
        $("impStatus").textContent = "";
        renderPlan();
      } catch (err) {
        console.error(err);
        $("impStatus").textContent = err.message || "No se pudo leer el archivo.";
        $("impStatus").className = "status err";
      }
    };
    $("impCreate").onchange = () => { if ($("impFile").files[0]) $("impFile").onchange({ target: $("impFile") }); };
    $("phFiles").onchange = (e) => {
      photoPlan = matchPhotos([...e.target.files]);
      $("phStatus").textContent = "";
      renderPhotoPlan();
    };
  }

  window.LambertImport = { init, buildPlan, parseNumber, parseCSV, mapHeader, matchPhotos };
})();
