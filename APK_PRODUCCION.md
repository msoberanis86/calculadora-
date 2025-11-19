# ✅ APK de Producción - Calculadora +

## 📱 APK Lista para Producción

**Ubicación**: `apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk`

## ✨ Características Incluidas

- ✅ **Historial Persistente**: Se guarda automáticamente en el cache del dispositivo
- ✅ **Tema Persistente**: La preferencia de tema se guarda y restaura
- ✅ **Icono de Calculadora**: Icono personalizado en todos los tamaños
- ✅ **Nombre**: "Calculadora +"
- ✅ **Firmada**: APK firmada y lista para instalar
- ✅ **Safe Area**: Respeta la barra superior del celular
- ✅ **Formato Guatemala**: Punto para decimales, coma para miles

## 📦 Información Técnica

- **Nombre**: Calculadora +
- **Versión**: 1.0.0
- **Package ID**: com.calculadora.plus
- **Tamaño**: ~4 MB
- **Estado**: ✅ Firmada y lista para producción
- **Fecha de Compilación**: $(date)

## 🔐 Firma

- **Keystore**: calculadora-plus.keystore
- **Alias**: calculadora-plus
- **Algoritmo**: SHA256withRSA
- **Certificado**: Válido hasta 2053

⚠️ **IMPORTANTE**: Guarda el archivo `calculadora-plus.keystore` de forma segura. Lo necesitarás para futuras actualizaciones.

## 📲 Instalación

### Opción 1: Transferir Manualmente
1. Copia `apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk` a tu dispositivo Android
2. Abre el archivo en tu dispositivo
3. Permite la instalación desde "Fuentes desconocidas" si es necesario
4. Sigue las instrucciones para instalar

### Opción 2: Usar ADB
```bash
adb install apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk
```

## 🎯 Funcionalidades

### Historial Persistente
- El historial se guarda automáticamente cuando agregas un resultado
- El historial se restaura automáticamente al abrir la app
- Los datos se guardan en el almacenamiento nativo de Android
- El historial persiste aunque cierres la app

### Tema Persistente
- La preferencia de tema (claro/oscuro) se guarda
- El tema se restaura al abrir la app

### Calculadora Avanzada
- Operaciones matemáticas básicas (+, -, ×, ÷)
- Paréntesis y orden de operaciones
- Cálculo automático al presionar operadores
- Porcentajes
- Historial reutilizable
- Formato numérico para Guatemala

## 🔄 Actualizaciones Futuras

Para generar una nueva versión:

1. Actualiza el código
2. Ejecuta: `npm run build && npm run cap:sync`
3. Compila: `cd android && ./gradlew assembleDebug`
4. Firma: Usa el mismo keystore (`calculadora-plus.keystore`)
5. Actualiza el número de versión en `android/app/build.gradle`

## 📝 Notas

- Esta APK está lista para distribución
- Incluye todos los cambios más recientes
- El historial se guarda permanentemente
- El icono y nombre están correctamente configurados

