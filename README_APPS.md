# Calculadora + - Aplicaciones Móviles

Esta calculadora avanzada está lista para ser convertida en aplicaciones nativas para Android e iOS/iPad.

## 📱 Plataformas Soportadas

- ✅ **Android** (APK)
- ✅ **iOS** (iPhone)
- ✅ **iPad**

## 🚀 Inicio Rápido

### Para Android:
1. Lee [BUILD_APK.md](./BUILD_APK.md) para instrucciones detalladas
2. Ejecuta: `npm run build && npm run cap:sync`
3. Abre en Android Studio: `npm run cap:open:android`
4. Genera el APK desde Android Studio

### Para iOS/iPad:
1. Lee [BUILD_IOS.md](./BUILD_IOS.md) para instrucciones detalladas
2. Ejecuta: `npm run build && npm run cap:sync`
3. Instala dependencias: `cd ios/App && pod install`
4. Abre en Xcode: `npm run cap:open:ios`
5. Compila y ejecuta desde Xcode

## 📦 Información de la App

- **Nombre**: Calculadora +
- **Package ID / Bundle ID**: com.calculadora.plus
- **Versión**: 1.0.0
- **Versión de Código**: 1

## 🎨 Características

- ✅ Calculadora avanzada con operaciones matemáticas
- ✅ Historial reutilizable de resultados
- ✅ Soporte para paréntesis y orden de operaciones
- ✅ Cálculo automático al presionar operadores
- ✅ Tema claro/oscuro
- ✅ Formato numérico para Guatemala (punto decimal, coma para miles)
- ✅ Soporte de teclado físico
- ✅ Diseño Mobile-First y responsive
- ✅ Optimizado para pantalla completa en móviles

## 🔧 Comandos Útiles

```bash
# Construir la app web
npm run build

# Sincronizar con plataformas nativas
npm run cap:sync

# Abrir en Android Studio
npm run cap:open:android

# Abrir en Xcode
npm run cap:open:ios
```

## 📝 Notas Importantes

- **Android**: Necesitas Android Studio y Java JDK
- **iOS**: Necesitas macOS, Xcode y una cuenta de desarrollador de Apple
- El icono de la app necesita ser personalizado (actualmente usa el icono por defecto)
- Para publicar en las tiendas, necesitarás configurar certificados y perfiles de aprovisionamiento

## 🎯 Próximos Pasos

1. Personalizar el icono de la app (crear iconos en diferentes tamaños)
2. Configurar splash screen personalizado
3. Generar APK/IPA para pruebas
4. Configurar certificados para publicación
5. Subir a Google Play Store / App Store

