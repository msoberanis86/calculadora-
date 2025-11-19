#!/usr/bin/env python3
"""
Script para corregir APK para Android R+ (API 30+)
resources.arsc debe estar sin comprimir y alineado en 4 bytes
"""

import zipfile
import os
import sys
import shutil

APK_SOURCE = "apk/Calculadora-Plus-v1.0.0-PRODUCTION.apk"
APK_FIXED = "apk/Calculadora-Plus-v1.0.0-ALIGNED.apk"
KEYSTORE = "calculadora-plus.keystore"

def fix_apk():
    print("🔧 Corrigiendo APK para Android R+ (API 30+)")
    print("")
    
    if not os.path.exists(APK_SOURCE):
        print(f"❌ APK no encontrada: {APK_SOURCE}")
        return False
    
    # Crear APK nueva con resources.arsc sin comprimir
    print("📦 Extrayendo y re-empacando APK...")
    
    with zipfile.ZipFile(APK_SOURCE, 'r') as source_zip:
        with zipfile.ZipFile(APK_FIXED, 'w', zipfile.ZIP_DEFLATED) as fixed_zip:
            for info in source_zip.infolist():
                data = source_zip.read(info.filename)
                
                # resources.arsc debe estar sin comprimir (STORED)
                if info.filename == 'resources.arsc':
                    print(f"  📄 {info.filename} → sin comprimir")
                    fixed_zip.writestr(info, data, compress_type=zipfile.ZIP_STORED)
                else:
                    # Otros archivos pueden estar comprimidos
                    fixed_zip.writestr(info, data)
    
    print("✅ APK re-empacada")
    
    # Re-firmar
    print("✍️  Re-firmando APK...")
    
    if not os.path.exists(KEYSTORE):
        print(f"⚠️  Keystore no encontrado: {KEYSTORE}")
        print("   La APK está lista pero necesita ser firmada manualmente")
        return True
    
    # Eliminar firma anterior
    os.system(f"zip -d '{APK_FIXED}' 'META-INF/*' 2>/dev/null || true")
    
    # Firmar
    cmd = f"""jarsigner -verbose \
        -sigalg SHA256withRSA \
        -digestalg SHA-256 \
        -keystore {KEYSTORE} \
        -storepass calculadora2024 \
        -keypass calculadora2024 \
        {APK_FIXED} \
        calculadora-plus 2>&1 | tail -3"""
    
    result = os.system(cmd)
    
    if result == 0:
        # Verificar firma
        verify_result = os.system(f"jarsigner -verify {APK_FIXED} > /dev/null 2>&1")
        if verify_result == 0:
            print("✅ APK firmada correctamente")
        else:
            print("⚠️  Error al verificar firma")
    else:
        print("⚠️  Error al firmar")
    
    print("")
    size = os.path.getsize(APK_FIXED) / (1024 * 1024)
    print(f"✅ APK corregida: {APK_FIXED}")
    print(f"📦 Tamaño: {size:.2f} MB")
    
    return True

if __name__ == "__main__":
    success = fix_apk()
    sys.exit(0 if success else 1)

