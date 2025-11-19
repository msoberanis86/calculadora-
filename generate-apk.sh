#!/bin/bash

# Script para generar APK de Android
# Requiere: Android SDK y Gradle configurados

echo "🔨 Construyendo aplicación web..."
npm run build

echo "🔄 Sincronizando con Capacitor..."
npm run cap:sync

echo "📦 Generando APK de debug..."
cd android
./gradlew assembleDebug

if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "✅ APK generada exitosamente!"
    echo "📍 Ubicación: android/app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    echo "Para instalar en tu dispositivo Android:"
    echo "  adb install android/app/build/outputs/apk/debug/app-debug.apk"
else
    echo "❌ Error al generar APK. Asegúrate de tener Android SDK instalado."
    echo "💡 Alternativa: Abre el proyecto en Android Studio y genera la APK desde allí."
fi

cd ..

