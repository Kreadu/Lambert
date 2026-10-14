import { expect } from "@playwright/test";

/** Falla la prueba si la página tiene errores de JavaScript. */
export function sinErrores(page) {
  const errores = [];
  page.on("pageerror", (e) => errores.push(e.message));
  return () => expect(errores, "errores de JavaScript en la página").toEqual([]);
}

/** Nada se sale por los lados (sin barra de desplazamiento horizontal). */
export async function sinDesbordeHorizontal(page) {
  const [scroll, ancho] = await page.evaluate(() => [document.documentElement.scrollWidth, window.innerWidth]);
  expect(scroll, "la página es más ancha que la pantalla").toBeLessThanOrEqual(ancho + 1);
}

/** Espera a que el diseñador termine de cargar el catálogo. */
export async function disenadorListo(page) {
  await page.waitForFunction(() => !document.getElementById("loading"), null, { timeout: 150_000, polling: 1000 });
}
