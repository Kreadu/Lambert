// Ilustraciones de los baños de muestra (tienda.html): vista isométrica en SVG, con piso, paredes,
// cerámica y aparatos reconocibles. Mismas medidas y posiciones que los baños de muestra de disenar.html.
// Coordenadas en metros: x a la derecha (pared izquierda en x = 0), z hacia adelante (pared del fondo en
// z = 0), y hacia arriba. Se ve desde adelante a la derecha: se dibujan la pared del fondo y la izquierda.
(function () {
  const CX = Math.cos(Math.PI / 6), SY = 0.5;
  const P = (x, y, z) => [(x - z) * CX, (x + z) * SY - y];
  const f3 = (n) => +n.toFixed(3);
  const pts = (a) => a.map(([x, y, z]) => P(x, y, z).map(f3).join(",")).join(" ");
  const EDGE = 'stroke="rgba(30,30,30,.16)" stroke-width="0.006" stroke-linejoin="round"';
  const poly = (a, fill, extra = EDGE) => `<polygon points="${pts(a)}" fill="${fill}" ${extra}/>`;

  function shade(hex, f) {
    const n = parseInt(hex.slice(1), 16);
    const ch = (v) => Math.round(Math.min(255, Math.max(0, f > 0 ? v + (255 - v) * f : v * (1 + f))));
    return `rgb(${ch(n >> 16)},${ch((n >> 8) & 255)},${ch(n & 255)})`;
  }
  // caja con sus tres caras visibles: arriba, adelante (+z) y derecha (+x)
  function box(x0, x1, y0, y1, z0, z1, color) {
    return poly([[x0, y1, z0], [x1, y1, z0], [x1, y1, z1], [x0, y1, z1]], shade(color, 0.08)) +
      poly([[x0, y0, z1], [x1, y0, z1], [x1, y1, z1], [x0, y1, z1]], color) +
      poly([[x1, y0, z0], [x1, y0, z1], [x1, y1, z1], [x1, y1, z0]], shade(color, -0.12));
  }
  // planos: lo de adentro se dibuja en 2D (u, v) y queda sobre el piso, la pared del fondo o la izquierda
  const onTop = (h, s) => `<g transform="matrix(${f3(CX)} ${SY} ${f3(-CX)} ${SY} 0 ${f3(-h)})">${s}</g>`;
  const onBack = (z, s) => `<g transform="matrix(${f3(CX)} ${SY} 0 -1 ${f3(-z * CX)} ${f3(z * SY)})">${s}</g>`;
  const onLeft = (x, s) => `<g transform="matrix(${f3(-CX)} ${SY} 0 -1 ${f3(x * CX)} ${f3(x * SY)})">${s}</g>`;

  // aparatos contra una pared: f = "z" (de espaldas al fondo) o "x" (de espaldas a la izquierda);
  // a = posición a lo largo de la pared, b = distancia desde la pared
  const xz = (f, a0, a1, b0, b1) => (f === "z" ? [a0, a1, b0, b1] : [b0, b1, a0, a1]);
  const boxL = (f, a0, a1, b0, b1, y0, y1, c) => { const [x0, x1, z0, z1] = xz(f, a0, a1, b0, b1); return box(x0, x1, y0, y1, z0, z1, c); };
  const ell = (f, a, b, ra, rb, fill, extra = "") => (f === "z"
    ? `<ellipse cx="${f3(a)}" cy="${f3(b)}" rx="${f3(ra)}" ry="${f3(rb)}" fill="${fill}" ${extra}/>`
    : `<ellipse cx="${f3(b)}" cy="${f3(a)}" rx="${f3(rb)}" ry="${f3(ra)}" fill="${fill}" ${extra}/>`);
  const onWall = (f, s) => (f === "z" ? onBack(0.002, s) : onLeft(0.002, s));
  const key = (f, a, b) => (f === "z" ? a + b : a + b);

  const WHITE = "#fbfbfa", CHROME = "#aeb6bb", WATER = "#dbe8ee";
  const LINE = 'stroke="rgba(30,30,30,.22)" stroke-width="0.007"';

  // sólido ovalado (taza, lavamanos, tina): elipses apiladas y la tapa
  function oval(f, a, b, ra, rb, y0, y1, side, top = WHITE) {
    let s = "";
    for (let y = y0; y < y1; y += 0.02) s += onTop(y, ell(f, a, b, ra, rb, side));
    return s + onTop(y1, ell(f, a, b, ra, rb, top, LINE));
  }
  function faucet(f, a, b, y) {
    return boxL(f, a - 0.018, a + 0.018, b, b + 0.035, y, y + 0.14, CHROME) + boxL(f, a - 0.014, a + 0.014, b, b + 0.12, y + 0.12, y + 0.145, CHROME);
  }

  const items = {
    toilet: ({ f, a, suspended }) => ({ k: key(f, a, 0.3), s:
      (suspended ? onWall(f, `<rect x="${a - 0.1}" y="0.95" width="0.2" height="0.13" rx="0.015" fill="${CHROME}"/>`)
        : boxL(f, a - 0.19, a + 0.19, 0, 0.17, 0.4, 0.8, WHITE) + boxL(f, a - 0.2, a + 0.2, 0, 0.19, 0.8, 0.83, WHITE)) +
      (suspended ? boxL(f, a - 0.15, a + 0.15, 0, 0.12, 0.28, 0.42, WHITE) : boxL(f, a - 0.1, a + 0.1, 0.17, 0.46, 0, 0.32, "#eef0f1")) +
      oval(f, a, 0.4, 0.18, 0.25, suspended ? 0.3 : 0.3, 0.42, "#e9ecee") +
      onTop(0.421, ell(f, a, 0.42, 0.115, 0.16, WATER)) }),
    sinkPedestal: ({ f, a }) => ({ k: key(f, a, 0.2), s:
      boxL(f, a - 0.07, a + 0.07, 0.05, 0.19, 0, 0.72, "#eef0f1") +
      oval(f, a, 0.24, 0.28, 0.21, 0.72, 0.85, "#e9ecee") + onTop(0.851, ell(f, a, 0.26, 0.19, 0.13, WATER)) + faucet(f, a, 0.03, 0.85) }),
    sinkWall: ({ f, a }) => ({ k: key(f, a, 0.2), s:
      boxL(f, a - 0.28, a + 0.28, 0, 0.44, 0.72, 0.86, WHITE) +
      onTop(0.861, f === "z" ? `<rect x="${a - 0.2}" y="0.12" width="0.4" height="0.27" rx="0.09" fill="${WATER}"/>` : `<rect x="0.12" y="${a - 0.2}" width="0.27" height="0.4" rx="0.09" fill="${WATER}"/>`) +
      faucet(f, a, 0.02, 0.86) }),
    vanity: ({ f, a, w, wood }) => {
      const n = w >= 0.9 ? 2 : 1;
      let s = boxL(f, a - w / 2, a + w / 2, 0, 0.46, 0.2, 0.62, wood) +
        boxL(f, a - w / 2 - 0.01, a + w / 2 + 0.01, 0, 0.48, 0.62, 0.66, "#f4f3f0");
      for (let i = 0; i < n; i++) {
        const c = a - w / 2 + (w / n) * (i + 0.5);
        s += onTop(0.661, f === "z" ? `<rect x="${c - 0.17}" y="0.14" width="0.34" height="0.25" rx="0.08" fill="${WATER}" ${LINE}/>`
          : `<rect x="0.14" y="${c - 0.17}" width="0.25" height="0.34" rx="0.08" fill="${WATER}" ${LINE}/>`) + faucet(f, c, 0.03, 0.66);
      }
      // tirador del cajón
      s += boxL(f, a - 0.1, a + 0.1, 0.46, 0.475, 0.5, 0.52, "#6b6b6b");
      return { k: key(f, a, 0.24), s };
    },
    mirror: ({ f, a, w, h, y, led }) => ({ k: key(f, a, 0), s: onWall(f,
      (led ? `<rect x="${a - w / 2 - 0.03}" y="${y - h / 2 - 0.03}" width="${w + 0.06}" height="${h + 0.06}" rx="0.06" fill="#fff4cf" opacity=".85"/>` : "") +
      `<rect x="${a - w / 2}" y="${y - h / 2}" width="${w}" height="${h}" rx="${led ? 0.04 : 0.02}" fill="url(#mirror)" stroke="${led ? "#f2f2f2" : "#8f9aa0"}" stroke-width="0.02"/>` +
      `<path d="M${a - w / 4} ${y - h / 2 + 0.08} l${w / 3} ${h * 0.6} M${a - w / 10} ${y - h / 2 + 0.08} l${w / 6} ${h * 0.35}" stroke="#fff" stroke-width="0.025" opacity=".6"/>`) }),
    tray: ({ x0, x1, z0, z1 }) => ({ k: (x0 + x1) / 2 + (z0 + z1) / 2 - 0.4, s:
      box(x0, x1, 0, 0.045, z0, z1, "#f2f2ef") +
      onTop(0.046, `<rect x="${(x0 + x1) / 2 - 0.08}" y="${(z0 + z1) / 2 - 0.08}" width="0.16" height="0.16" rx="0.02" fill="${CHROME}"/>`) }),
    glass: ({ x0, z0, x1, z1, h = 1.95 }) => ({ k: (x0 + x1) / 2 + (z0 + z1) / 2, s:
      poly([[x0, 0.05, z0], [x1, 0.05, z1], [x1, h, z1], [x0, h, z0]], "rgba(160,206,222,.30)", 'stroke="#86adb9" stroke-width="0.012"') +
      poly([[x0, h - 0.02, z0], [x1, h - 0.02, z1], [x1, h + 0.02, z1], [x0, h + 0.02, z0]], CHROME, "") }),
    showerHead: ({ f = "z", a, y = 2.02, r = 0.12 }) => ({ k: key(f, a, 0), s:
      onWall(f, `<rect x="${a - 0.08}" y="1.0" width="0.16" height="0.2" rx="0.03" fill="${CHROME}"/><circle cx="${a}" cy="1.1" r="0.035" fill="#7d878c"/>` +
        `<rect x="${a - 0.012}" y="1.2" width="0.024" height="${y - 1.2}" fill="${CHROME}"/>`) +
      boxL(f, a - 0.012, a + 0.012, 0, r + 0.1, y - 0.02, y + 0.01, CHROME) +
      oval(f, a, r + 0.1, r, r, y - 0.05, y - 0.02, "#9aa3a8", "#c4cbcf") }),
    tub: ({ cx, cz, lx, lz }) => {
      let s = onTop(0, `<ellipse cx="${cx}" cy="${cz}" rx="${lx / 2 + 0.02}" ry="${lz / 2 + 0.02}" fill="rgba(0,0,0,.08)"/>`);
      for (let y = 0.02; y < 0.58; y += 0.02) s += onTop(y, `<ellipse cx="${cx}" cy="${cz}" rx="${f3(lx / 2 * (0.9 + y / 6))}" ry="${f3(lz / 2 * (0.9 + y / 6))}" fill="#eceff0"/>`);
      s += onTop(0.58, `<ellipse cx="${cx}" cy="${cz}" rx="${f3(lx / 2)}" ry="${f3(lz / 2)}" fill="${WHITE}" ${LINE}/><ellipse cx="${cx}" cy="${cz}" rx="${f3(lx / 2 - 0.07)}" ry="${f3(lz / 2 - 0.07)}" fill="${WATER}"/>`);
      // grifería de piso
      s += box(cx + lx / 2 + 0.06, cx + lx / 2 + 0.1, 0, 0.9, cz - 0.02, cz + 0.02, CHROME) + box(cx + lx / 2 - 0.1, cx + lx / 2 + 0.1, 0.88, 0.91, cz - 0.015, cz + 0.015, CHROME);
      return { k: cx + cz, s };
    },
    towel: ({ a, y = 1.15, color }) => ({ k: a, s: onLeft(0.002,
      `<rect x="${a - 0.18}" y="${y - 0.5}" width="0.36" height="0.48" rx="0.02" fill="${color}"/>` +
      `<rect x="${a - 0.18}" y="${y - 0.14}" width="0.36" height="0.03" fill="rgba(255,255,255,.35)"/>` +
      `<rect x="${a - 0.25}" y="${y - 0.03}" width="0.5" height="0.025" rx="0.01" fill="${CHROME}"/>`) }),
    mat: ({ x0, x1, z0, z1, color }) => ({ k: -1, s: onTop(0.003, `<rect x="${x0}" y="${z0}" width="${x1 - x0}" height="${z1 - z0}" rx="0.04" fill="${color}"/>` +
      `<rect x="${x0 + 0.04}" y="${z0 + 0.04}" width="${x1 - x0 - 0.08}" height="${z1 - z0 - 0.08}" rx="0.03" fill="none" stroke="rgba(255,255,255,.35)" stroke-width="0.01"/>`) }),
    measure: ({ W, L }) => ({ k: -2, s: onTop(0.004,
      `<path d="M0.15 ${L - 0.25}H${W - 0.15}M0.15 ${L - 0.32}V${L - 0.18}M${W - 0.15} ${L - 0.32}V${L - 0.18}` +
      `M${W - 0.25} 0.15V${L - 0.45}M${W - 0.32} 0.15H${W - 0.18}M${W - 0.32} ${L - 0.45}H${W - 0.18}" stroke="#2563eb" stroke-width="0.025" fill="none" stroke-linecap="round"/>`) }),
    plant: ({ x, z }) => {
      let s = box(x - 0.1, x + 0.1, 0, 0.3, z - 0.1, z + 0.1, "#c98663");
      const [px, py] = P(x, 0.55, z);
      const leaves = [[0, -0.12, 0.13, "#5f8f62"], [-0.1, -0.02, 0.11, "#4f7d55"], [0.1, -0.03, 0.11, "#6fa070"], [0.02, 0.06, 0.12, "#5a8a5c"], [-0.04, -0.2, 0.08, "#7bab79"]];
      s += leaves.map(([dx, dy, r, c]) => `<circle cx="${f3(px + dx)}" cy="${f3(py + dy)}" r="${r}" fill="${c}"/>`).join("");
      return { k: x + z + 0.2, s };
    },
  };

  // ── Los cuatro baños: medidas, colores y aparatos ──
  const SAMPLES = {
    medio: { W: 1.2, L: 1.5, tint: "#f3e3d6",
      floor: { kind: "tile", size: 0.3, color: "#dcc9b0", grout: "#c7b293" },
      wall: { color: "#f6f2ec", tile: [0.3, 0.6] },
      accents: [{ wall: "back", u0: 0, u1: 1.2, v1: 1.05, color: "#c98f6c", tile: [0.1, 0.1] }],
      items: [
        ["mirror", { f: "z", a: 0.33, w: 0.45, h: 0.6, y: 1.5 }],
        ["toilet", { f: "z", a: 0.9 }],
        ["sinkPedestal", { f: "z", a: 0.33 }],
        ["towel", { a: 0.85, color: "#e0b25c" }],
        ["mat", { x0: 0.1, x1: 0.6, z0: 0.55, z1: 0.85, color: "#d7a184" }],
      ] },
    pequeno: { W: 1.5, L: 2.0, tint: "#e2ede6",
      floor: { kind: "tile", size: 0.6, color: "#c3c6c4", grout: "#a9adab" },
      wall: { color: "#f4f6f4", tile: [0.3, 0.3] },
      accents: [{ wall: "back", u0: 0.72, u1: 1.5, v1: 2.1, color: "#8fb19c", tile: [0.075, 0.3] }],
      items: [
        ["showerHead", { a: 1.12 }],
        ["mirror", { f: "x", a: 1.35, w: 0.5, h: 0.65, y: 1.45 }],
        ["toilet", { f: "z", a: 0.35 }],
        ["glass", { x0: 0.72, z0: 0, x1: 0.72, z1: 0.85 }],
        ["tray", { x0: 0.74, x1: 1.5, z0: 0, z1: 0.8 }],
        ["sinkWall", { f: "x", a: 1.35 }],
        ["towel", { a: 1.85, color: "#5f8d76" }],
        ["mat", { x0: 0.8, x1: 1.35, z0: 0.95, z1: 1.3, color: "#f0f0ec" }],
      ] },
    estandar: { W: 1.8, L: 2.4, tint: "#ece4da",
      floor: { kind: "wood", size: 0.2, color: "#b98d66", grout: "#9d7552" },
      wall: { color: "#f3f1ee", tile: [0.6, 0.3] },
      accents: [{ wall: "back", u0: 0.9, u1: 1.8, v1: 2.1, color: "#5e6872", tile: [0.3, 0.6] }],
      items: [
        ["showerHead", { a: 1.35, r: 0.15 }],
        ["mirror", { f: "x", a: 1.65, w: 0.6, h: 0.75, y: 1.45, led: true }],
        ["towel", { a: 0.75, color: "#e7dcc8" }],
        ["toilet", { f: "z", a: 0.45 }],
        ["tray", { x0: 0.92, x1: 1.8, z0: 0, z1: 0.9 }],
        ["vanity", { f: "x", a: 1.65, w: 0.6, wood: "#7b5a43" }],
        ["glass", { x0: 0.92, z0: 0.92, x1: 1.8, z1: 0.92 }],
        ["mat", { x0: 1.0, x1: 1.6, z0: 1.05, z1: 1.45, color: "#e6ded1" }],
        ["plant", { x: 0.2, z: 2.2 }],
      ] },
    principal: { W: 2.5, L: 3.0, tint: "#e4e2df",
      floor: { kind: "tile", size: 0.6, color: "#4a4f53", grout: "#3a3e41", vein: true },
      wall: { color: "#efe9e0", tile: [0.6, 1.2] },
      accents: [{ wall: "back", u0: 0.95, u1: 2.15, v1: 2.25, color: "#d8cbb8", tile: [1.2, 0.6] }],
      items: [
        ["mirror", { f: "x", a: 1.9, w: 0.9, h: 0.75, y: 1.5, led: true }],
        ["towel", { a: 0.8, color: "#b9a78d" }],
        ["toilet", { f: "z", a: 0.5, suspended: true }],
        ["tub", { cx: 1.55, cz: 0.55, lx: 1.6, lz: 0.78 }],
        ["plant", { x: 2.3, z: 0.25 }],
        ["vanity", { f: "x", a: 1.9, w: 1.0, wood: "#d9c4a5" }],
        ["mat", { x0: 1.15, x1: 1.95, z0: 1.1, z1: 1.45, color: "#9aa4a0" }],
        ["glass", { x0: 1.8, z0: 1.75, x1: 1.8, z1: 2.65 }],
        ["tray", { x0: 1.8, x1: 2.5, z0: 1.75, z1: 3.0 }],
      ] },
    // "Empezar de cero": el baño vacío, con las medidas marcadas en el piso
    vacio: { W: 1.8, L: 2.4, tint: "#ecebe8",
      floor: { kind: "tile", size: 0.6, color: "#eceae6", grout: "#d6d2cb" },
      wall: { color: "#f7f6f4", tile: [0.6, 1.2] },
      accents: [],
      items: [
        ["measure", { W: 1.8, L: 2.4 }],
      ] },
  };

  function pattern(id, w, h, color, grout, kind) {
    if (kind === "wood") {
      // tablas de madera en dos columnas desfasadas
      return `<pattern id="${id}" width="${w * 2}" height="1.2" patternUnits="userSpaceOnUse"><rect width="${w * 2}" height="1.2" fill="${color}"/>
        <rect x="${w}" width="${w}" height="1.2" fill="${shade(color, -0.05)}"/>
        <path d="M0 0V1.2M${w} 0V1.2M0 0.01H${w}M${w} 0.6H${w * 2}" stroke="${grout}" stroke-width="0.01"/></pattern>`;
    }
    return `<pattern id="${id}" width="${w}" height="${h}" patternUnits="userSpaceOnUse"><rect width="${w}" height="${h}" fill="${color}"/>
      <path d="M0 0H${w}M0 0V${h}" stroke="${grout}" stroke-width="0.008"/></pattern>`;
  }

  /** SVG del baño de muestra `id`, o "" si no existe. */
  function draw(id) {
    const t = SAMPLES[id];
    if (!t) return "";
    const { W, L } = t, H = 2.25, T = 0.08;
    const pid = `m-${id}`;
    const wallGrout = shade(t.wall.color, -0.06);
    let defs = `<linearGradient id="mirror" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#e9f3f7"/><stop offset="1" stop-color="#b9cdd6"/></linearGradient>` +
      pattern(`${pid}-f`, t.floor.size, t.floor.size, t.floor.color, t.floor.grout, t.floor.kind) +
      pattern(`${pid}-w`, t.wall.tile[0], t.wall.tile[1], t.wall.color, wallGrout);
    t.accents.forEach((ac, i) => { defs += pattern(`${pid}-a${i}`, ac.tile[0], ac.tile[1], ac.color, shade(ac.color, -0.12)); });

    let s = "";
    // losa y bordes de los muros (corte)
    s += box(-T, W, -0.07, 0, -T, L, "#d6cfc4");
    s += onTop(0, `<rect width="${W}" height="${L}" fill="url(#${pid}-f)"/>` +
      (t.floor.vein ? `<path d="M0.2 0.4C0.8 0.9 1.2 0.5 1.9 1.3S2.3 2.4 2.5 2.6M0 1.9C0.6 1.7 1 2.4 1.6 2.3" stroke="rgba(255,255,255,.12)" stroke-width="0.02" fill="none"/>` : ""));
    s += onBack(0, `<rect width="${W}" height="${H}" fill="url(#${pid}-w)"/>`);
    s += onLeft(0, `<rect width="${L}" height="${H}" fill="${shade(t.wall.color, -0.04)}"/><rect width="${L}" height="${H}" fill="url(#${pid}-w)" opacity=".9"/>`);
    t.accents.forEach((ac, i) => {
      const r = `<rect x="${ac.u0}" y="0" width="${ac.u1 - ac.u0}" height="${ac.v1}" fill="url(#${pid}-a${i})"/>`;
      s += ac.wall === "back" ? onBack(0.001, r) : onLeft(0.001, r);
    });
    // zócalo de sombra donde el piso toca los muros
    s += onTop(0.001, `<rect width="${W}" height="0.06" fill="rgba(0,0,0,.06)"/><rect width="0.06" height="${L}" fill="rgba(0,0,0,.05)"/>`);
    // cantos de los muros cortados
    s += poly([[-T, H, -T], [W, H, -T], [W, H, 0], [0, H, 0], [0, H, L], [-T, H, L]], "#d9d3ca");
    s += poly([[W, 0, -T], [W, 0, 0], [W, H, 0], [W, H, -T]], "#cbc4b9");
    s += poly([[-T, 0, L], [0, 0, L], [0, H, L], [-T, H, L]], "#c4bdb2");

    s += t.items.map(([kind, o]) => items[kind](o)).sort((p, q) => p.k - q.k).map((x) => x.s).join("");

    // encuadre: las esquinas del baño
    const corners = [];
    for (const x of [-T, W]) for (const y of [-0.07, H]) for (const z of [-T, L]) corners.push(P(x, y, z));
    const xs = corners.map((c) => c[0]), ys = corners.map((c) => c[1]);
    const m = 0.12, x0 = Math.min(...xs) - m, y0 = Math.min(...ys) - m;
    const vw = Math.max(...xs) + m - x0, vh = Math.max(...ys) + m - y0;
    return `<svg viewBox="${f3(x0)} ${f3(y0)} ${f3(vw)} ${f3(vh)}" role="img" aria-hidden="true"><defs>${defs}</defs>${s}</svg>`;
  }

  window.Muestras = { draw, tint: (id) => SAMPLES[id]?.tint || "#eee" };
})();
