#!/bin/bash

# Script para corregir problemas de instalación de APK

APK_ORIGINAL="apk/Calculadora-Plus-v1.0.0-signed.apk"
APK_FIXED="apk/Calculadora-Plus-v1.0.0-FIXED.apk"

echo "🔧 Corrigiendo APK para instalación..."
echo ""

# 1. Verificar que existe la APK original
if [ ! -f "$APK_ORIGINAL" ]; then
    echo "❌ Error: No se encuentra la APK original"
    exit 1
fi

# 2. Copiar APK
cp "$APK_ORIGINAL" "$APK_FIXED"

# 3. Verificar firma
echo "✅ Verificando firma..."
jarsigner -verify "$APK_FIXED" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ APK firmada correctamente"
else
    echo "⚠️  Re-firmando APK..."
    jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
        -keystore calculadora-plus.keystore \
        -storepass calculadora2024 \
        -keypass calculadora2024 \
        "$APK_FIXED" \
        calculadora-plus
fi

# 4. Intentar alinear (si zipalign está disponible)
if command -v zipalign &> /dev/null; then
    echo "📐 Alineando APK..."
    APK_ALIGNED="apk/Calculadora-Plus-v1.0.0-ALIGNED.apk"
    zipalign -v 4 "$APK_FIXED" "$APK_ALIGNED" 2>&1 | tail -3
    if [ $? -eq 0 ]; then
        mv "$APK_ALIGNED" "$APK_FIXED"
        echo "✅ APK alineada correctamente"
    fi
else
    echo "⚠️  zipalign no disponible (opcional)"
fi

# 5. Verificar APK final
echo ""
echo "🔍 Verificando APK final..."
jarsigner -verify "$APK_FIXED" 2>&1 | tail -3

echo ""
echo "✅ APK corregida: $APK_FIXED"
echo ""
echo "📱 Para instalar:"
echo "   adb install -r $APK_FIXED"
echo ""
echo "💡 Si aún no se instala:"
echo "   1. Desinstala versión anterior: adb uninstall com.calculadora.plus"
echo "   2. Luego instala: adb install $APK_FIXED"

