#!/bin/bash

# Script para generar APK firmada para Calculadora +
# Este script crea un keystore y genera una APK firmada lista para distribución

set -e

KEYSTORE_PATH="calculadora-plus.keystore"
KEYSTORE_ALIAS="calculadora-plus"
KEYSTORE_PASSWORD="calculadora2024"
KEYSTORE_VALIDITY=10000

APK_OUTPUT_DIR="apk"
DEBUG_APK="android/app/build/intermediates/apk/debug/app-debug.apk"
RELEASE_APK="android/app/build/outputs/apk/release/app-release.apk"

echo "🔨 Generando APK firmada para Calculadora +"
echo ""

# 1. Construir la aplicación web
echo "📦 Construyendo aplicación web..."
npm run build

# 2. Sincronizar con Capacitor
echo "🔄 Sincronizando con Capacitor..."
npm run cap:sync

# 3. Verificar si existe el keystore
if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "🔑 Creando keystore para firmar la APK..."
    keytool -genkey -v \
        -keystore "$KEYSTORE_PATH" \
        -alias "$KEYSTORE_ALIAS" \
        -keyalg RSA \
        -keysize 2048 \
        -validity $KEYSTORE_VALIDITY \
        -storepass "$KEYSTORE_PASSWORD" \
        -keypass "$KEYSTORE_PASSWORD" \
        -dname "CN=Calculadora Plus, OU=Development, O=Calculadora Plus, L=Guatemala, ST=Guatemala, C=GT"
    
    echo "✅ Keystore creado: $KEYSTORE_PATH"
    echo "⚠️  IMPORTANTE: Guarda este keystore de forma segura. Lo necesitarás para actualizaciones futuras."
else
    echo "✅ Keystore ya existe: $KEYSTORE_PATH"
fi

# 4. Compilar APK de release
echo "🔨 Compilando APK de release..."
cd android
./gradlew clean
./gradlew assembleRelease

cd ..

# 5. Verificar si la APK de release existe
if [ ! -f "$RELEASE_APK" ]; then
    echo "⚠️  APK de release no encontrada, usando APK de debug..."
    if [ ! -f "$DEBUG_APK" ]; then
        echo "❌ Error: No se encontró ninguna APK. Compilando APK de debug..."
        cd android
        ./gradlew assembleDebug
        cd ..
    fi
    SOURCE_APK="$DEBUG_APK"
else
    SOURCE_APK="$RELEASE_APK"
fi

# 6. Crear directorio de salida
mkdir -p "$APK_OUTPUT_DIR"

# 7. Firmar la APK
echo "✍️  Firmando APK..."
SIGNED_APK="$APK_OUTPUT_DIR/Calculadora-Plus-v1.0.0-signed.apk"

# Usar apksigner si está disponible, sino usar jarsigner
if command -v apksigner &> /dev/null; then
    # Alinear la APK primero
    ALIGNED_APK="$APK_OUTPUT_DIR/app-aligned.apk"
    zipalign -v 4 "$SOURCE_APK" "$ALIGNED_APK"
    
    # Firmar con apksigner
    apksigner sign \
        --ks "$KEYSTORE_PATH" \
        --ks-pass "pass:$KEYSTORE_PASSWORD" \
        --ks-key-alias "$KEYSTORE_ALIAS" \
        --key-pass "pass:$KEYSTORE_PASSWORD" \
        --out "$SIGNED_APK" \
        "$ALIGNED_APK"
    
    # Verificar la firma
    apksigner verify "$SIGNED_APK"
    rm -f "$ALIGNED_APK"
else
    # Usar jarsigner (método alternativo)
    echo "⚠️  apksigner no disponible, usando jarsigner..."
    cp "$SOURCE_APK" "$SIGNED_APK"
    jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
        -keystore "$KEYSTORE_PATH" \
        -storepass "$KEYSTORE_PASSWORD" \
        -keypass "$KEYSTORE_PASSWORD" \
        "$SIGNED_APK" \
        "$KEYSTORE_ALIAS"
    
    # Verificar la firma
    jarsigner -verify -verbose -certs "$SIGNED_APK"
fi

echo ""
echo "✅ APK firmada generada exitosamente!"
echo "📍 Ubicación: $SIGNED_APK"
echo ""
echo "📱 Información de la APK:"
echo "   - Nombre: Calculadora +"
echo "   - Versión: 1.0.0"
echo "   - Package: com.calculadora.plus"
echo "   - Estado: ✅ Firmada y lista para instalar"
echo ""
echo "🚀 Para instalar en tu dispositivo:"
echo "   adb install $SIGNED_APK"
echo ""
echo "⚠️  RECUERDA: Guarda el keystore ($KEYSTORE_PATH) de forma segura."

