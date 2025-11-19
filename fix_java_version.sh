#!/bin/bash

# Script para corregir versión de Java en archivos generados por Capacitor

echo "🔧 Corrigiendo versión de Java en archivos de Capacitor..."

# Corregir capacitor.build.gradle
if [ -f "android/app/capacitor.build.gradle" ]; then
    sed -i 's/JavaVersion.VERSION_21/JavaVersion.VERSION_17/g' android/app/capacitor.build.gradle
    echo "✅ Corregido: android/app/capacitor.build.gradle"
fi

# Corregir capacitor-cordova-android-plugins/build.gradle
if [ -f "android/capacitor-cordova-android-plugins/build.gradle" ]; then
    sed -i 's/JavaVersion.VERSION_21/JavaVersion.VERSION_17/g' android/capacitor-cordova-android-plugins/build.gradle
    echo "✅ Corregido: android/capacitor-cordova-android-plugins/build.gradle"
fi

echo "✅ Corrección completada"

