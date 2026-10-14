import { test, expect } from "@playwright/test";
import { sinErrores, sinDesbordeHorizontal } from "./ayuda.mjs";

test("el catálogo carga los productos de la tienda", async ({ page }) => {
  const ok = sinErrores(page);
  await page.goto("/catalogo.html");
  await expect(page.locator(".card").first()).toBeVisible();
  expect(await page.locator(".card").count()).toBeGreaterThan(50);
  ok();
});

test("una cerámica de piso y pared deja elegir dónde usarla", async ({ page }) => {
  await page.goto("/catalogo.html");
  await page.locator(".card", { hasText: "Porcelanato tipo mármol" }).first().click();
  const botones = page.locator("#useInDesign a");
  await expect(botones).toHaveText(["Usar en el piso", "Usar en las paredes"]);
  await expect(botones.nth(1)).toHaveAttribute("href", /en=wall/);
});

test("catálogo en el celular sin desborde", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto("/catalogo.html");
  await expect(page.locator(".card").first()).toBeVisible();
  await sinDesbordeHorizontal(page);
});
