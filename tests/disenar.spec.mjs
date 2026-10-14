import { test, expect } from "@playwright/test";
import { sinErrores, disenadorListo, sinDesbordeHorizontal } from "./ayuda.mjs";

test("cotización: cerámica en cajas, pegante y boquilla, y accesorios de instalación aparte y editables", async ({ page }) => {
  test.setTimeout(480_000);       // cada cambio redibuja el 3D, lento sin tarjeta de video
  const ok = sinErrores(page);
  await page.setViewportSize({ width: 1000, height: 700 });
  await page.goto("/disenar.html?plantilla=estandar");
  await disenadorListo(page);
  await expect(page.locator("#templates .tpl .art svg")).toHaveCount(5); // los baños de muestra ilustrados (paso 1)

  // paso 2: porcelanato en el piso y cerámica de pared
  await page.locator('.step[data-step="2"]').click({ noWaitAfter: true, force: true, timeout: 120_000 });
  await page.locator('#surfTabs [data-surf="floor"]').click({ noWaitAfter: true, force: true, timeout: 120_000 });
  await page.locator("#tileGrid .tile-card", { hasText: "Porcelanato tipo mármol" }).first().click({ noWaitAfter: true, force: true, timeout: 120_000 });
  await page.locator('#surfTabs [data-surf="wall"]').click({ noWaitAfter: true, force: true, timeout: 120_000 });
  await page.selectOption("#tileTypes", "Cerámica de pared");
  await page.locator("#tileGrid .tile-card", { hasText: "30×60" }).first().click({ noWaitAfter: true, force: true, timeout: 120_000 });

  await page.locator('.step[data-step="4"]').click({ noWaitAfter: true, force: true, timeout: 120_000 });
  const resumen = page.locator("#summary");
  // 1,8 × 2,4 = 4,32 m² + 10 % = 4,75 m² → 4 cajas de 1,44 m²
  await expect(resumen).toContainText("4 cajas · Porcelanato tipo mármol");
  await expect(resumen).toContainText("bultos · Pegante para porcelanato");
  await expect(resumen).toContainText("Boquilla");
  await expect(resumen).toContainText("Presupuesto adjunto");
  await expect(resumen).toContainText("Total con instalación");

  // quitar pegante y boquilla
  await page.locator("#suppliesChk").uncheck();
  await expect(resumen).not.toContainText("Pegante para porcelanato");
  await page.locator("#suppliesChk").check();

  // accesorios: el cliente sube, baja, quita y agrega
  const box = page.locator(".install-box");
  const totalAcc = async () => (await box.locator(".total").first().innerText()).replace(/\D/g, "");
  const antes = await totalAcc();
  const primera = box.locator(".inst-row").first();
  const nombre = (await primera.locator(".inst-name").innerText()).split("\n")[0];
  await primera.locator('[aria-label="Uno más"]').click({ force: true });
  await expect(box.locator(".inst-row").first()).toContainText("(sugerido:");
  expect(await totalAcc()).not.toBe(antes);
  await box.locator(".inst-row").first().locator('[aria-label="Quitar"]').click({ force: true });
  await expect(box).not.toContainText(nombre);
  const opcion = await page.locator("#instPick option").nth(1).getAttribute("value");
  await page.selectOption("#instPick", opcion);
  await expect(box).toContainText("Agregado por ti");
  await box.screenshot({ path: "test-results/accesorios.png" });
  await box.locator("#instReset").click({ force: true });
  await expect(box).toContainText(nombre);
  await expect(box).not.toContainText("Agregado por ti");

  // cotización impresa (sin guardar el diseño): tabla, total y página adjunta
  await page.evaluate(() => window.dispatchEvent(new Event("beforeprint")));
  const doc = page.locator("#quote");
  await expect(doc.locator(".q-title")).toHaveText("Cotización");
  await expect(doc.locator(".q-total").first()).toContainText("Total");
  await expect(doc.locator(".q-annex")).toContainText("Accesorios de instalación");
  expect(await doc.locator(".q-views img").first().getAttribute("src")).toMatch(/^data:image\/jpeg/);
  ok();
});

test("la cerámica que llega del catálogo abre el paso 2 en esa superficie", async ({ page }) => {
  await page.setViewportSize({ width: 1000, height: 700 });
  await page.goto("/catalogo.html");
  await page.locator(".card", { hasText: "Porcelanato tipo mármol" }).first().click();
  await page.locator("#useInDesign a", { hasText: "paredes" }).click();
  await page.waitForFunction(() => !location.search.includes("add="), null, { timeout: 150_000, polling: 1000 });
  await expect(page.locator(".step.active")).toContainText("Piso y paredes");
  await expect(page.locator("#surfNow")).toContainText("Todas las paredes");
  await expect(page.locator("#surfAlso")).toContainText("Usar también en el piso");
});

test("diseñador en el celular sin desborde", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto("/disenar.html");
  await disenadorListo(page);
  await sinDesbordeHorizontal(page);
});
