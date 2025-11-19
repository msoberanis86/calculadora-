#!/bin/bash

# Script de diagnóstico para APK

APK="apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk"

echo "🔍 Diagnóstico de APK"
echo "===================="
echo ""

if [ ! -f "$APK" ]; then
    echo "❌ APK no encontrada: $APK"
    exit 1
fi

echo "📦 Información de la APK:"
echo "   Tamaño: $(ls -lh "$APK" | awk '{print $5}')"
echo "   Ubicación: $APK"
echo ""

echo "🔐 Verificando firma..."
if jarsigner -verify "$APK" > /dev/null 2>&1; then
    echo "   ✅ APK está firmada correctamente"
else
    echo "   ❌ Problema con la firma"
fi
echo ""

echo "📋 Estructura de la APK:"
unzip -l "$APK" | grep -E "(AndroidManifest|classes.dex|resources.arsc)" | head -5
echo ""

echo "🔍 Verificando AndroidManifest..."
if unzip -p "$APK" AndroidManifest.xml > /tmp/manifest.xml 2>/dev/null; then
    echo "   ✅ AndroidManifest.xml encontrado"
    if command -v aapt &> /dev/null; then
        echo ""
        echo "   Información del paquete:"
        aapt dump badging "$APK" 2>/dev/null | grep -E "(package|versionCode|versionName|sdkVersion)" | head -5
    else
        echo "   ⚠️  aapt no disponible para análisis detallado"
    fi
else
    echo "   ❌ No se pudo extraer AndroidManifest.xml"
fi
echo ""

echo "📱 Pruebas de instalación (requiere ADB):"
if command -v adb &> /dev/null; then
    DEVICES=$(adb devices | grep -v "List" | grep "device" | wc -l)
    if [ "$DEVICES" -gt 0 ]; then
        echo "   ✅ Dispositivo conectado"
        echo ""
        echo "   Intentando instalar..."
        adb install -r "$APK" 2>&1 | tail -3
    else
        echo "   ⚠️  No hay dispositivos conectados"
        echo "   Conecta un dispositivo y ejecuta: adb install -r $APK"
    fi
else
    echo "   ⚠️  ADB no disponible"
fi
echo ""

echo "💡 Soluciones comunes:"
echo "   1. Desinstalar versión anterior: adb uninstall com.calculadora.plus"
echo "   2. Limpiar cache: adb shell pm clear com.calculadora.plus"
echo "   3. Habilitar 'Fuentes desconocidas' en el dispositivo"
echo "   4. Verificar espacio disponible en el dispositivo"
echo "   5. Reiniciar el dispositivo"

