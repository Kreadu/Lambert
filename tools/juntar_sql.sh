#!/usr/bin/env bash
# Junta setup + todas las migraciones (002, 003, …) en supabase/todo-en-uno.sql, para un proyecto Supabase NUEVO:
# se pega completo en SQL Editor → Run. Volver a correr este script cada vez que se agregue una migración.
set -euo pipefail
cd "$(dirname "$0")/../supabase"
{
  echo "-- Lambert: base completa (setup + migraciones) para un proyecto Supabase NUEVO. Pegar todo en SQL Editor → Run."
  echo "-- GENERADO por tools/juntar_sql.sh; no editar a mano."
  for f in setup.sql $(ls [0-9][0-9][0-9]-*.sql | sort); do
    echo; echo "-- ════════ $f ════════"; cat "$f"
  done
  echo; echo "-- administrador"
  echo "insert into public.admins (email) values ('raipimo36@gmail.com') on conflict do nothing;"
} > todo-en-uno.sql
echo "supabase/todo-en-uno.sql listo"
