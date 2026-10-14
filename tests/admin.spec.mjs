import { test, expect } from "@playwright/test";
import { sinErrores, sinDesbordeHorizontal } from "./ayuda.mjs";

test("ingreso: el ojo muestra y oculta la contraseña", async ({ page }) => {
  const ok = sinErrores(page);
  await page.goto("/admin.html");
  const pass = page.locator("#password");
  await expect(pass).toHaveAttribute("type", "password");
  await page.locator("#login [data-eye]").click();
  await expect(pass).toHaveAttribute("type", "text");
  await page.locator("#login [data-eye]").click();
  await expect(pass).toHaveAttribute("type", "password");
  ok();
});

test("¿Olvidaste tu contraseña? pide el correo primero", async ({ page }) => {
  await page.goto("/admin.html");
  await page.locator("#forgot").click();
  await expect(page.locator("#loginStatus")).toContainText("Escribe tu correo");
});

// Mi empresa sin iniciar sesión: se carga la tienda pública solo para revisar cómo se ve el formulario
async function abrirMiEmpresa(page) {
  await page.goto("/admin.html");
  await page.waitForSelector("#login:not([hidden])");
  await page.evaluate(async () => {
    const { data } = await db.from("stores").select("*").eq("slug", "lambert").single();
    useStore(data); fillCompany(); tab = "empresa"; show("listPanel");
  });
}

test("Mi empresa: los campos quedan alineados en dos columnas", async ({ page }) => {
  await page.setViewportSize({ width: 1280, height: 900 });
  await abrirMiEmpresa(page);
  const top = (sel) => page.locator(sel).evaluate((el) => Math.round(el.getBoundingClientRect().top));
  const left = (sel) => page.locator(sel).evaluate((el) => Math.round(el.getBoundingClientRect().left));
  // cada par a la misma altura
  for (const [a, b] of [["#c-legal", "#c-tax"], ["#c-country", "#c-currency"], ["#c-city", "#c-address"], ["#c-wa", "#c-phone"], ["#c-email", "#c-web"]]) {
    expect(await top(a), `${a} y ${b} a la misma altura`).toBe(await top(b));
  }
  // y las columnas empiezan en el mismo lugar
  expect(await left("#c-legal")).toBe(await left("#c-city"));
  expect(await left("#c-tax")).toBe(await left("#c-address"));
  expect(await left("#c-tax")).toBe(await left("#c-web"));
});

test("Mi empresa en el celular sin desborde", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await abrirMiEmpresa(page);
  await sinDesbordeHorizontal(page);
});

test("escáner: sin cámara deja escribir el código a mano", async ({ page }) => {
  await page.goto("/admin.html");
  const codigos = await page.evaluate(() => new Promise((resolve) => {
    const leidos = [];
    const sc = Escaner.open({ title: "Prueba", onCode: (c) => { leidos.push(c); if (leidos.length === 1) { sc.close(); resolve(leidos); } } });
    const f = document.querySelector(".scan-manual");
    f.code.value = " 7702004003508 ";
    f.requestSubmit();
  }));
  expect(codigos).toEqual(["7702004003508"]);
  await expect(page.locator(".scan-overlay")).toHaveCount(0);
});
