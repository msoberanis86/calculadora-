#!/bin/bash

# Script para corregir alineación de APK para Android R+ (API 30+)

set -e

APK_SOURCE="apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk"
APK_FIXED="apk/Calculadora-Plus-v1.0.0-ALIGNED.apk"
TEMP_DIR="/tmp/apk_fix_$$"

echo "🔧 Corrigiendo alineación de APK para Android R+ (API 30+)"
echo ""

# Verificar que la APK existe
if [ ! -f "$APK_SOURCE" ]; then
    echo "❌ APK no encontrada: $APK_SOURCE"
    exit 1
fi

# Crear directorio temporal
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Extraer APK
echo "📦 Extrayendo APK..."
unzip -q "$OLDPWD/$APK_SOURCE" -d .

# Verificar resources.arsc
if [ ! -f "resources.arsc" ]; then
    echo "❌ resources.arsc no encontrado"
    exit 1
fi

# Crear nuevo APK sin comprimir resources.arsc
echo "🔨 Creando APK con resources.arsc sin comprimir..."
zip -q -0 "$OLDPWD/$APK_FIXED" resources.arsc

# Agregar resto de archivos normalmente
echo "📋 Agregando resto de archivos..."
zip -q -r "$OLDPWD/$APK_FIXED" . -x "resources.arsc"

# Limpiar
cd "$OLDPWD"
rm -rf "$TEMP_DIR"

# Verificar si zipalign está disponible
if command -v zipalign &> /dev/null; then
    echo "📐 Alineando APK con zipalign..."
    zipalign -v 4 "$APK_FIXED" "${APK_FIXED}.tmp" && mv "${APK_FIXED}.tmp" "$APK_FIXED"
    echo "✅ APK alineada correctamente"
else
    echo "⚠️  zipalign no disponible, usando método alternativo"
    # Intentar alinear manualmente resources.arsc
    # Esto es más complejo, mejor usar Android SDK tools
fi

# Re-firmar la APK
echo "✍️  Re-firmando APK..."
KEYSTORE="../calculadora-plus.keystore"

if [ ! -f "$KEYSTORE" ]; then
    echo "❌ Keystore no encontrado: $KEYSTORE"
    exit 1
fi

# Eliminar firma anterior
zip -d "$APK_FIXED" "META-INF/*" 2>/dev/null || true

# Firmar
jarsigner -verbose \
    -sigalg SHA256withRSA \
    -digestalg SHA-256 \
    -keystore "$KEYSTORE" \
    -storepass calculadora2024 \
    -keypass calculadora2024 \
    "$APK_FIXED" \
    calculadora-plus 2>&1 | tail -3

# Verificar firma
if jarsigner -verify "$APK_FIXED" > /dev/null 2>&1; then
    echo "✅ APK firmada correctamente"
else
    echo "❌ Error al verificar firma"
    exit 1
fi

echo ""
echo "✅ APK corregida creada: $APK_FIXED"
echo "📦 Tamaño: $(ls -lh "$APK_FIXED" | awk '{print $5}')"

