// Ilustraciones 2D de prueba (SVG) para productos sin foto, pintadas con el color de la variante.
// Lambert.illustrate(producto, variante) → data URI. Una foto real siempre tiene prioridad.
(function () {
  const BG = "#f3f1ec";

  function hex(c, fb) { return /^#[0-9a-f]{6}$/i.test(c || "") ? c : fb; }
  function shade(c, amt) {
    const n = parseInt(c.slice(1), 16);
    const f = (x) => Math.max(0, Math.min(255, Math.round(x + amt * 255)));
    return "#" + [f(n >> 16), f((n >> 8) & 255), f(n & 255)].map((x) => x.toString(16).padStart(2, "0")).join("");
  }
  const lum = (c) => { const n = parseInt(c.slice(1), 16); return (0.299 * (n >> 16) + 0.587 * ((n >> 8) & 255) + 0.114 * (n & 255)) / 255; };

  // Piezas de dibujo reutilizables (c = color principal, d = sombra, l = luz, m = metal)
  const S = {
    shadow: (w = 70) => `<ellipse cx="100" cy="172" rx="${w}" ry="7" fill="#000" opacity=".08"/>`,
    wall: () => `<rect x="0" y="0" width="200" height="200" fill="#ebe8e1"/><rect x="0" y="176" width="200" height="24" fill="#dedad1"/>`,
    lever: (x, y, m) => `<rect x="${x}" y="${y}" width="22" height="6" rx="3" fill="${m}"/>`,
  };

  // Cada dibujo recibe la paleta { c, d, l, m, k } y devuelve SVG interior (viewBox 0 0 200 200)
  const D = {
    toilet: ({ c, d, l }, o = {}) => `${S.shadow(48)}
      ${o.tank === false ? "" : `<rect x="58" y="${o.one ? 62 : 38}" width="84" height="${o.one ? 40 : 50}" rx="8" fill="${c}" stroke="${d}"/>
      <rect x="52" y="${o.one ? 56 : 32}" width="96" height="10" rx="5" fill="${l}" stroke="${d}"/>
      <rect x="92" y="${o.one ? 66 : 44}" width="16" height="6" rx="3" fill="${d}" opacity=".5"/>`}
      <rect x="56" y="100" width="88" height="12" rx="6" fill="${l}" stroke="${d}"/>
      <path d="M62 112 Q62 150 84 158 L116 158 Q138 150 138 112 Z" fill="${c}" stroke="${d}"/>
      ${o.wall ? `<rect x="40" y="96" width="8" height="66" fill="${d}" opacity=".3"/>` : `<rect x="82" y="152" width="36" height="18" rx="4" fill="${c}" stroke="${d}"/>`}`,
    bidet: (p) => `${S.shadow(44)}<path d="M60 96 Q60 150 84 160 L116 160 Q140 150 140 96 Z" fill="${p.c}" stroke="${p.d}"/>
      <ellipse cx="100" cy="96" rx="40" ry="10" fill="${p.l}" stroke="${p.d}"/><ellipse cx="100" cy="97" rx="28" ry="6" fill="${p.d}" opacity=".25"/>
      <rect x="94" y="78" width="12" height="16" rx="3" fill="#c0c4c8"/>`,
    urinal: (p) => `${S.wall()}<path d="M70 40 Q100 28 130 40 L130 120 Q130 150 100 156 Q70 150 70 120 Z" fill="${p.c}" stroke="${p.d}"/>
      <path d="M80 70 Q100 64 120 70 L120 118 Q118 138 100 142 Q82 138 80 118 Z" fill="${p.d}" opacity=".18"/>`,
    seat: (p, o = {}) => `${S.shadow(46)}<ellipse cx="100" cy="112" rx="48" ry="56" fill="${p.c}" stroke="${p.d}" stroke-width="2"/>
      <ellipse cx="100" cy="118" rx="28" ry="36" fill="${BG}" stroke="${p.d}"/><rect x="74" y="50" width="52" height="10" rx="5" fill="${p.d}"/>
      ${o.bidet ? `<rect x="96" y="80" width="8" height="26" rx="4" fill="#9aa4ab"/><circle cx="100" cy="106" r="4" fill="#5f6f7f"/>
        <rect x="148" y="62" width="20" height="34" rx="5" fill="${p.c}" stroke="${p.d}"/><circle cx="158" cy="79" r="6" fill="#c0c4c8"/>` : ""}`,
    flushPlate: ({ m, d }) => `${S.wall()}<rect x="60" y="60" width="80" height="54" rx="6" fill="${m}" stroke="${d}"/>
      <rect x="66" y="66" width="32" height="42" rx="4" fill="${shade(m, 0.08)}" stroke="${d}"/><rect x="102" y="66" width="32" height="42" rx="4" fill="${shade(m, 0.08)}" stroke="${d}"/>`,

    basin: (p, o = {}) => {
      const top = o.counter ? `<rect x="20" y="96" width="160" height="12" fill="#cfcac0"/>` : "";
      const bowl = o.vessel
        ? (o.rect ? `<rect x="54" y="${o.counter ? 66 : 86}" width="92" height="32" rx="8" fill="${p.c}" stroke="${p.d}"/><rect x="62" y="${o.counter ? 66 : 86}" width="76" height="6" rx="3" fill="${p.d}" opacity=".3"/>`
          : `<path d="M58 ${o.counter ? 70 : 90} Q58 98 100 98 Q142 98 142 ${o.counter ? 70 : 90} Z" fill="${p.c}" stroke="${p.d}"/><ellipse cx="100" cy="${o.counter ? 70 : 90}" rx="42" ry="7" fill="${p.d}" opacity=".3"/>`)
        : `<path d="M44 86 L156 86 L148 112 Q140 124 100 124 Q60 124 52 112 Z" fill="${p.c}" stroke="${p.d}"/><ellipse cx="100" cy="92" rx="44" ry="6" fill="${p.d}" opacity=".25"/>
           <rect x="94" y="72" width="12" height="16" rx="3" fill="#c0c4c8"/><rect x="92" y="70" width="22" height="5" rx="2" fill="#c0c4c8"/>`;
      const ped = o.pedestal ? `<path d="M88 124 L84 170 L116 170 L112 124 Z" fill="${p.c}" stroke="${p.d}"/>` :
        o.semi ? `<path d="M88 124 L86 150 L114 150 L112 124 Z" fill="${p.c}" stroke="${p.d}"/>` : "";
      return `${o.wall ? S.wall() : S.shadow(o.pedestal ? 30 : 60)}${top}${bowl}${ped}`;
    },
    cornerBasin: (p) => `${S.wall()}<path d="M40 80 L160 80 Q150 130 100 132 Q60 128 40 80 Z" fill="${p.c}" stroke="${p.d}"/><ellipse cx="100" cy="88" rx="40" ry="6" fill="${p.d}" opacity=".25"/>`,

    faucet: ({ m, d }, o = {}) => {
      const h = o.tall ? 110 : 60;
      const base = 160;
      let s = `${S.shadow(34)}<rect x="40" y="${base}" width="120" height="8" rx="2" fill="#dad5cb"/>`;
      if (o.two) {
        s += `<rect x="92" y="${base - 46}" width="16" height="46" rx="6" fill="${m}" stroke="${d}"/><path d="M100 ${base - 44} Q100 ${base - 62} 130 ${base - 58}" stroke="${m}" stroke-width="10" fill="none" stroke-linecap="round"/>
          ${[56, 144].map((x) => `<circle cx="${x}" cy="${base - 10}" r="12" fill="${m}" stroke="${d}"/><rect x="${x - 3}" y="${base - 30}" width="6" height="22" rx="3" fill="${m}" stroke="${d}"/>`).join("")}`;
        return s;
      }
      s += `<rect x="86" y="${base - h}" width="28" height="${h}" rx="10" fill="${m}" stroke="${d}"/>
        <path d="M100 ${base - h + 8} Q100 ${base - h - 10} 140 ${base - h - 2} L140 ${base - h + 10}" stroke="${m}" stroke-width="12" fill="none" stroke-linecap="round"/>`;
      if (o.push) s += `<ellipse cx="100" cy="${base - h}" rx="16" ry="6" fill="${shade(m, -0.15)}"/>`;
      else if (o.sensor) s += `<circle cx="100" cy="${base - h + 26}" r="5" fill="#222"/>`;
      else s += S.lever(98, base - h - 8, m);
      return s;
    },
    wallFaucet: ({ m, d }) => `${S.wall()}<rect x="56" y="70" width="88" height="40" rx="6" fill="${m}" stroke="${d}"/>
      <rect x="96" y="84" width="70" height="10" rx="5" fill="${m}" stroke="${d}"/>${S.lever(68, 62, m)}`,
    showerMixer: ({ m, d }, o = {}) => `${S.wall()}<circle cx="100" cy="96" r="${o.thermo ? 0 : 44}" fill="${m}" stroke="${d}"/>
      ${o.thermo ? `<rect x="30" y="80" width="140" height="34" rx="17" fill="${m}" stroke="${d}"/><circle cx="52" cy="97" r="13" fill="${shade(m, -0.12)}"/><circle cx="148" cy="97" r="13" fill="${shade(m, -0.12)}"/>`
        : `<rect x="96" y="56" width="8" height="44" rx="4" fill="${shade(m, -0.15)}" transform="rotate(-30 100 96)"/><circle cx="100" cy="96" r="12" fill="${shade(m, -0.1)}"/>`}
      ${o.diverter ? `<circle cx="100" cy="160" r="10" fill="${m}" stroke="${d}"/>` : ""}`,
    twoValves: ({ m, d }) => `${S.wall()}${[60, 140].map((x) => `<circle cx="${x}" cy="100" r="26" fill="${m}" stroke="${d}"/>
      <rect x="${x - 18}" y="96" width="36" height="8" rx="4" fill="${shade(m, -0.15)}"/><rect x="${x - 4}" y="82" width="8" height="36" rx="4" fill="${shade(m, -0.15)}"/>`).join("")}`,
    flushValve: ({ m, d }) => `${S.wall()}<rect x="92" y="30" width="16" height="140" rx="6" fill="${m}" stroke="${d}"/><rect x="74" y="70" width="52" height="34" rx="10" fill="${m}" stroke="${d}"/>${S.lever(110, 82, m)}`,

    showerHead: ({ m, d }, o = {}) => {
      const holes = Array.from({ length: 18 }, (_, i) => { const a = (i / 18) * Math.PI * 2, r = 18 + (i % 2) * 14; return `<circle cx="${100 + Math.cos(a) * r}" cy="${118 + Math.sin(a) * r * 0.32}" r="1.6" fill="${shade(m, -0.35)}"/>`; }).join("");
      const arm = o.ceiling ? `<rect x="0" y="0" width="200" height="14" fill="#dedad1"/><rect x="96" y="14" width="8" height="${o.flush ? 0 : 84}" fill="${m}"/>`
        : `<path d="M10 40 L100 40 L100 104" stroke="${m}" stroke-width="8" fill="none"/><rect x="2" y="30" width="14" height="20" rx="3" fill="${m}"/>`;
      const head = o.square ? `<rect x="50" y="104" width="100" height="22" rx="4" fill="${m}" stroke="${d}"/>` : `<ellipse cx="100" cy="114" rx="52" ry="16" fill="${m}" stroke="${d}"/>`;
      return `<rect width="200" height="200" fill="#ebe8e1"/>${arm}${head}${holes}`;
    },
    showerArm: ({ m, d }, o = {}) => o.ceiling
      ? `<rect width="200" height="200" fill="#ebe8e1"/><rect x="0" y="0" width="200" height="14" fill="#dedad1"/><rect x="94" y="14" width="12" height="130" rx="4" fill="${m}" stroke="${d}"/><circle cx="100" cy="150" r="10" fill="${m}"/>`
      : `<rect width="200" height="200" fill="#ebe8e1"/><rect x="10" y="60" width="18" height="30" rx="4" fill="${m}"/><path d="M20 75 L150 75 L160 92" stroke="${m}" stroke-width="12" fill="none" stroke-linecap="round"/>`,
    handShower: ({ m, d }, o = {}) => `${S.wall()}${o.bar ? `<rect x="146" y="20" width="10" height="150" rx="5" fill="${m}" stroke="${d}"/><rect x="138" y="58" width="26" height="14" rx="4" fill="${m}"/>` : `<rect x="138" y="56" width="22" height="18" rx="4" fill="${m}"/>`}
      <path d="M150 74 Q70 110 120 170 Q160 190 60 186" stroke="${shade(m, -0.1)}" stroke-width="5" fill="none"/>
      <rect x="136" y="40" width="16" height="70" rx="8" fill="${m}" stroke="${d}" transform="rotate(-18 144 75)"/><ellipse cx="133" cy="40" rx="16" ry="12" fill="${m}" stroke="${d}"/>`,
    column: ({ m, d }) => `${S.wall()}<rect x="96" y="30" width="8" height="140" rx="4" fill="${m}"/><path d="M100 30 Q100 18 120 18 L140 18" stroke="${m}" stroke-width="8" fill="none"/>
      <ellipse cx="146" cy="22" rx="34" ry="9" fill="${m}" stroke="${d}"/><rect x="80" y="120" width="40" height="22" rx="8" fill="${m}" stroke="${d}"/><rect x="60" y="80" width="12" height="40" rx="6" fill="${m}" stroke="${d}"/>`,
    electricShower: ({ c, d }) => `${S.wall()}<path d="M40 50 L100 50 L100 70" stroke="#c0c4c8" stroke-width="8" fill="none"/>
      <rect x="64" y="70" width="72" height="56" rx="18" fill="${c}" stroke="${d}"/><ellipse cx="100" cy="132" rx="38" ry="10" fill="${shade(c, -0.08)}" stroke="${d}"/><path d="M136 90 Q170 90 170 170" stroke="#333" stroke-width="3" fill="none"/>`,
    // ducha higiénica: llave o mezclador en la pared, manguera y la duchita colgada en su soporte
    bidetSpray: ({ m, d }, o = {}) => `${S.wall()}
      ${o.mixer ? `<circle cx="62" cy="70" r="26" fill="${m}" stroke="${d}"/>${S.lever(54, 50, m)}<rect x="56" y="64" width="12" height="12" rx="3" fill="${shade(m, -0.15)}"/>`
        : `<rect x="44" y="62" width="34" height="22" rx="6" fill="${m}" stroke="${d}"/><circle cx="61" cy="52" r="10" fill="${m}" stroke="${d}"/>`}
      ${o.tee ? `<rect x="20" y="96" width="40" height="10" rx="3" fill="#d0d3d6"/>` : ""}
      <path d="M62 ${o.mixer ? 96 : 84} Q60 170 110 168 Q150 166 140 100" stroke="${shade(m, -0.1)}" stroke-width="5" fill="none"/>
      <rect x="128" y="56" width="26" height="12" rx="3" fill="${m}"/>
      <path d="M130 64 L150 64 L146 110 Q140 118 134 110 Z" fill="${m}" stroke="${d}"/>
      <path d="M150 70 L162 64 L166 72 L152 78 Z" fill="${shade(m, -0.15)}"/>
      <rect x="144" y="84" width="6" height="16" rx="3" fill="${shade(m, -0.2)}"/>`,
    niche: ({ m, d }) => `${S.wall()}<rect x="50" y="30" width="100" height="140" rx="2" fill="${shade(m, -0.05)}" stroke="${d}"/><rect x="58" y="38" width="84" height="124" fill="#d9d4ca"/><rect x="58" y="96" width="84" height="5" fill="${m}"/>`,

    glass: ({ c, d }, o = {}) => {
      const m = "#8a8f93"; // perfilería
      const g = `fill="${shade(c, -0.12)}" fill-opacity=".55" stroke="${m}" stroke-width="3"`;
      if (o.corner) return `${S.shadow(70)}<path d="M40 30 L100 50 L100 170 L40 150 Z" ${g}/><path d="M100 50 L170 30 L170 150 L100 170 Z" ${g}/>`;
      if (o.curtain) return `<rect width="200" height="200" fill="#ebe8e1"/><rect x="20" y="20" width="160" height="5" rx="2" fill="#c0c4c8"/>
        <path d="M30 26 Q45 100 34 170 L170 170 Q160 100 172 26 Z" fill="${c}" stroke="${d}"/>${[60, 90, 120, 150].map((x) => `<path d="M${x} 26 Q${x + 8} 100 ${x} 170" stroke="${d}" fill="none" opacity=".4"/>`).join("")}`;
      if (o.profile) return `${S.shadow(60)}<rect x="20" y="80" width="160" height="16" rx="3" fill="${c}" stroke="${d}"/><rect x="20" y="100" width="160" height="8" rx="2" fill="${shade(c, -0.1)}"/><circle cx="60" cy="88" r="5" fill="${d}"/><circle cx="140" cy="88" r="5" fill="${d}"/>`;
      const panels = o.slide ? `<rect x="30" y="26" width="80" height="144" ${g}/><rect x="90" y="30" width="80" height="140" ${g}/>`
        : o.fixed ? `<rect x="50" y="26" width="90" height="144" ${g}/><path d="M140 40 L190 30" stroke="${m}" stroke-width="4"/>`
        : `<rect x="40" y="26" width="110" height="144" ${g}/><rect x="140" y="88" width="5" height="26" rx="2" fill="${m}"/>`;
      return `${S.shadow(70)}<rect x="20" y="22" width="160" height="5" fill="${m}"/>${panels}`;
    },
    tub: ({ c, d, l }, o = {}) => o.tray
      ? `${S.shadow(80)}<path d="M20 130 L180 130 L170 156 L30 156 Z" fill="${c}" stroke="${d}"/><path d="M34 132 L166 132 L160 146 L40 146 Z" fill="${shade(c, -0.06)}"/><circle cx="100" cy="140" r="6" fill="#9aa"/>`
      : o.free
        ? `${S.shadow(84)}<path d="M18 80 Q20 160 70 160 L130 160 Q180 160 182 80 Z" fill="${c}" stroke="${d}"/><ellipse cx="100" cy="80" rx="82" ry="12" fill="${l}" stroke="${d}"/><ellipse cx="100" cy="82" rx="70" ry="7" fill="${d}" opacity=".2"/>`
        : `${S.shadow(84)}<rect x="16" y="86" width="168" height="70" rx="6" fill="${c}" stroke="${d}"/><rect x="12" y="80" width="176" height="12" rx="6" fill="${l}" stroke="${d}"/><rect x="26" y="84" width="148" height="6" rx="3" fill="${d}" opacity=".2"/>
          ${o.jets ? [50, 80, 120, 150].map((x) => `<circle cx="${x}" cy="118" r="5" fill="${d}" opacity=".5"/>`).join("") : ""}`,

    vanity: ({ c, d }, o = {}) => {
      const y = o.floor ? 70 : 60, h = o.floor ? 100 : 70;
      const handles = o.doors ? `<rect x="96" y="${y + 24}" width="3" height="20" fill="${shade(c, -0.3)}"/><rect x="101" y="${y + 24}" width="3" height="20" fill="${shade(c, -0.3)}"/><line x1="100" y1="${y + 6}" x2="100" y2="${y + h}" stroke="${d}"/>`
        : `<line x1="34" y1="${y + h / 2}" x2="166" y2="${y + h / 2}" stroke="${d}"/><rect x="88" y="${y + h / 4 - 2}" width="24" height="4" rx="2" fill="${shade(c, -0.3)}"/><rect x="88" y="${y + (3 * h) / 4 - 2}" width="24" height="4" rx="2" fill="${shade(c, -0.3)}"/>`;
      return `${o.floor ? S.shadow(76) : S.wall()}<rect x="30" y="${y}" width="140" height="${h}" rx="3" fill="${c}" stroke="${d}"/>${handles}
        <rect x="26" y="${y - 10}" width="148" height="12" rx="3" fill="#f7f7f5" stroke="#d6d2c8"/><ellipse cx="100" cy="${y - 6}" rx="36" ry="4" fill="#d6d2c8"/>`;
    },
    tower: ({ c, d }, o = {}) => `${S.shadow(40)}<rect x="66" y="16" width="68" height="154" rx="3" fill="${c}" stroke="${d}"/>
      ${o.open ? [50, 90, 130].map((y) => `<rect x="70" y="${y}" width="60" height="4" fill="${shade(c, -0.15)}"/>`).join("") : `<line x1="66" y1="94" x2="134" y2="94" stroke="${d}"/><rect x="122" y="50" width="4" height="22" rx="2" fill="${shade(c, -0.3)}"/><rect x="122" y="116" width="4" height="22" rx="2" fill="${shade(c, -0.3)}"/>`}`,
    cabinet: ({ c, d }) => `${S.wall()}<rect x="40" y="40" width="120" height="110" rx="3" fill="${c}" stroke="${d}"/><rect x="48" y="48" width="104" height="94" rx="2" fill="#cfd8dc"/><path d="M60 60 L90 130" stroke="#fff" stroke-width="6" opacity=".5"/>`,
    slab: ({ c, d }) => `${S.shadow(84)}<path d="M20 100 L150 80 L186 100 L56 122 Z" fill="${c}" stroke="${d}"/><path d="M56 122 L186 100 L186 108 L56 130 Z" fill="${shade(c, -0.1)}" stroke="${d}"/><path d="M20 100 L56 122 L56 130 L20 108 Z" fill="${shade(c, -0.18)}"/>`,

    mirror: ({ c }, o = {}) => {
      const frame = o.noFrame ? "#c9d1d4" : c;
      const glass = `fill="#d4dde0"`;
      const glow = o.led ? `filter="url(#g)"` : "";
      const defs = o.led ? `<defs><filter id="g" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="6"/></filter></defs>` : "";
      let shape;
      if (o.round) shape = (r, attrs) => `<circle cx="100" cy="96" r="${r}" ${attrs}/>`;
      else if (o.capsule) shape = (r, attrs) => `<rect x="${100 - r * 0.62}" y="${96 - r}" width="${r * 1.24}" height="${r * 2}" rx="${r * 0.62}" ${attrs}/>`;
      else if (o.organic) shape = (r, attrs) => `<path transform="translate(100 96) scale(${r / 70})" d="M-50 -60 Q10 -80 50 -50 Q80 -10 55 40 Q30 75 -20 66 Q-70 50 -66 0 Q-66 -40 -50 -60 Z" ${attrs}/>`;
      else shape = (r, attrs) => `<rect x="${100 - r * 0.78}" y="${96 - r}" width="${r * 1.56}" height="${r * 2}" rx="3" ${attrs}/>`;
      return `${defs}${S.wall()}${o.led ? shape(72, `fill="#fff7d6" ${glow}`) : ""}${shape(70, `fill="${frame}"`)}${shape(64, glass)}<path d="M70 60 L110 140" stroke="#fff" stroke-width="8" opacity=".35"/>`;
    },

    towelBar: ({ m, d }, o = {}) => `${S.wall()}${o.ring
      ? `<rect x="92" y="40" width="16" height="16" rx="3" fill="${m}"/><circle cx="100" cy="90" r="34" fill="none" stroke="${m}" stroke-width="7"/><path d="M78 70 L78 150 L122 150 L122 70 Q100 60 78 70 Z" fill="#9fb7c9" opacity=".85"/>`
      : `${o.shelf ? `<rect x="24" y="48" width="152" height="10" rx="3" fill="${m}" stroke="${d}"/>` : ""}<rect x="26" y="70" width="12" height="18" rx="3" fill="${m}"/><rect x="162" y="70" width="12" height="18" rx="3" fill="${m}"/><rect x="30" y="76" width="140" height="7" rx="3" fill="${m}" stroke="${d}"/>
        <path d="M60 80 L60 150 L140 150 L140 80 Z" fill="#9fb7c9" opacity=".85"/>`}`,
    paperHolder: ({ m, d }) => `${S.wall()}<rect x="40" y="70" width="14" height="30" rx="4" fill="${m}"/><path d="M47 85 L140 85" stroke="${m}" stroke-width="7"/><circle cx="110" cy="110" r="32" fill="#fafafa" stroke="#d0ccc4"/><circle cx="110" cy="110" r="10" fill="#d9c7a7"/><rect x="84" y="110" width="52" height="56" fill="#fafafa" stroke="#d0ccc4"/>`,
    hook: ({ m, d }) => `${S.wall()}<rect x="88" y="60" width="24" height="24" rx="6" fill="${m}" stroke="${d}"/><path d="M100 84 L100 120 Q100 136 120 132" stroke="${m}" stroke-width="8" fill="none" stroke-linecap="round"/><path d="M100 96 Q84 100 80 90" stroke="${m}" stroke-width="7" fill="none" stroke-linecap="round"/>`,
    soapDish: ({ m, d }) => `${S.wall()}<rect x="90" y="70" width="20" height="30" rx="4" fill="${m}"/><path d="M50 100 L150 100 L140 118 L60 118 Z" fill="${m}" stroke="${d}"/><ellipse cx="100" cy="96" rx="28" ry="8" fill="#e9d9b8"/>`,
    dispenser: ({ m, d }) => `${S.wall()}<rect x="70" y="56" width="60" height="100" rx="10" fill="#dfe9ec" stroke="${d}" opacity=".9"/><rect x="70" y="40" width="60" height="22" rx="6" fill="${m}" stroke="${d}"/><rect x="96" y="156" width="8" height="10" fill="${m}"/>`,
    shelf: ({ m, d }, o = {}) => `${S.wall()}${o.corner ? `<path d="M30 80 L100 60 L170 80 L100 100 Z" fill="${m}" stroke="${d}"/><path d="M30 130 L100 110 L170 130 L100 150 Z" fill="${m}" stroke="${d}"/>`
      : `<rect x="20" y="90" width="160" height="10" rx="2" fill="#cfe3e6" stroke="#9fb7bb"/><rect x="34" y="78" width="10" height="26" rx="3" fill="${m}"/><rect x="156" y="78" width="10" height="26" rx="3" fill="${m}"/>`}`,
    grabBar: ({ m, d }) => `${S.wall()}<rect x="24" y="80" width="18" height="30" rx="6" fill="${m}"/><rect x="158" y="80" width="18" height="30" rx="6" fill="${m}"/><rect x="30" y="88" width="140" height="14" rx="7" fill="${m}" stroke="${d}"/>`,
    accessorySet: (p) => `${S.wall()}<g transform="translate(-40 -30) scale(.6)">${D.towelBar(p).replace(S.wall(), "")}</g><g transform="translate(80 -10) scale(.55)">${D.towelBar(p, { ring: true }).replace(S.wall(), "")}</g><g transform="translate(20 70) scale(.55)">${D.paperHolder(p).replace(S.wall(), "")}</g><g transform="translate(110 80) scale(.5)">${D.hook(p).replace(S.wall(), "")}</g>`,
    bin: ({ m, d }) => `${S.shadow(40)}<path d="M66 60 L134 60 L128 166 L72 166 Z" fill="${m}" stroke="${d}"/><ellipse cx="100" cy="60" rx="36" ry="9" fill="${shade(m, 0.08)}" stroke="${d}"/><rect x="88" y="162" width="24" height="8" rx="3" fill="${shade(m, -0.2)}"/>`,
    fan: ({ c, d }) => `${S.wall()}<rect x="50" y="50" width="100" height="100" rx="10" fill="${c}" stroke="${d}"/>${[70, 85, 100, 115, 130].map((y) => `<rect x="64" y="${y - 3}" width="72" height="5" rx="2" fill="${shade(c, -0.15)}"/>`).join("")}`,
    lamp: ({ m, d }) => `<defs><filter id="g"><feGaussianBlur stdDeviation="8"/></filter></defs>${S.wall()}<rect x="30" y="80" width="140" height="22" rx="11" fill="#fff6cc" filter="url(#g)"/><rect x="34" y="84" width="132" height="14" rx="7" fill="${m}" stroke="${d}"/><rect x="40" y="92" width="120" height="5" rx="2" fill="#fffbe8"/>`,

    hose: ({ m }, o = {}) => `${S.shadow(60)}<path d="M40 150 Q30 60 100 70 Q170 80 160 40" stroke="#b9bcbf" stroke-width="12" fill="none" stroke-linecap="round"/>
      <path d="M40 150 Q30 60 100 70 Q170 80 160 40" stroke="#8a8d90" stroke-width="12" fill="none" stroke-dasharray="2 3"/>
      <rect x="28" y="140" width="24" height="26" rx="3" fill="#c9a35c"/><rect x="148" y="22" width="24" height="24" rx="3" fill="${o.wide ? "#c9a35c" : "#d0d3d6"}"/>`,
    angleValve: ({ m, d }) => `${S.wall()}<rect x="20" y="88" width="50" height="20" fill="${shade(m, -0.1)}"/><rect x="66" y="78" width="44" height="40" rx="8" fill="${m}" stroke="${d}"/><rect x="80" y="118" width="16" height="44" fill="${m}"/><circle cx="88" cy="62" r="16" fill="${m}" stroke="${d}"/><rect x="84" y="62" width="8" height="18" fill="${m}"/>`,
    ballValve: ({ c, d }) => `${S.shadow(60)}<rect x="20" y="90" width="160" height="24" rx="4" fill="${c}" stroke="${d}"/><rect x="70" y="78" width="60" height="48" rx="10" fill="${c}" stroke="${d}"/><rect x="96" y="56" width="8" height="24" fill="#555"/><rect x="60" y="48" width="80" height="12" rx="6" fill="#d33" />`,
    siphon: ({ c, d }, o = {}) => o.bottle
      ? `${S.wall()}<rect x="90" y="20" width="16" height="60" fill="${c}"/><rect x="74" y="78" width="48" height="80" rx="14" fill="${c}" stroke="${d}"/><path d="M118 110 L190 110" stroke="${c}" stroke-width="14"/>`
      : `${S.wall()}<path d="M98 20 L98 110 Q98 150 130 150 Q160 150 160 120 L160 100 L196 100" stroke="${c}" stroke-width="16" fill="none" stroke-linejoin="round"/><path d="M98 60 L98 110 Q98 150 130 150 Q160 150 160 120" stroke="${shade(c, -0.15)}" stroke-width="16" fill="none" stroke-dasharray="3 5"/>`,
    drain: ({ m, d }) => `${S.shadow(50)}<ellipse cx="100" cy="70" rx="44" ry="14" fill="${m}" stroke="${d}"/><rect x="88" y="74" width="24" height="80" fill="${shade(m, -0.1)}"/><rect x="80" y="130" width="40" height="12" rx="3" fill="${shade(m, -0.15)}"/>`,
    grate: ({ m, d }, o = {}) => o.linear
      ? `<rect width="200" height="200" fill="#d9d4ca"/><rect x="10" y="84" width="180" height="32" rx="2" fill="${m}" stroke="${d}"/>${Array.from({ length: 16 }, (_, i) => `<rect x="${18 + i * 10.5}" y="90" width="5" height="20" rx="2" fill="${shade(m, -0.35)}"/>`).join("")}`
      : `<rect width="200" height="200" fill="#d9d4ca"/><rect x="50" y="50" width="100" height="100" rx="4" fill="${m}" stroke="${d}"/>${Array.from({ length: 6 }, (_, i) => `<rect x="62" y="${62 + i * 14}" width="76" height="6" rx="3" fill="${shade(m, -0.35)}"/>`).join("")}`,
    bolts: ({ c }) => `${S.shadow(60)}${[50, 100, 150].map((x, i) => `<rect x="${x - 4}" y="${60 + i * 6}" width="8" height="80" fill="#a8acaf"/><rect x="${x - 12}" y="${54 + i * 6}" width="24" height="10" rx="2" fill="#8d9194"/><ellipse cx="${x}" cy="${150 + i * 4}" rx="14" ry="6" fill="${c}"/>`).join("")}`,
    ring: () => `${S.shadow(60)}<ellipse cx="100" cy="110" rx="64" ry="30" fill="#d9b85c"/><ellipse cx="100" cy="104" rx="64" ry="30" fill="#e8c96e"/><ellipse cx="100" cy="104" rx="30" ry="13" fill="${BG}"/>`,
    fillValve: () => `${S.shadow(40)}<rect x="90" y="40" width="20" height="120" rx="4" fill="#5f6f7f"/><rect x="70" y="30" width="60" height="26" rx="6" fill="#4b5966"/><rect x="104" y="80" width="50" height="20" rx="10" fill="#8aa0b2"/><rect x="80" y="156" width="40" height="12" rx="3" fill="#4b5966"/>`,
    flushValve2: () => `${S.shadow(40)}<rect x="74" y="30" width="52" height="130" rx="10" fill="#e8e8e6" stroke="#b9b4ab"/><rect x="82" y="22" width="36" height="12" rx="4" fill="#4b5966"/><ellipse cx="100" cy="160" rx="40" ry="10" fill="#4b5966"/>`,
    pipe: ({ c, d }, o = {}) => `${S.shadow(84)}<rect x="10" y="${o.thin ? 92 : 84}" width="180" height="${o.thin ? 16 : 32}" rx="3" fill="${c}" stroke="${d}"/><ellipse cx="190" cy="100" rx="5" ry="${o.thin ? 8 : 16}" fill="${shade(c, -0.2)}"/>${o.label ? `<text x="100" y="105" font-size="11" text-anchor="middle" fill="${shade(c, -0.5)}" font-family="sans-serif">${o.label}</text>` : ""}`,
    tape: () => `${S.shadow(40)}<circle cx="100" cy="100" r="50" fill="#f6f6f6" stroke="#cfcac0"/><circle cx="100" cy="100" r="22" fill="#e5e0d6" stroke="#cfcac0"/><path d="M150 100 L190 140" stroke="#f6f6f6" stroke-width="14"/>`,
    caulk: ({ c, d }) => `${S.shadow(80)}<rect x="30" y="80" width="120" height="40" rx="6" fill="${c}" stroke="${d}"/><path d="M150 88 L190 98 L190 102 L150 112 Z" fill="#ececea" stroke="${d}"/><rect x="18" y="84" width="14" height="32" rx="3" fill="#bbb"/><rect x="50" y="90" width="70" height="20" rx="3" fill="#fff" opacity=".7"/>`,

    bag: ({ c }, o = {}) => `${S.shadow(64)}<path d="M44 40 L156 40 L164 160 Q100 172 36 160 Z" fill="${o.small ? "#f2efe8" : "#e9e2d2"}" stroke="#b9ad94"/>
      <rect x="54" y="70" width="92" height="50" rx="4" fill="${c}"/><rect x="54" y="128" width="92" height="8" rx="2" fill="#b9ad94"/>`,
    bucket: ({ c, d }) => `${S.shadow(56)}<path d="M50 50 L150 50 L140 166 L60 166 Z" fill="#f4f4f2" stroke="#b9b4ab"/><rect x="46" y="44" width="108" height="14" rx="4" fill="#ddd" stroke="#b9b4ab"/><rect x="60" y="86" width="80" height="44" rx="4" fill="${c}" stroke="${d}"/>`,
    gallon: ({ c }) => `${S.shadow(50)}<path d="M56 60 L144 60 L144 168 L56 168 Z" fill="#f4f4f2" stroke="#b9b4ab"/><rect x="68" y="40" width="40" height="22" rx="4" fill="#dedad1"/><path d="M110 46 Q140 40 140 60" stroke="#b9b4ab" stroke-width="8" fill="none"/><rect x="66" y="96" width="68" height="50" rx="3" fill="${c === "#ffffff" ? "#4d7ea8" : "#4d7ea8"}"/>`,
    profile: ({ c, d }) => `${S.shadow(84)}<path d="M10 120 L190 70 L190 82 L22 128 Z" fill="${c}" stroke="${d}"/><path d="M22 128 L190 82 L190 96 L22 142 Z" fill="${shade(c, -0.15)}" stroke="${d}"/>`,
    spacers: () => `<rect width="200" height="200" fill="${BG}"/>${[[60, 60], [130, 70], [80, 130], [145, 140], [105, 100]].map(([x, y]) => `<g transform="translate(${x} ${y}) rotate(${x % 30})"><rect x="-4" y="-18" width="8" height="36" rx="2" fill="#e0533d"/><rect x="-18" y="-4" width="36" height="8" rx="2" fill="#e0533d"/></g>`).join("")}`,
  };

  // Cerámica: muestra de piezas a escala con su junta y el dibujo según el tipo
  function tile(p, pal) {
    const name = (p.name + " " + p.subcategory).toLowerCase();
    const c = pal.c, dk = shade(c, lum(c) > 0.5 ? -0.12 : 0.12), joint = lum(c) > 0.5 ? "#c9c3b8" : "#3a3a3a";
    const tw = p.tile_width_cm || 60, th = p.tile_height_cm || 60;
    let body = "";
    if (name.includes("hexagonal")) {
      const r = 16, hh = r * Math.sqrt(3);
      for (let y = -hh; y < 220; y += hh) for (let x = -r, i = 0; x < 230; x += r * 1.5, i++) {
        const cy = y + (i % 2 ? hh / 2 : 0);
        const pts = Array.from({ length: 6 }, (_, k) => `${x + r * Math.cos((k * Math.PI) / 3)},${cy + r * Math.sin((k * Math.PI) / 3)}`).join(" ");
        body += `<polygon points="${pts}" fill="${(i * 7 + Math.round(y)) % 5 === 0 ? dk : c}" stroke="${joint}" stroke-width="2"/>`;
      }
      return body;
    }
    if (name.includes("subway")) {
      for (let y = 0, r = 0; y < 200; y += 20, r++) for (let x = r % 2 ? -20 : 0; x < 200; x += 40)
        body += `<rect x="${x + 1}" y="${y + 1}" width="38" height="18" rx="2" fill="${c}" stroke="${dk}"/>`;
      return `<rect width="200" height="200" fill="${joint}"/>${body}`;
    }
    if (name.includes("mosaico") || name.includes("vidrio 30")) {
      for (let y = 0; y < 200; y += 20) for (let x = 0; x < 200; x += 20) {
        const k = ((x * 13 + y * 7) % 5) - 2;
        body += `<rect x="${x + 1.5}" y="${y + 1.5}" width="17" height="17" rx="2" fill="${shade(c, k * 0.05)}"/>`;
      }
      return `<rect width="200" height="200" fill="${joint}"/>${body}`;
    }
    if (name.includes("listelo") || name.includes("cenefa")) {
      return `<rect width="200" height="200" fill="#ebe8e1"/><rect x="0" y="76" width="200" height="48" fill="${c}"/>${Array.from({ length: 10 }, (_, i) => `<rect x="${i * 20 + 3}" y="82" width="14" height="36" rx="2" fill="${shade(c, i % 2 ? 0.08 : -0.08)}"/>`).join("")}`;
    }
    if (name.includes("hidráulica")) {
      for (let y = 0; y < 200; y += 50) for (let x = 0; x < 200; x += 50)
        body += `<rect x="${x}" y="${y}" width="50" height="50" fill="#efebe2" stroke="${joint}"/><circle cx="${x + 25}" cy="${y + 25}" r="15" fill="${c}"/><path d="M${x} ${y} L${x + 12} ${y} L${x} ${y + 12} Z M${x + 50} ${y + 50} L${x + 38} ${y + 50} L${x + 50} ${y + 38} Z M${x + 50} ${y} L${x + 50} ${y + 12} L${x + 38} ${y} Z M${x} ${y + 50} L${x} ${y + 38} L${x + 12} ${y + 50} Z" fill="${c}"/><circle cx="${x + 25}" cy="${y + 25}" r="6" fill="#efebe2"/>`;
      return body;
    }
    // piezas rectangulares a escala: la pieza más grande ocupa ~120 px
    const k = 120 / Math.max(tw, th);
    const w = Math.max(14, tw * k), h = Math.max(14, th * k);
    const wood = name.includes("madera");
    for (let y = -h / 2, r = 0; y < 200; y += h, r++) for (let x = wood && r % 2 ? -w / 2 : 0; x < 200; x += w) {
      body += `<rect x="${x + 1}" y="${y + 1}" width="${w - 2}" height="${h - 2}" fill="${c}"/>`;
      if (wood) for (let g = 1; g < 4; g++) body += `<path d="M${x + (w * g) / 4} ${y + 2} q 3 ${h / 2} 0 ${h - 4}" stroke="${dk}" fill="none" opacity=".5"/>`;
    }
    if (name.includes("mármol") || name.includes("marmol")) body += `<path d="M-10 40 Q60 70 90 40 T210 70 M-10 150 Q50 120 110 160 T210 130 M40 -10 Q70 90 30 210" stroke="${shade(c, lum(c) > 0.5 ? -0.3 : 0.35)}" stroke-width="1.6" fill="none" opacity=".55"/>`;
    if (name.includes("cemento") || name.includes("piedra")) body += Array.from({ length: 70 }, (_, i) => `<circle cx="${(i * 53) % 200}" cy="${(i * 97) % 200}" r="${1 + (i % 3) * 0.6}" fill="${dk}" opacity=".35"/>`).join("");
    if (name.includes("antideslizante")) body += Array.from({ length: 100 }, (_, i) => `<circle cx="${(i % 10) * 20 + 10}" cy="${Math.floor(i / 10) * 20 + 10}" r="1.4" fill="${dk}"/>`).join("");
    return `<rect width="200" height="200" fill="${joint}"/>${body}`;
  }

  // Qué dibujo corresponde a cada producto (por categoría, subcategoría y nombre)
  function pick(p, pal) {
    const n = (p.subcategory + " " + p.name).toLowerCase();
    const has = (...w) => w.some((x) => n.includes(x));
    switch (p.category) {
      case "ceramica": return tile(p, pal);
      case "sanitarios":
        if (has("orinal")) return D.urinal(pal);
        if (has("asiento")) return D.seat(pal, { bidet: has("bidé") }); // antes que "bidé": el asiento bidé es un asiento
        if (has("bidé")) return D.bidet(pal);
        if (has("tanque")) return D.flushPlate(pal);
        return D.toilet(pal, { one: has("one piece", "smart", "inteligente"), wall: has("suspendido"), tank: !has("suspendido") });
      case "lavamanos":
        if (has("esquinero")) return D.cornerBasin(pal);
        return D.basin(pal, { pedestal: has("de pedestal"), semi: has("semipedestal"), vessel: has("sobreponer redondo", "sobreponer rectangular") || (has("de sobreponer")),
          rect: has("rectangular"), counter: has("sobreponer", "empotrar", "integrado"), wall: has("suspendido", "semipedestal") });
      case "griferia":
        if (has("fluxómetro")) return D.flushValve(pal);
        if (has("dos manijas")) return D.twoValves(pal);
        if (has("termostático")) return D.showerMixer(pal, { thermo: true });
        if (has("ducha", "tina")) return D.showerMixer(pal, { diverter: has("desviador", "tina") });
        if (has("de pared")) return D.wallFaucet(pal);
        return D.faucet(pal, { tall: has("alta"), two: has("4\"", "8\""), push: has("push"), sensor: has("sensor") });
      case "duchas":
        if (has("higiénica")) return D.bidetSpray(pal, { mixer: has("mezclador", "empotrada", "termostática"), tee: has(" en t ") });
        if (has("eléctrica")) return D.electricShower(pal);
        if (has("nicho")) return D.niche(pal);
        if (has("columna")) return D.column(pal);
        if (has("barra")) return D.handShower(pal, { bar: true });
        if (has("teléfono")) return D.handShower(pal);
        if (has("brazo")) return D.showerArm(pal, { ceiling: has("techo") });
        return D.showerHead(pal, { square: has("cuadrada", "40×40"), ceiling: has("techo"), flush: has("empotrada") });
      case "divisiones":
        return D.glass(pal, { corner: has("esquinera"), curtain: has("cortina"), profile: has("perfilería"), slide: has("corrediza"), fixed: has("panel fijo") });
      case "tinas": return D.tub(pal, { tray: has("plato"), free: has("exenta"), jets: has("hidromasaje") });
      case "muebles":
        if (has("botiquín")) return D.cabinet(pal);
        if (has("mesón")) return D.slab(pal);
        if (has("torre")) return D.tower(pal);
        if (has("sobre sanitario")) return D.tower(pal, { open: true });
        return D.vanity(pal, { floor: has("de piso"), doors: has("doble", "esquinero") });
      case "espejos":
        return D.mirror(pal, { round: has("redondo"), capsule: has("cápsula", "ovalado"), organic: has("orgánico"), led: has("led"), noFrame: pal.vname.includes("sin marco") });
      case "accesorios":
        if (has("aro")) return D.towelBar(pal, { ring: true });
        if (has("toallero doble")) return D.towelBar(pal, { shelf: true });
        if (has("toallero")) return D.towelBar(pal);
        if (has("portarrollo")) return D.paperHolder(pal);
        if (has("gancho")) return D.hook(pal);
        if (has("jabonera")) return D.soapDish(pal);
        if (has("dispensador")) return D.dispenser(pal);
        if (has("esquinera")) return D.shelf(pal, { corner: true });
        if (has("repisa")) return D.shelf(pal);
        if (has("barra de apoyo")) return D.grabBar(pal);
        if (has("juego")) return D.accessorySet(pal);
        if (has("papelera")) return D.bin(pal);
        if (has("extractor")) return D.fan(pal);
        if (has("aplique")) return D.lamp(pal);
        return D.towelBar(pal);
      case "instalacion":
        if (has("flexible")) return D.hose(pal, { wide: has("sanitario") });
        if (has("angular")) return D.angleValve(pal);
        if (has("válvula de bola")) return D.ballValve(pal);
        if (has("botella")) return D.siphon(pal, { bottle: true });
        if (has("sifón")) return D.siphon(pal);
        if (has("desagüe")) return D.drain(pal);
        if (has("rejilla")) return D.grate(pal, { linear: has("lineal") });
        if (has("anclaje")) return D.bolts(pal);
        if (has("sello")) return D.ring(pal);
        if (has("entrada")) return D.fillValve(pal);
        if (has("descarga")) return D.flushValve2(pal);
        if (has("acople")) return D.pipe({ ...pal, c: "#e8e6e1", d: "#b9b4ab" });
        if (has("cpvc")) return D.pipe({ ...pal, c: "#e8dcc0", d: "#b8a67c" }, { thin: true, label: "CPVC" });
        if (has("presión")) return D.pipe({ ...pal, c: "#f2f2f0", d: "#b9b4ab" }, { thin: true, label: "PVC" });
        if (has("tubo")) return D.pipe({ ...pal, c: "#e0e0dc", d: "#a9a49b" }, { label: "PVC 2\"" });
        if (has("teflón")) return D.tape(pal);
        if (has("silicona")) return D.caulk(pal);
        return D.pipe(pal);
      case "pegantes":
        if (has("crucetas")) return D.spacers(pal);
        if (has("perfil")) return D.profile(pal);
        if (has("impermeabilizante")) return D.gallon(pal);
        if (has("epóxica")) return D.bucket(pal);
        return D.bag(pal, { small: has("boquilla") });
    }
    return `<rect x="50" y="50" width="100" height="100" rx="10" fill="${pal.c}"/>`;
  }

  const cache = new Map();
  function illustrate(p, v) {
    const key = `${p.id}|${v?.id ?? ""}`;
    if (cache.has(key)) return cache.get(key);
    const c = hex(v?.color_hex, "#e9e6e0");
    const metallic = ["griferia", "duchas", "accesorios"].includes(p.category) || (p.category === "instalacion" && /llave|desagüe|rejilla|botella/i.test(p.name));
    const pal = { c, d: shade(c, lum(c) > 0.5 ? -0.25 : 0.25), l: shade(c, 0.06), m: c, vname: (v?.name || "").toLowerCase() };
    if (metallic) pal.d = shade(c, lum(c) > 0.5 ? -0.3 : 0.3);
    const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200"><rect width="200" height="200" fill="${BG}"/>${pick(p, pal)}</svg>`;
    const uri = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg);
    cache.set(key, uri);
    return uri;
  }

  window.Lambert = Object.assign(window.Lambert || {}, { illustrate });
})();
