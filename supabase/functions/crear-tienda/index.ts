// Lambert · función "crear-tienda": crea una tienda nueva con el correo y la contraseña de su dueño.
// Solo la puede usar un administrador de la plataforma (tabla `admins`).
//
// Publicarla: Supabase → Edge Functions → Deploy a new function → Via Editor, nombre `crear-tienda`,
// pegar este archivo, desactivar "Verify JWT" (la función comprueba ella misma quién la llama) y Deploy.
// Usa la clave de servicio que Supabase le da a la función; esa clave nunca sale del servidor.
import { createClient } from "npm:@supabase/supabase-js@2.45.4";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...CORS, "Content-Type": "application/json" } });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // ¿Quién llama? Debe ser administrador de la plataforma.
  const token = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "");
  const { data: { user } } = await admin.auth.getUser(token);
  if (!user?.email) return json({ error: "unauthorized" }, 401);
  const { data: admins } = await admin.from("admins").select("email");
  if (!admins?.some((a) => a.email.toLowerCase() === user.email!.toLowerCase())) return json({ error: "forbidden" }, 403);

  let body: Record<string, string>;
  try { body = await req.json(); } catch { return json({ error: "invalid_body" }, 400); }
  const name = String(body.name ?? "").trim().slice(0, 80);
  const slug = String(body.slug ?? "").trim();
  const email = String(body.email ?? "").trim().toLowerCase();
  const password = String(body.password ?? "");
  const country = String(body.country ?? "CO").toUpperCase();
  const currency = String(body.currency ?? "COP").toUpperCase();
  const cc = String(body.cc ?? "57").replace(/\D/g, "");
  if (!name) return json({ error: "name_required" }, 400);
  if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(slug)) return json({ error: "invalid_slug" }, 400);
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return json({ error: "invalid_email" }, 400);
  if (password.length < 8) return json({ error: "weak_password" }, 400);
  if (!/^[A-Z]{2}$/.test(country) || !/^[A-Z]{3}$/.test(currency) || !/^\d{1,4}$/.test(cc)) return json({ error: "invalid_country" }, 400);

  const { data: taken } = await admin.from("stores").select("id").eq("slug", slug).maybeSingle();
  if (taken) return json({ error: "slug_taken" }, 409);

  const { data: created, error: userError } = await admin.auth.admin.createUser({ email, password, email_confirm: true });
  if (userError || !created.user) {
    const exists = /already|registered|exists/i.test(userError?.message ?? "");
    return json({ error: exists ? "email_taken" : "user_failed" }, exists ? 409 : 500);
  }

  const { data: store, error: storeError } = await admin.from("stores")
    .insert({ name, slug, email, country, currency, phone_cc: cc, whatsapp_cc: cc })
    .select("id, slug, name")
    .single();
  if (storeError) {
    await admin.auth.admin.deleteUser(created.user.id); // no dejar un usuario sin tienda
    return json({ error: storeError.code === "23505" ? "slug_taken" : "store_failed" }, storeError.code === "23505" ? 409 : 500);
  }
  const { error: memberError } = await admin.from("store_members").insert({ store_id: store.id, user_id: created.user.id, role: "owner" });
  if (memberError) {
    await admin.from("stores").delete().eq("id", store.id);
    await admin.auth.admin.deleteUser(created.user.id);
    return json({ error: "member_failed" }, 500);
  }
  return json({ store });
});
