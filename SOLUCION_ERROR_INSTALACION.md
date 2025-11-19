# 🔧 Solución: "Something went wrong. App not installed"

## 🎯 Solución Rápida

Este error generalmente se debe a que la APK no está correctamente alineada o hay un conflicto con una versión anterior.

### Paso 1: Desinstalar Versión Anterior

**Desde el dispositivo:**
1. Ve a: **Configuración > Aplicaciones**
2. Busca "Calculadora +" o cualquier app relacionada
3. Si existe, tócala y selecciona **"Desinstalar"**

**O desde ADB:**
```bash
adb uninstall com.calculadora.plus
```

### Paso 2: Limpiar Cache del Instalador

1. Ve a: **Configuración > Aplicaciones > Google Play Store**
2. Toca **"Almacenamiento"**
3. Toca **"Borrar caché"** y **"Borrar datos"**
4. Repite para **"Servicios de Google Play"**

### Paso 3: Instalar APK Corregida

He creado un script que genera una APK correctamente firmada:

```bash
./create_production_apk.sh
```

Esto creará: `apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk`

### Paso 4: Instalar la Nueva APK

**Opción A: Desde ADB (Recomendado)**
```bash
adb install -r apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk
```

**Opción B: Transferencia Manual**
1. Transfiere `apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk` a tu dispositivo
2. Abre el archivo con el gestor de archivos
3. Toca "Instalar"
4. Si aparece "Bloqueado por Play Protect", toca "Instalar de todas formas"

## 🔍 Diagnóstico del Error

### Causas Comunes:

1. **APK no alineada**: La APK necesita estar alineada con `zipalign`
2. **Firma incorrecta**: Problema con el certificado
3. **Versión anterior**: Conflicto con app instalada previamente
4. **Espacio insuficiente**: No hay suficiente espacio en el dispositivo
5. **Permisos**: "Fuentes desconocidas" no habilitado

## ✅ Verificación

### Verificar que no hay versión anterior:
```bash
adb shell pm list packages | grep calculadora
```

Si aparece algo, desinstálalo:
```bash
adb uninstall com.calculadora.plus
```

### Verificar espacio disponible:
```bash
adb shell df /data
```

Necesitas al menos 10 MB libres.

### Ver logs de instalación:
```bash
adb logcat | grep -i "packageinstaller\|install"
```

Mientras intentas instalar, esto mostrará el error específico.

## 🛠️ Solución Alternativa: Reinstalar desde Cero

Si nada funciona:

1. **Desinstalar completamente:**
   ```bash
   adb uninstall com.calculadora.plus
   adb shell pm clear com.calculadora.plus
   ```

2. **Reiniciar el dispositivo** (opcional pero recomendado)

3. **Instalar APK nueva:**
   ```bash
   adb install apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk
   ```

## 📱 Información del Dispositivo

Para ayudar a diagnosticar, proporciona:
- Modelo del dispositivo
- Versión de Android (Configuración > Acerca del teléfono)
- Mensaje de error exacto (si hay uno diferente)
- Si hay una versión anterior instalada

## ⚠️ Nota Importante

La APK debe estar:
- ✅ Firmada correctamente
- ✅ Alineada (zipalign)
- ✅ Sin conflictos con versiones anteriores
- ✅ Con espacio suficiente en el dispositivo

El script `create_production_apk.sh` genera una APK que cumple todos estos requisitos.

