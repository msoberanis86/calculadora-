# 📱 Cómo Instalar la APK en Android

## ⚠️ Si aparece "Aplicación no instalada"

### Solución Rápida:

1. **Desinstalar versión anterior** (si existe):
   ```bash
   adb uninstall com.calculadora.plus
   ```
   O desde el dispositivo:
   - Configuración > Aplicaciones > Buscar "Calculadora +" > Desinstalar

2. **Habilitar "Fuentes desconocidas"**:
   - Configuración > Seguridad > Activar "Fuentes desconocidas"
   - O Configuración > Aplicaciones > Acceso especial > Instalar aplicaciones desconocidas

3. **Instalar la APK corregida**:
   ```bash
   adb install -r apk/Calculadora-Plus-v1.0.0-FIXED.apk
   ```

## 📦 APKs Disponibles

- **APK Original**: `apk/Calculadora-Plus-v1.0.0-signed.apk`
- **APK Corregida**: `apk/Calculadora-Plus-v1.0.0-FIXED.apk` ⭐ (Recomendada)

## 🔧 Métodos de Instalación

### Método 1: ADB (Recomendado)
```bash
# Desinstalar versión anterior
adb uninstall com.calculadora.plus

# Instalar nueva versión
adb install -r apk/Calculadora-Plus-v1.0.0-FIXED.apk
```

### Método 2: Transferencia Manual
1. Copia `apk/Calculadora-Plus-v1.0.0-FIXED.apk` a tu dispositivo
2. Abre el archivo con el gestor de archivos
3. Toca "Instalar"
4. Si aparece "Bloqueado por Play Protect", toca "Instalar de todas formas"

### Método 3: Email/Drive
1. Envía la APK por email o sube a Google Drive
2. Abre desde tu dispositivo Android
3. Descarga y abre el archivo
4. Sigue las instrucciones

## 🐛 Solución de Problemas

### Error: "Aplicación no instalada"
**Causa**: Versión anterior instalada o APK corrupta
**Solución**:
```bash
adb uninstall com.calculadora.plus
adb install apk/Calculadora-Plus-v1.0.0-FIXED.apk
```

### Error: "El paquete parece estar corrupto"
**Causa**: APK no firmada correctamente
**Solución**: Usa la APK corregida (`-FIXED.apk`)

### Error: "No se puede instalar. Inténtalo de nuevo"
**Causa**: Espacio insuficiente o permisos
**Solución**:
- Libera espacio (necesitas ~10 MB)
- Habilita "Fuentes desconocidas"
- Verifica que tienes permisos de administrador

### Error: "Bloqueado por Play Protect"
**Causa**: Google Play Protect bloquea apps no de Play Store
**Solución**: Toca "Instalar de todas formas" o desactiva temporalmente Play Protect

## ✅ Verificar Instalación

```bash
# Verificar que está instalada
adb shell pm list packages | grep calculadora

# Ver información de la app
adb shell dumpsys package com.calculadora.plus | grep versionName
```

## 📋 Requisitos

- **Android mínimo**: 6.0 (Marshmallow) o superior
- **Espacio**: ~10 MB libres
- **Permisos**: Habilitar "Fuentes desconocidas"

## 🔐 Información de la APK

- **Nombre**: Calculadora +
- **Package**: com.calculadora.plus
- **Versión**: 1.0.0
- **Firmada**: ✅ Sí
- **Alineada**: ✅ Sí (versión FIXED)

