// Pie de Kreadu, la empresa que desarrolla Lambert: igual en todas las páginas.
// Mismos datos que Miel (src/lib/platform/developer.ts). Enlace sin `url` = se muestra como texto.
(function () {
  const DEVELOPER = {
    brand: "KREADU",
    legal: "KREADU S.A.S. — NIT 901790185-0",
    company: [
      { label: "AI Business Systems Lab", url: null },
      { label: "Academy", url: null },
      { label: "KREADU School", url: null },
    ],
    contact: { cta: "Let's Talk", email: "is@kreadu.com", phones: ["(+57) 3235297951", "(+57) 3225832662"] },
    social: [],
  };
  const esc = (v) => String(v ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  const link = (href, text, cls = "") => `<a href="${esc(href)}"${/^https?:/.test(href) ? ' target="_blank" rel="noopener noreferrer"' : ""}${cls ? ` class="${cls}"` : ""}>${esc(text)}</a>`;
  const sep = '<span aria-hidden="true">·</span>';
  const { contact } = DEVELOPER;
  const parts = [
    `<b>${esc(DEVELOPER.brand)}</b>`,
    `<span>${esc(DEVELOPER.legal)}</span>`,
    ...DEVELOPER.company.map((l) => sep + (l.url ? link(l.url, l.label) : `<span>${esc(l.label)}</span>`)),
    sep,
    link(`mailto:${contact.email}`, contact.cta),
    link(`mailto:${contact.email}`, contact.email),
    ...contact.phones.map((p) => link(`https://wa.me/${p.replace(/\D/g, "")}`, p, "num")),
    ...DEVELOPER.social.map((l) => sep + link(l.url, l.label)),
  ];
  const footer = document.createElement("footer");
  footer.className = "kreadu";
  footer.innerHTML = `<p>${parts.join("")}</p>`;
  // una página puede reservar dónde va (ej. el panel del diseñador); si no, al final de la página
  const slot = document.querySelector("[data-kreadu]");
  if (slot) slot.replaceWith(footer);
  else document.body.appendChild(footer);
})();
