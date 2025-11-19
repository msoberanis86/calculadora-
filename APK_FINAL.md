# ✅ APK Firmada - Calculadora +

## 📱 Información de la APK

- **Nombre**: Calculadora +
- **Versión**: 1.0.0
- **Package ID**: com.calculadora.plus
- **Estado**: ✅ Firmada y lista para instalar
- **Icono**: ✅ Icono de calculadora personalizado

## 📍 Ubicación de la APK

La APK firmada está en:

```
apk/Calculadora-Plus-v1.0.0-signed.apk
```

## 🎨 Icono

El icono de la calculadora ha sido creado y está configurado en todos los tamaños necesarios:
- ✅ mipmap-mdpi (48x48)
- ✅ mipmap-hdpi (72x72)
- ✅ mipmap-xhdpi (96x96)
- ✅ mipmap-xxhdpi (144x144)
- ✅ mipmap-xxxhdpi (192x192)

## 🔐 Firma

La APK está firmada con un keystore generado:
- **Keystore**: `calculadora-plus.keystore`
- **Alias**: `calculadora-plus`
- **Algoritmo**: SHA256withRSA

⚠️ **IMPORTANTE**: Guarda el archivo `calculadora-plus.keystore` de forma segura. Lo necesitarás para futuras actualizaciones de la app.

## 📲 Instalación

### Opción 1: Transferir manualmente
1. Copia `apk/Calculadora-Plus-v1.0.0-signed.apk` a tu dispositivo Android
2. Abre el archivo en tu dispositivo
3. Permite la instalación desde "Fuentes desconocidas" si es necesario
4. Sigue las instrucciones para instalar

### Opción 2: Usar ADB
```bash
adb install apk/Calculadora-Plus-v1.0.0-signed.apk
```

## ✨ Características Incluidas

- ✅ Calculadora avanzada con operaciones matemáticas
- ✅ Historial reutilizable de resultados
- ✅ Soporte para paréntesis y orden de operaciones
- ✅ Cálculo automático al presionar operadores
- ✅ Tema claro/oscuro
- ✅ Formato numérico para Guatemala (punto decimal, coma para miles)
- ✅ Soporte de teclado físico
- ✅ Diseño Mobile-First y responsive
- ✅ Respeta la barra superior del celular (safe area)
- ✅ Icono de calculadora personalizado
- ✅ Nombre: "Calculadora +"

## 🔄 Para Generar una Nueva APK Firmada

Si necesitas regenerar la APK con cambios:

```bash
# 1. Construir la app
npm run build

# 2. Sincronizar
npm run cap:sync

# 3. Compilar APK (en Android Studio o con gradlew)
cd android
./gradlew assembleDebug
cd ..

# 4. Firmar la APK
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore calculadora-plus.keystore \
  -storepass calculadora2024 \
  -keypass calculadora2024 \
  android/app/build/intermediates/apk/debug/app-debug.apk \
  calculadora-plus

# 5. Copiar a carpeta apk
cp android/app/build/intermediates/apk/debug/app-debug.apk \
   apk/Calculadora-Plus-v1.0.0-signed.apk
```

## 📝 Notas

- La APK está firmada y lista para distribución
- El icono muestra una calculadora con pantalla y botones
- El nombre de la app es "Calculadora +" como se muestra en el launcher
- La app respeta el espacio de la barra superior del celular

