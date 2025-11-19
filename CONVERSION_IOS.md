# Guía de Conversión a iOS Nativa

Esta aplicación web está preparada para convertirse en una aplicación iOS nativa usando React Native.

## Estructura Actual

La aplicación está organizada de manera que facilita la conversión:

- **Componentes**: Separados y reutilizables (`Calculator.tsx`, `HistoryItem.tsx`)
- **Lógica de negocio**: En utilidades independientes (`mathEvaluator.ts`)
- **Estilos**: Usando variables CSS que pueden mapearse a StyleSheet

## Pasos para Conversión a React Native

### 1. Instalar React Native

```bash
npx react-native init CalculadoraAvanzada --template react-native-template-typescript
```

### 2. Migrar Componentes

- Reemplazar elementos HTML (`<div>`, `<button>`) por componentes de React Native:
  - `View` en lugar de `div`
  - `TouchableOpacity` o `Pressable` en lugar de `button`
  - `Text` en lugar de `span`

### 3. Migrar Estilos

- Convertir CSS a `StyleSheet.create()`
- Las variables CSS pueden convertirse en constantes de JavaScript
- Usar `Dimensions` para responsive design

### 4. Adaptaciones Específicas

- **Historial scroll**: Usar `ScrollView` con `horizontal={true}`
- **Grid de botones**: Usar `View` con `flexDirection: 'row'` y `flexWrap: 'wrap'`
- **Feedback táctil**: Usar `TouchableOpacity` con `activeOpacity`

### 5. Gestos

- Implementar `PanResponder` o `react-native-gesture-handler` para swipe

## Ejemplo de Conversión

### Web (actual)
```tsx
<button className="btn btn-number" onClick={handleNumber}>1</button>
```

### React Native
```tsx
<TouchableOpacity style={styles.btnNumber} onPress={handleNumber}>
  <Text style={styles.btnText}>1</Text>
</TouchableOpacity>
```

## Dependencias Necesarias

- `react-native`: Framework base
- `react-native-gesture-handler`: Para gestos avanzados
- `mathjs`: Ya está en uso (compatible con RN)

## App Store

Para publicar en App Store:
1. Configurar certificados y provisioning profiles
2. Configurar `Info.plist` con permisos necesarios
3. Build con Xcode
4. Subir a App Store Connect

