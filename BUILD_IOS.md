# Guía para Generar App iOS/iPad

## Requisitos Previos

1. **macOS** (necesario para desarrollar apps iOS)
2. **Xcode** instalado (versión 14 o superior)
3. **CocoaPods** instalado
4. **Cuenta de Desarrollador de Apple** (gratuita para desarrollo, $99/año para App Store)

## Instalación de CocoaPods

Si no tienes CocoaPods instalado:

```bash
sudo gem install cocoapods
```

## Pasos para Generar la App iOS

### 1. Construir la aplicación web

```bash
npm run build
```

### 2. Sincronizar con Capacitor

```bash
npm run cap:sync
```

### 3. Instalar dependencias de iOS

```bash
cd ios/App
pod install
cd ../..
```

### 4. Abrir en Xcode

```bash
npm run cap:open:ios
```

O manualmente:
- Abre Xcode
- Selecciona "Open a project or file"
- Navega a la carpeta `ios/App/App.xcworkspace` (importante: abre el `.xcworkspace`, no el `.xcodeproj`)

### 5. Configurar el Proyecto en Xcode

1. En Xcode, selecciona el proyecto "App" en el navegador izquierdo
2. Selecciona el target "App"
3. Ve a la pestaña **"Signing & Capabilities"**
4. Selecciona tu **Team** (tu cuenta de desarrollador de Apple)
5. Xcode generará automáticamente un perfil de aprovisionamiento

### 6. Configurar el Icono de la App

1. En Xcode, ve a: **Assets.xcassets > AppIcon**
2. Arrastra tus iconos en los tamaños requeridos:
   - 20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5, 1024x1024
3. O usa un generador de iconos online que cree todos los tamaños

### 7. Ejecutar en Simulador (para pruebas)

1. Selecciona un simulador en la barra superior (ej: iPhone 14, iPad Pro)
2. Haz clic en el botón **Play** (▶️) o presiona `Cmd + R`
3. La app se compilará y ejecutará en el simulador

### 8. Ejecutar en Dispositivo Real

1. Conecta tu iPhone/iPad a tu Mac con un cable USB
2. En Xcode, selecciona tu dispositivo en la barra superior
3. Si es la primera vez, confía en la computadora en tu dispositivo iOS
4. Haz clic en el botón **Play** (▶️)
5. En tu dispositivo, ve a: **Configuración > General > Gestión de Dispositivos**
6. Confía en tu certificado de desarrollador

### 9. Generar IPA para App Store

1. En Xcode, selecciona: **Product > Archive**
2. Espera a que termine el proceso
3. Se abrirá el **Organizer**
4. Selecciona tu archivo y haz clic en **"Distribute App"**
5. Selecciona **"App Store Connect"**
6. Sigue las instrucciones para subir a App Store Connect

### 10. Generar IPA para TestFlight o Distribución Ad Hoc

1. Sigue los pasos 1-3 del punto anterior
2. En "Distribute App", selecciona **"Ad Hoc"** o **"Enterprise"**
3. Selecciona los dispositivos o perfiles de aprovisionamiento
4. Exporta el IPA

## Información de la App

- **Nombre**: Calculadora +
- **Bundle ID**: com.calculadora.plus
- **Versión**: 1.0.0
- **Build**: 1

## Configuración para iPad

La app ya está configurada para funcionar en iPhone e iPad. Para optimizar para iPad:

1. En Xcode, selecciona el proyecto
2. Ve a **General > Deployment Info**
3. Asegúrate de que **iPad** esté seleccionado en "Supported Destinations"
4. Configura **Device Orientation** según tus necesidades

## Publicar en App Store

1. Crea una cuenta en [App Store Connect](https://appstoreconnect.apple.com)
2. Crea una nueva app con el Bundle ID: `com.calculadora.plus`
3. Completa la información de la app (descripción, screenshots, etc.)
4. Sube el IPA usando Xcode Organizer o Transporter
5. Envía la app para revisión

## Solución de Problemas

### Error: "No such module 'Capacitor'"
```bash
cd ios/App
pod install
cd ../..
```

### Error: "Signing for 'App' requires a development team"
- Ve a **Signing & Capabilities** en Xcode
- Selecciona tu Team de desarrollador
- Si no tienes uno, crea una cuenta gratuita en [developer.apple.com](https://developer.apple.com)

### Error: "Could not find module 'Capacitor'"
- Asegúrate de abrir el `.xcworkspace`, no el `.xcodeproj`
- Ejecuta `pod install` nuevamente

### La app no se instala en el dispositivo
- Verifica que el Bundle ID coincida con tu perfil de aprovisionamiento
- Asegúrate de que tu dispositivo esté registrado en tu cuenta de desarrollador
- Revisa los certificados en **Keychain Access**

