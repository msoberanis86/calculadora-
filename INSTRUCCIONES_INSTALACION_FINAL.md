# 📱 Instrucciones Finales de Instalación

## ✅ APK de Producción Lista

He creado una nueva APK correctamente firmada:
**`apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk`**

## 🚀 Pasos para Instalar (IMPORTANTE)

### 1. DESINSTALAR Versión Anterior (CRÍTICO)

**En tu dispositivo Android:**
1. Ve a: **Configuración > Aplicaciones**
2. Busca cualquier app que diga "Calculadora" o "Calculadora +"
3. Si encuentras alguna, tócala y selecciona **"Desinstalar"**
4. Asegúrate de que NO quede ninguna versión instalada

**O desde la computadora (si tienes ADB):**
```bash
adb uninstall com.calculadora.plus
```

### 2. Habilitar "Fuentes Desconocidas"

1. Ve a: **Configuración > Seguridad**
2. Activa: **"Fuentes desconocidas"** o **"Instalar aplicaciones desconocidas"**
3. Si usas Android 8+, permite la instalación para tu gestor de archivos

### 3. Instalar la Nueva APK

**Opción A: Con ADB (Recomendado)**
```bash
adb install apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk
```

**Opción B: Transferencia Manual**
1. Transfiere `apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk` a tu dispositivo
   - Por USB, email, WhatsApp, Google Drive, etc.
2. Abre el archivo con el gestor de archivos
3. Toca **"Instalar"**
4. Si aparece **"Bloqueado por Play Protect"**, toca **"Instalar de todas formas"**

## ⚠️ Si Aún Aparece "App not installed"

### Verificar que no hay versión anterior:
```bash
adb shell pm list packages | grep calculadora
```

Si aparece algo, desinstálalo:
```bash
adb uninstall com.calculadora.plus
adb shell pm clear com.calculadora.plus
```

### Limpiar cache del instalador:
1. Configuración > Aplicaciones > Google Play Store
2. Almacenamiento > Borrar caché
3. Repite para "Servicios de Google Play"

### Reiniciar el dispositivo:
A veces ayuda reiniciar después de desinstalar

### Intentar instalar de nuevo:
```bash
adb install -r apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk
```

## 🔍 Verificar Instalación Exitosa

```bash
# Verificar que está instalada
adb shell pm list packages | grep calculadora

# Debería mostrar: package:com.calculadora.plus
```

## 📋 Información de la APK

- **Nombre**: Calculadora +
- **Package**: com.calculadora.plus
- **Versión**: 1.0.0
- **Tamaño**: ~4 MB
- **Estado**: ✅ Firmada correctamente
- **Incluye**: Historial persistente, tema persistente, icono personalizado

## 💡 Consejos

1. **Siempre desinstala la versión anterior primero**
2. **Usa la APK de PRODUCCIÓN** (no la signed anterior)
3. **Si Play Protect bloquea**, es normal para apps no de Play Store
4. **Reinicia el dispositivo** si el problema persiste

## 🆘 Si Nada Funciona

Proporciona esta información:
- Modelo del dispositivo
- Versión de Android
- Mensaje de error exacto
- Si hay versión anterior instalada
- Logs de instalación (si tienes ADB)

