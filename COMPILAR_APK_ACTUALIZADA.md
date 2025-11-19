# 🔨 Compilar APK Actualizada con Historial Persistente

## ⚠️ Estado Actual

La APK actual (`apk/Calculadora-Plus-v1.0.0-signed.apk`) **NO incluye** los cambios del historial persistente.

**Fecha de la APK actual**: 18 de noviembre 21:42  
**Cambios nuevos**: Historial persistente (guardado automático)

## 🚀 Opción 1: Compilar en Android Studio (Recomendado)

### Pasos:

1. **Abrir el proyecto en Android Studio:**
   ```bash
   npm run cap:open:android
   ```
   O manualmente:
   - Abre Android Studio
   - File > Open > Selecciona la carpeta `android`

2. **Esperar a que Gradle sincronice** (puede tomar unos minutos la primera vez)

3. **Generar la APK:**
   - Ve a: **Build > Build Bundle(s) / APK(s) > Build APK(s)**
   - Espera a que termine la compilación
   - Haz clic en "locate" en la notificación

4. **Firmar la APK:**
   - La APK estará en: `android/app/build/outputs/apk/debug/app-debug.apk`
   - Usa el keystore existente: `calculadora-plus.keystore`
   - Contraseña: `calculadora2024`

5. **Firmar con jarsigner:**
   ```bash
   jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
     -keystore calculadora-plus.keystore \
     -storepass calculadora2024 \
     -keypass calculadora2024 \
     android/app/build/outputs/apk/debug/app-debug.apk \
     calculadora-plus
   ```

6. **Copiar a carpeta apk:**
   ```bash
   cp android/app/build/outputs/apk/debug/app-debug.apk \
      apk/Calculadora-Plus-v1.0.0-signed.apk
   ```

## 🔧 Opción 2: Instalar JDK Completo

Si prefieres compilar desde la terminal, necesitas instalar el JDK completo:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-17-jdk

# Luego configurar JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Verificar
java -version
javac -version

# Compilar
cd android
./gradlew assembleDebug
```

## ✅ Verificar que los Cambios Están Incluidos

Después de compilar, verifica que la nueva APK incluya:

1. **Historial persistente**: El historial se guarda automáticamente
2. **Tema persistente**: La preferencia de tema se guarda
3. **Icono de calculadora**: Icono personalizado
4. **Nombre "Calculadora +"**: Nombre correcto en el launcher

## 📱 Instalar la Nueva APK

```bash
# Desinstalar versión anterior (si existe)
adb uninstall com.calculadora.plus

# Instalar nueva versión
adb install apk/Calculadora-Plus-v1.0.0-signed.apk
```

## 🎯 Resumen de Cambios Incluidos

- ✅ Historial se guarda automáticamente en el cache del dispositivo
- ✅ Historial se restaura al abrir la app
- ✅ Tema (claro/oscuro) se guarda y restaura
- ✅ Usa Capacitor Preferences (almacenamiento nativo Android)
- ✅ Fallback a localStorage si es necesario

## ⚠️ Nota Importante

La APK actual es de **antes** de implementar el historial persistente. Para tener la funcionalidad completa, **debes compilar una nueva APK**.

