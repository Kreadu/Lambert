// Lector de códigos de barras con la cámara del celular (como en Miel, S29-01 / ADR-046):
// el BarcodeDetector del navegador (Chrome/Android) y, donde no existe (Safari en iPhone), el ponyfill
// `barcode-detector` (zxing-wasm), cargado solo al abrir la cámara. El campo de abajo sirve para
// escribir el código a mano o para un lector físico (USB/Bluetooth), que "escribe" el código + Enter.
//
// Escaner.open({ title, onCode(code), onClose(), below }) → { close(), panel }  (panel: el elemento bajo la cámara)
(function () {
  const FORMATS = ["ean_13", "ean_8", "upc_a", "upc_e", "code_128"];
  const PONYFILL = "https://cdn.jsdelivr.net/npm/barcode-detector@3.2.2/dist/es/ponyfill.min.js";

  async function createDetector() {
    const Native = globalThis.BarcodeDetector;
    try {
      if (Native && (await Native.getSupportedFormats()).includes("ean_13")) return new Native({ formats: FORMATS });
    } catch { /* sin lector nativo */ }
    const { BarcodeDetector } = await import(PONYFILL);
    return new BarcodeDetector({ formats: FORMATS });
  }

  // la cámara lee el mismo código en cada cuadro: solo se acepta de nuevo si dejó de verse 1,5 s
  function dedupe(windowMs) {
    let last = "", seen = -Infinity;
    return (code, now) => { const fresh = code !== last || now - seen >= windowMs; last = code; seen = now; return fresh; };
  }

  function open({ title = "Escanear", onCode, onClose, below = "" }) {
    const wrap = document.createElement("div");
    wrap.className = "scan-overlay";
    wrap.innerHTML = `<div class="scan-box" role="dialog" aria-modal="true" aria-label="${title}">
      <div class="scan-head"><b>${title}</b><button type="button" class="btn" data-close>Cerrar</button></div>
      <div class="scan-cam"><video muted playsinline></video><p class="scan-hint">Abriendo la cámara…</p></div>
      <form class="scan-manual"><input class="input" name="code" autocomplete="off" maxlength="64" placeholder="O escribe el código / usa el lector" aria-label="Código de barras">
        <button class="btn" type="submit">Agregar</button></form>
      <div class="scan-panel">${below}</div></div>`;
    document.body.appendChild(wrap);
    const video = wrap.querySelector("video"), hint = wrap.querySelector(".scan-hint");
    let stopped = false, stream = null, timer = null;
    const accept = dedupe(1500);
    const emit = (code) => { if (code) onCode(String(code).trim()); };

    (async () => {
      try {
        stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" }, audio: false });
        if (stopped) return stream.getTracks().forEach((t) => t.stop());
        video.srcObject = stream;
        await video.play();
        const detector = await createDetector();
        if (stopped) return;
        hint.textContent = "Apunta al código de barras";
        let busy = false;
        timer = setInterval(async () => {
          if (busy || video.readyState < 2) return;
          busy = true;
          try {
            for (const { rawValue } of await detector.detect(video)) {
              if (!accept(rawValue, performance.now())) continue;
              navigator.vibrate?.(60);
              emit(rawValue);
            }
          } catch { /* un cuadro que no se pudo leer: se intenta con el siguiente */ } finally { busy = false; }
        }, 200);
      } catch {
        if (stopped) return;
        wrap.querySelector(".scan-cam").innerHTML = `<p class="scan-blocked">Activa la cámara para escanear, o escribe el código abajo.</p>`;
      }
    })();

    function close() {
      stopped = true;
      clearInterval(timer);
      stream?.getTracks().forEach((t) => t.stop());
      wrap.remove();
      onClose?.();
    }
    wrap.querySelector("[data-close]").onclick = close;
    wrap.addEventListener("click", (e) => { if (e.target === wrap) close(); });
    wrap.querySelector(".scan-manual").onsubmit = (e) => {
      e.preventDefault();
      const input = e.currentTarget.code;
      emit(input.value);
      input.value = "";
    };
    return { close, panel: wrap.querySelector(".scan-panel") };
  }

  window.Escaner = { open };
})();
