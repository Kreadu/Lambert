import { test, expect } from "@playwright/test";
import { readFileSync, readdirSync } from "node:fs";
import { sinErrores, sinDesbordeHorizontal } from "./ayuda.mjs";

test("la página de inicio es de Lambert, con los 4 baños de muestra ilustrados", async ({ page }) => {
  const ok = sinErrores(page);
  await page.goto("/index.html");
  await expect(page.locator("h1")).toHaveText("Diseña tu baño");
  await expect(page.locator("#tpls .tile.sample svg")).toHaveCount(4);
  await expect(page.locator("#brand")).toContainText("Lambert");
  await expect(page.locator("footer.kreadu")).toContainText("KREADU");
  // fuera del kiosco: sin "pantalla completa" y los enlaces sin modo tienda
  await expect(page.locator("#fullBtn")).toBeHidden();
  await expect(page.locator("#tpls a").first()).toHaveAttribute("href", "disenar.html?plantilla=medio");
  ok();
});

test("tienda.html abre la pantalla del local (kiosco) y conserva la tienda", async ({ page }) => {
  await page.goto("/tienda.html?t=lambert");
  await expect(page).toHaveURL(/index\.html\?modo=tienda&t=lambert/);
  await expect(page.locator("#fullBtn")).toBeVisible();
  await expect(page.locator("#tpls a").first()).toHaveAttribute("href", /modo=tienda/);
});

test("en el celular nada se sale por los lados", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 });
  await page.goto("/index.html");
  await expect(page.locator("#tpls .tile")).toHaveCount(4);
  await sinDesbordeHorizontal(page);
});

test("no queda nada de la plantilla de ropa", () => {
  const archivos = readdirSync(".").filter((f) => /\.(html|js|md)$/.test(f));
  for (const f of archivos) {
    const txt = readFileSync(f, "utf8");
    expect(txt, f).not.toMatch(/Tienda de Ropa|vestido|blusa|pantal[oó]n wide|\btalla\b/i);
  }
});

test("las ilustraciones de muestra existen para todos los baños", async ({ page }) => {
  await page.goto("/index.html");
  const ids = await page.evaluate(() => ["medio", "pequeno", "estandar", "principal", "vacio"].map((id) => Muestras.draw(id).startsWith("<svg")));
  expect(ids).toEqual([true, true, true, true, true]);
});
