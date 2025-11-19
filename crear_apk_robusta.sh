#!/bin/bash

# Script para crear APK robusta que se instale correctamente

set -e

echo "🔨 Creando APK robusta para Calculadora +"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

# 2.5. Corregir versión de Java (los archivos se regeneran con cap:sync)
echo -e "${YELLOW}🔧 Corrigiendo versión de Java...${NC}"
# Corregir todos los archivos gradle que puedan tener Java 21
find android -name "*.gradle" -type f -exec sed -i 's/JavaVersion.VERSION_21/JavaVersion.VERSION_17/g' {} \;
find node_modules/@capacitor/android -name "*.gradle" -type f -exec sed -i 's/JavaVersion.VERSION_21/JavaVersion.VERSION_17/g' {} \; 2>/dev/null || true

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

# 4. Verificar que Android está listo
if [ ! -d "android" ]; then
    echo -e "${RED}❌ Directorio android no encontrado${NC}"
    exit 1
fi

cd android

# 5. Limpiar builds anteriores
echo -e "${YELLOW}🧹 Limpiando builds anteriores...${NC}"
./gradlew clean 2>&1 | tail -3 || true

# 6. Verificar configuración Java
if [ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    export PATH=$JAVA_HOME/bin:$PATH
    echo -e "${GREEN}✅ Java 17 configurado${NC}"
fi

# 7. Intentar compilar APK Debug
echo -e "${YELLOW}🔨 Compilando APK Debug...${NC}"
if ./gradlew assembleDebug 2>&1 | tee /tmp/gradle_build.log | tail -10; then
    echo -e "${GREEN}✅ Compilación exitosa${NC}"
    
    # Buscar APK generada
    APK_DEBUG=""
    if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
        APK_DEBUG="app/build/outputs/apk/debug/app-debug.apk"
    elif [ -f "app/build/intermediates/apk/debug/app-debug.apk" ]; then
        APK_DEBUG="app/build/intermediates/apk/debug/app-debug.apk"
    fi
    
    if [ -n "$APK_DEBUG" ]; then
        echo -e "${GREEN}✅ APK encontrada: $APK_DEBUG${NC}"
    else
        echo -e "${RED}❌ APK no encontrada después de compilar${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Error en la compilación${NC}"
    echo -e "${YELLOW}💡 Revisa los logs en /tmp/gradle_build.log${NC}"
    exit 1
fi

cd ..

# 8. Crear directorio de salida
mkdir -p apk

# 9. Preparar APK para firma
APK_UNSIGNED="apk/Calculadora-Plus-unsigned-temp.apk"
APK_SIGNED="apk/Calculadora-Plus-v1.0.0-FINAL.apk"

echo -e "${YELLOW}📋 Preparando APK para firma...${NC}"
cp "android/$APK_DEBUG" "$APK_UNSIGNED"

# 10. Eliminar firma anterior completamente
echo -e "${YELLOW}🧹 Eliminando firma anterior...${NC}"
zip -d "$APK_UNSIGNED" "META-INF/*" 2>&1 | grep -v "warning" || true

# 11. Firmar la APK
echo -e "${YELLOW}✍️  Firmando APK...${NC}"
jarsigner -verbose \
    -sigalg SHA256withRSA \
    -digestalg SHA-256 \
    -keystore "$KEYSTORE" \
    -storepass calculadora2024 \
    -keypass calculadora2024 \
    "$APK_UNSIGNED" \
    calculadora-plus 2>&1 | tail -3

# 12. Verificar firma
echo -e "${YELLOW}🔍 Verificando firma...${NC}"
if jarsigner -verify "$APK_UNSIGNED" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ APK firmada correctamente${NC}"
else
    echo -e "${RED}❌ Error al verificar firma${NC}"
    exit 1
fi

# 13. Alinear APK (si zipalign está disponible)
if command -v zipalign &> /dev/null; then
    echo -e "${YELLOW}📐 Alineando APK...${NC}"
    zipalign -v 4 "$APK_UNSIGNED" "$APK_SIGNED"
    rm -f "$APK_UNSIGNED"
    echo -e "${GREEN}✅ APK alineada${NC}"
else
    echo -e "${YELLOW}⚠️  zipalign no disponible, usando APK sin alinear${NC}"
    mv "$APK_UNSIGNED" "$APK_SIGNED"
fi

# 14. Información final
echo ""
echo -e "${GREEN}✅ APK FINAL creada exitosamente!${NC}"
echo ""
echo "📱 Ubicación: $APK_SIGNED"
echo "📦 Tamaño: $(ls -lh "$APK_SIGNED" | awk '{print $5}')"
echo ""
echo "🚀 Para instalar:"
echo "   1. Desinstala versión anterior: adb uninstall com.calculadora.plus"
echo "   2. Instala nueva: adb install -r $APK_SIGNED"
echo ""
echo "💡 Si aparece 'App not installed':"
echo "   - Asegúrate de desinstalar la versión anterior completamente"
echo "   - Verifica que 'Fuentes desconocidas' esté habilitado"
echo "   - Reinicia el dispositivo"
echo "   - Verifica que hay espacio suficiente"

