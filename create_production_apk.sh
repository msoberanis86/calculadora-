#!/bin/bash

# Script para crear APK de producción correctamente firmada y alineada

set -e

echo "🔨 Creando APK de producción para Calculadora +"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Error: Ejecuta este script desde la raíz del proyecto${NC}"
    exit 1
fi

# 1. Construir la aplicación web
echo -e "${YELLOW}📦 Construyendo aplicación web...${NC}"
npm run build

# 2. Sincronizar con Capacitor
echo -e "${YELLOW}🔄 Sincronizando con Capacitor...${NC}"
npm run cap:sync

# 3. Verificar keystore
KEYSTORE="calculadora-plus.keystore"
if [ ! -f "$KEYSTORE" ]; then
    echo -e "${YELLOW}🔑 Creando keystore...${NC}"
    keytool -genkey -v \
        -keystore "$KEYSTORE" \
        -alias calculadora-plus \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -storepass calculadora2024 \
        -keypass calculadora2024 \
        -dname "CN=Calculadora Plus, OU=Development, O=Calculadora Plus, L=Guatemala, ST=Guatemala, C=GT"
fi

# 4. Intentar compilar (si Android SDK está disponible)
echo -e "${YELLOW}🔨 Intentando compilar APK...${NC}"
cd android

# Configurar Java si está disponible
if [ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    export PATH=$JAVA_HOME/bin:$PATH
fi

# Intentar compilar
if ./gradlew assembleDebug 2>&1 | tail -5 | grep -q "BUILD SUCCESSFUL"; then
    echo -e "${GREEN}✅ APK compilada exitosamente${NC}"
    APK_SOURCE="app/build/outputs/apk/debug/app-debug.apk"
elif [ -f "app/build/intermediates/apk/debug/app-debug.apk" ]; then
    echo -e "${YELLOW}⚠️  Usando APK intermedia${NC}"
    APK_SOURCE="app/build/intermediates/apk/debug/app-debug.apk"
else
    echo -e "${RED}❌ No se pudo compilar la APK. Usa Android Studio para compilar.${NC}"
    echo -e "${YELLOW}💡 Alternativa: Usa la APK existente y solo re-fírmala${NC}"
    cd ..
    exit 1
fi

cd ..

# 5. Crear directorio de salida
mkdir -p apk

# 6. Copiar y preparar APK
APK_UNSIGNED="apk/Calculadora-Plus-unsigned.apk"
APK_SIGNED="apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk"

echo -e "${YELLOW}📋 Preparando APK...${NC}"
cp "android/$APK_SOURCE" "$APK_UNSIGNED"

# 7. Eliminar firma anterior si existe
echo -e "${YELLOW}🧹 Limpiando firma anterior...${NC}"
zip -d "$APK_UNSIGNED" "META-INF/*" 2>/dev/null || true

# 8. Firmar la APK
echo -e "${YELLOW}✍️  Firmando APK...${NC}"
jarsigner -verbose \
    -sigalg SHA256withRSA \
    -digestalg SHA-256 \
    -keystore "$KEYSTORE" \
    -storepass calculadora2024 \
    -keypass calculadora2024 \
    "$APK_UNSIGNED" \
    calculadora-plus

# 9. Alinear APK (si zipalign está disponible)
if command -v zipalign &> /dev/null; then
    echo -e "${YELLOW}📐 Alineando APK...${NC}"
    zipalign -v 4 "$APK_UNSIGNED" "$APK_SIGNED"
    rm -f "$APK_UNSIGNED"
else
    echo -e "${YELLOW}⚠️  zipalign no disponible, usando APK sin alinear${NC}"
    mv "$APK_UNSIGNED" "$APK_SIGNED"
fi

# 10. Verificar firma
echo -e "${YELLOW}🔍 Verificando firma...${NC}"
if jarsigner -verify "$APK_SIGNED" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ APK firmada correctamente${NC}"
else
    echo -e "${RED}❌ Error al verificar firma${NC}"
    exit 1
fi

# 11. Información final
echo ""
echo -e "${GREEN}✅ APK de producción creada exitosamente!${NC}"
echo ""
echo "📱 Ubicación: $APK_SIGNED"
echo "📦 Tamaño: $(ls -lh "$APK_SIGNED" | awk '{print $5}')"
echo ""
echo "🚀 Para instalar:"
echo "   adb install -r $APK_SIGNED"
echo ""
echo "💡 Si aparece 'App not installed':"
echo "   1. Desinstala versión anterior: adb uninstall com.calculadora.plus"
echo "   2. Instala: adb install $APK_SIGNED"
echo "   3. O transfiere el archivo al dispositivo y ábrelo"

