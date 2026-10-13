// Configuración del catálogo de Lambert (pruebas).
// La clave "publishable" (o "anon") de Supabase es pública por diseño: la seguridad la da RLS.
// NUNCA pongas aquí la clave secreta (service_role / secret).
window.LAMBERT = {
  supabaseUrl: "https://kakkqkidixddqjzucrzv.supabase.co",          // ej: https://xxxxxxxx.supabase.co
  supabaseKey: "sb_publishable_Ivaerfs7KocfRc3cRdUH5g_IXIXexPI",          // Supabase → Project Settings → API Keys → Publishable key
  storeName: "Lambert",
  currency: "COP",          // moneda de los precios
  locale: "es-CO",
  bucket: "catalogo",
};
