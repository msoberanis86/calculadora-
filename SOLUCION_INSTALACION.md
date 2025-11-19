# 🔧 Solución: "Aplicación no instalada" en Android

## 🔍 Posibles Causas

1. **Versión anterior instalada**: Hay una versión previa con el mismo package ID
2. **APK no firmada correctamente**: Problema con la firma
3. **Versión de Android incompatible**: El dispositivo no cumple los requisitos mínimos
4. **APK corrupta**: El archivo está dañado
5. **Permisos insuficientes**: Falta habilitar "Fuentes desconocidas"

## ✅ Soluciones

### 1. Desinstalar Versión Anterior

Si ya tienes la app instalada, desinstálala primero:

```bash
# Opción A: Desde el dispositivo
Configuración > Aplicaciones > Calculadora + > Desinstalar

# Opción B: Desde ADB
adb uninstall com.calculadora.plus
```

### 2. Habilitar "Fuentes Desconocidas"

1. Ve a: **Configuración > Seguridad**
2. Activa: **"Fuentes desconocidas"** o **"Instalar aplicaciones desconocidas"**
3. Si usas Android 8+, permite la instalación para el navegador o gestor de archivos que uses

### 3. Verificar Requisitos Mínimos

La app requiere:
- **Android mínimo**: 6.0 (API 23) o superior
- **Espacio**: Al menos 10 MB libres

### 4. Reinstalar con ADB (Recomendado)

```bash
# Desinstalar si existe
adb uninstall com.calculadora.plus

# Instalar nueva versión
adb install apk/Calculadora-Plus-v1.0.0-signed.apk
```

### 5. Verificar la APK

```bash
# Verificar firma
jarsigner -verify -verbose apk/Calculadora-Plus-v1.0.0-signed.apk

# Ver información de la APK
aapt dump badging apk/Calculadora-Plus-v1.0.0-signed.apk
```

## 🔨 Generar Nueva APK Firmada Correctamente

Si el problema persiste, genera una nueva APK:

```bash
# 1. Construir la app
npm run build
npm run cap:sync

# 2. Compilar APK (en Android Studio)
# Build > Build APK(s)

# 3. Firmar la APK
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore calculadora-plus.keystore \
  -storepass calculadora2024 \
  -keypass calculadora2024 \
  android/app/build/outputs/apk/debug/app-debug.apk \
  calculadora-plus

# 4. Verificar firma
jarsigner -verify android/app/build/outputs/apk/debug/app-debug.apk

# 5. Alinear (opcional pero recomendado)
zipalign -v 4 android/app/build/outputs/apk/debug/app-debug.apk \
  apk/Calculadora-Plus-v1.0.0-aligned.apk
```

## 📱 Pasos Detallados para Instalación Manual

1. **Transferir APK al dispositivo:**
   - Conecta el dispositivo por USB
   - Copia `apk/Calculadora-Plus-v1.0.0-signed.apk` al dispositivo
   - O envía por email/WhatsApp/Drive

2. **En el dispositivo Android:**
   - Abre el gestor de archivos
   - Navega a donde guardaste la APK
   - Toca el archivo `.apk`
   - Si aparece "Bloqueado por Play Protect", toca "Instalar de todas formas"
   - Sigue las instrucciones

3. **Si aparece "Aplicación no instalada":**
   - Ve a Configuración > Aplicaciones
   - Busca si hay una versión anterior de "Calculadora +"
   - Desinstálala
   - Intenta instalar de nuevo

## 🐛 Diagnóstico Avanzado

### Ver logs de instalación:
```bash
adb logcat | grep -i "packageinstaller\|install"
```

### Verificar permisos:
```bash
adb shell pm list packages | grep calculadora
```

### Ver información del dispositivo:
```bash
adb shell getprop ro.build.version.sdk  # Versión de Android
adb shell getprop ro.product.model      # Modelo del dispositivo
```

## ⚠️ Errores Comunes

### "Aplicación no instalada" sin más detalles
- **Causa**: Conflicto con versión anterior o APK corrupta
- **Solución**: Desinstalar versión anterior y reinstalar

### "El paquete parece estar corrupto"
- **Causa**: APK no firmada correctamente o dañada
- **Solución**: Regenerar y firmar la APK

### "No se puede instalar. Inténtalo de nuevo"
- **Causa**: Espacio insuficiente o permisos
- **Solución**: Liberar espacio y habilitar fuentes desconocidas

## 📞 Información para Debugging

Si el problema persiste, proporciona:
- Modelo del dispositivo Android
- Versión de Android (Configuración > Acerca del teléfono)
- Mensaje de error exacto
- Si hay una versión anterior instalada

