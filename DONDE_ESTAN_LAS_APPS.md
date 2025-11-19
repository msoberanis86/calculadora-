# 📍 ¿Dónde están las APK y Apps de iOS?

## ⚠️ Importante: Las apps NO se generan automáticamente

Las APK de Android y las apps de iOS **necesitan ser compiladas** usando las herramientas nativas. No existen hasta que las generes.

## 📱 Android APK

### Ubicación después de generarla:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

### Cómo generarla:

#### Opción 1: Usando Android Studio (Recomendado)
1. Abre Android Studio
2. Abre el proyecto: `File > Open > Selecciona la carpeta "android"`
3. Espera a que Gradle sincronice
4. Ve a: **Build > Build Bundle(s) / APK(s) > Build APK(s)**
5. Cuando termine, haz clic en "locate" en la notificación
6. El APK estará en: `android/app/build/outputs/apk/debug/app-debug.apk`

#### Opción 2: Desde la línea de comandos
```bash
# Asegúrate de tener Android SDK instalado
cd android
./gradlew assembleDebug

# El APK estará en:
# android/app/build/outputs/apk/debug/app-debug.apk
```

#### Opción 3: Usando el script proporcionado
```bash
./generate-apk.sh
```

### Instalar la APK en tu dispositivo:
```bash
# Conecta tu dispositivo Android por USB
adb install android/app/build/outputs/apk/debug/app-debug.apk

# O transfiere el archivo .apk a tu dispositivo y ábrelo
```

## 🍎 iOS App

### Ubicación después de compilarla:
```
ios/App/build/Release-iphoneos/App.app
```

### Cómo generarla:

#### Requisitos:
- macOS (necesario para desarrollar iOS)
- Xcode instalado
- CocoaPods instalado: `sudo gem install cocoapods`

#### Pasos:
1. Construir la app web:
   ```bash
   npm run build
   ```

2. Sincronizar con Capacitor:
   ```bash
   npm run cap:sync
   ```

3. Instalar dependencias de iOS:
   ```bash
   cd ios/App
   pod install
   cd ../..
   ```

4. Abrir en Xcode:
   ```bash
   npm run cap:open:ios
   ```
   O manualmente: Abre `ios/App/App.xcworkspace` en Xcode

5. En Xcode:
   - Selecciona un simulador o dispositivo
   - Presiona el botón **Play** (▶️) o `Cmd + R`
   - La app se compilará y ejecutará

### Para generar IPA (para distribución):
1. En Xcode: **Product > Archive**
2. Se abrirá el Organizer
3. Selecciona **"Distribute App"**
4. Elige el método de distribución (App Store, Ad Hoc, etc.)

## 🚀 Resumen Rápido

### Android:
```bash
npm run build
npm run cap:sync
npm run cap:open:android
# Luego en Android Studio: Build > Build APK(s)
# APK en: android/app/build/outputs/apk/debug/app-debug.apk
```

### iOS:
```bash
npm run build
npm run cap:sync
cd ios/App && pod install && cd ../..
npm run cap:open:ios
# Luego en Xcode: Presiona Play (▶️)
```

## ❓ ¿Por qué no hay APK todavía?

Las APK y apps de iOS son **archivos compilados nativos** que requieren:
- **Android**: Android SDK, Gradle, y compilación del código Java/Kotlin
- **iOS**: Xcode, compilación del código Swift/Objective-C

No se pueden generar automáticamente desde la línea de comandos sin estas herramientas instaladas y configuradas.

## 💡 Alternativas

Si no tienes Android Studio o Xcode instalados:

1. **Android**: Puedes usar servicios en la nube como:
   - [AppCenter](https://appcenter.ms)
   - [Bitrise](https://www.bitrise.io)
   - O instalar Android Studio (gratis)

2. **iOS**: Necesitas macOS y Xcode (solo disponible en Mac)

## 📚 Más información

- Ver `BUILD_APK.md` para instrucciones detalladas de Android
- Ver `BUILD_IOS.md` para instrucciones detalladas de iOS

