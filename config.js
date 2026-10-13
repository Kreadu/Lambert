// Configuración de Lambert.
// La clave "publishable" (o "anon") de Supabase es pública por diseño: la seguridad la da RLS.
// NUNCA pongas aquí la clave secreta (service_role / secret).
// Los datos de cada tienda (nombre, logo, país, moneda, WhatsApp) se editan en admin.html → "Mi empresa".
window.LAMBERT = {
  supabaseUrl: "https://kakkqkidixddqjzucrzv.supabase.co",
  supabaseKey: "sb_publishable_Ivaerfs7KocfRc3cRdUH5g_IXIXexPI",   // Supabase → Project Settings → API Keys → Publishable key
  store: "lambert",         // tienda que se muestra si la dirección no dice otra (?t=otra-tienda)
  storeName: "Lambert",     // nombre mientras carga
  bucket: "catalogo",
};
