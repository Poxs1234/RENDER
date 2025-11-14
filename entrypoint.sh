#!/bin/bash
set -e

if [ -n "$APP_DLL" ]; then
  DLL="$APP_DLL"
else
  DLL=$(ls *.dll 2>/dev/null | grep -v "runtimeconfig" | head -n 1 || true)
fi

if [ -z "$DLL" ]; then
  echo "No se encontró ningún .dll en /app. Asegúrate de que la aplicación se haya publicado correctamente."
  exit 1
fi

echo "Iniciando: dotnet /app/$DLL"
exec dotnet "/app/$DLL"
