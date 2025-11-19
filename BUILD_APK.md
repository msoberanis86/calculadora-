# Guía para Generar APK de Android

## Requisitos Previos

1. **Android Studio** instalado en tu computadora
2. **Java JDK** (versión 11 o superior)
3. **Gradle** (se instala automáticamente con Android Studio)

## Pasos para Generar la APK

### 1. Construir la aplicación web

```bash
npm run build
```

### 2. Sincronizar con Capacitor

```bash
npm run cap:sync
```

### 3. Abrir en Android Studio

```bash
npm run cap:open:android
```

O manualmente:
- Abre Android Studio
- Selecciona "Open an Existing Project"
- Navega a la carpeta `android` dentro del proyecto

### 4. Generar APK de Debug (para pruebas)

1. En Android Studio, ve a: **Build > Build Bundle(s) / APK(s) > Build APK(s)**
2. Espera a que termine la compilación
3. Cuando termine, haz clic en "locate" en la notificación
4. El APK estará en: `android/app/build/outputs/apk/debug/app-debug.apk`

### 5. Generar APK Firmado para Producción

1. Ve a: **Build > Generate Signed Bundle / APK**
2. Selecciona **APK**
3. Si no tienes un keystore, crea uno nuevo:
   - Haz clic en "Create new..."
   - Completa el formulario (alias, contraseña, etc.)
   - Guarda el keystore en un lugar seguro
4. Selecciona tu keystore y completa la información
5. Selecciona **release** como build variant
6. Haz clic en "Finish"
7. El APK estará en: `android/app/build/outputs/apk/release/app-release.apk`

## Instalación en Dispositivo Android

### Opción 1: Transferir APK directamente
1. Transfiere el archivo `.apk` a tu dispositivo Android
2. Abre el archivo en tu dispositivo
3. Permite la instalación desde "Fuentes desconocidas" si es necesario
4. Sigue las instrucciones para instalar

### Opción 2: Usar ADB (Android Debug Bridge)
```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

## Información de la App

- **Nombre**: Calculadora +
- **Package ID**: com.calculadora.plus
- **Versión**: 1.0.0
- **Versión de Código**: 1

## Notas Importantes

- El APK de debug es para pruebas y no se puede publicar en Google Play Store
- Para publicar en Google Play Store, necesitas generar un APK firmado (release)
- Guarda tu keystore de forma segura, lo necesitarás para actualizaciones futuras
- El icono de la app se encuentra en: `android/app/src/main/res/mipmap-*/`

## Solución de Problemas

### Error: "SDK location not found"
- Abre Android Studio
- Ve a: **File > Project Structure > SDK Location**
- Configura la ruta del SDK de Android

### Error: "Gradle sync failed"
- Abre Android Studio
- Ve a: **File > Sync Project with Gradle Files**

### Error al instalar APK: "App not installed"
- Asegúrate de desinstalar cualquier versión anterior de la app
- Verifica que el APK no esté corrupto
- Revisa los permisos de instalación en tu dispositivo

