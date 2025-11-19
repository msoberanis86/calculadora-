# 📦 Información del Repositorio

## Estado Actual

- ✅ **Repositorio Git**: Inicializado
- ❌ **Remote GitHub**: No configurado
- 📍 **Rama actual**: `main`
- 📝 **Último commit**: "calucadora + primera version"

## Configuración Actual

El repositorio está en: `/var/www/html/cal`

**No hay un repositorio remoto de GitHub configurado actualmente.**

## Para Configurar GitHub

Si quieres subir el código a GitHub, necesitas:

### 1. Crear un repositorio en GitHub

1. Ve a [GitHub](https://github.com)
2. Crea un nuevo repositorio (público o privado)
3. **NO** inicialices con README, .gitignore o licencia (ya tienes código)

### 2. Conectar el repositorio local con GitHub

```bash
# Agregar el remote (reemplaza USERNAME y REPO_NAME)
git remote add origin https://github.com/USERNAME/REPO_NAME.git

# O usando SSH
git remote add origin git@github.com:USERNAME/REPO_NAME.git
```

### 3. Subir el código

```bash
# Verificar que todo esté commiteado
git status

# Si hay cambios, agregarlos
git add .
git commit -m "Actualización: calculadora con números grandes y optimización móvil"

# Subir a GitHub
git push -u origin main
```

## Archivos que NO se deben subir

Asegúrate de tener un `.gitignore` que excluya:

```
node_modules/
dist/
android/app/build/
ios/App/build/
*.keystore
*.apk
.DS_Store
.env
```

## Estructura del Proyecto

```
cal/
├── src/              # Código fuente
├── apk/              # APKs compiladas (no subir)
├── android/          # Proyecto Android (sí subir)
├── ios/              # Proyecto iOS (sí subir)
├── dist/             # Build web (no subir)
└── node_modules/     # Dependencias (no subir)
```

## Nota

Actualmente el código **NO se está subiendo automáticamente** a ningún repositorio. Solo está en el repositorio local.

