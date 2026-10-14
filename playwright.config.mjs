// Pruebas de Lambert en un navegador real (Chromium). Leen el catálogo de Supabase pero NO escriben:
// no guardan diseños, no inician sesión ni cambian stock. `npm test`
import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "tests",
  timeout: 180_000,               // el 3D sin tarjeta de video (headless) es lento
  expect: { timeout: 30_000 },
  workers: 2,
  reporter: [["list"]],
  use: {
    baseURL: "http://127.0.0.1:8091",
    launchOptions: { args: ["--use-gl=swiftshader", "--enable-webgl", "--ignore-gpu-blocklist"] },
  },
  webServer: {
    command: "python3 -m http.server 8091 --bind 127.0.0.1",
    url: "http://127.0.0.1:8091/index.html",
    reuseExistingServer: true,
    stdout: "ignore",
    stderr: "ignore",
  },
});
