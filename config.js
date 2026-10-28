// Configuración de Lambert.
// La clave "publishable" (o "anon") de Supabase es pública por diseño: la seguridad la da RLS.
// NUNCA pongas aquí la clave secreta (service_role / secret).
// Los datos de cada tienda (nombre, logo, país, moneda, WhatsApp) se editan en admin.html → "Mi empresa".
window.LAMBERT = {
  supabaseUrl: "https://lueyzfddddyjmqtjefhl.supabase.co",
  supabaseKey: "sb_publishable_bePoMNBXVXDUH6nP1G2Gvw_fz5S6EJH",   // Supabase → Project Settings → API Keys → Publishable key
  store: "lambert",         // tienda que se muestra si la dirección no dice otra (?t=otra-tienda)
  storeName: "Lambert",     // nombre mientras carga
  bucket: "catalogo",
  createStoreFunction: "crear-tienda",  // nombre de la Edge Function con el código de supabase/functions/crear-tienda
};

// Supabase local en Docker (`npx supabase start`, puertos 544xx para no chocar con Miel), para probar sin tocar
// la nube. Cambiar a true; solo aplica al abrir las páginas desde este computador. La clave es la de ejemplo de
// todo Supabase local.
const USAR_SUPABASE_LOCAL = false;
if (USAR_SUPABASE_LOCAL && ["127.0.0.1", "localhost"].includes(location.hostname)) {
  Object.assign(window.LAMBERT, {
    supabaseUrl: "http://127.0.0.1:54421",
    supabaseKey: "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH",
  });
}
