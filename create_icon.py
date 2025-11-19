#!/usr/bin/env python3
"""
Script para crear iconos de calculadora para Android
Genera todos los tamaños necesarios para diferentes densidades
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    import os
    import sys
except ImportError:
    print("Error: Necesitas instalar Pillow: pip3 install Pillow")
    sys.exit(1)

# Tamaños de iconos para diferentes densidades (en píxeles)
ICON_SIZES = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

def create_calculator_icon(size):
    """Crea un icono de calculadora del tamaño especificado"""
    # Crear imagen con fondo transparente
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Colores: fondo oscuro, botones naranjas, números blancos
    bg_color = (45, 45, 45, 255)  # Fondo gris oscuro
    button_color = (255, 149, 0, 255)  # Naranja para operadores
    number_color = (255, 255, 255, 255)  # Blanco para números
    border_color = (100, 100, 100, 255)  # Borde gris
    
    # Dibujar fondo redondeado
    margin = size // 10
    draw.rounded_rectangle(
        [margin, margin, size - margin, size - margin],
        radius=size // 6,
        fill=bg_color,
        outline=border_color,
        width=max(1, size // 48)
    )
    
    # Dibujar pantalla de calculadora (rectángulo en la parte superior)
    screen_margin = size // 8
    screen_height = size // 3
    draw.rounded_rectangle(
        [screen_margin * 2, screen_margin * 2, size - screen_margin * 2, screen_margin * 2 + screen_height],
        radius=size // 20,
        fill=(26, 26, 26, 255),
        outline=(150, 150, 150, 255),
        width=max(1, size // 64)
    )
    
    # Dibujar números en la pantalla (simplificado)
    if size >= 48:
        try:
            # Intentar usar una fuente del sistema
            font_size = size // 6
            try:
                font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", font_size)
            except:
                try:
                    font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
                except:
                    font = ImageFont.load_default()
        except:
            font = ImageFont.load_default()
        
        # Dibujar "123" en la pantalla
        text = "123"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        text_x = (size - text_width) // 2
        text_y = screen_margin * 2 + (screen_height - text_height) // 2
        draw.text((text_x, text_y), text, fill=number_color, font=font)
    
    # Dibujar botones (círculos pequeños)
    button_size = size // 8
    button_spacing = size // 5
    
    # Fila de botones
    start_y = size - size // 3
    for i in range(3):
        x = size // 4 + i * button_spacing
        y = start_y
        draw.ellipse(
            [x - button_size, y - button_size, x + button_size, y + button_size],
            fill=button_color if i == 1 else (74, 74, 74, 255),
            outline=border_color,
            width=max(1, size // 96)
        )
    
    # Dibujar símbolo "+" en el botón central
    if size >= 48:
        try:
            plus_font_size = size // 10
            try:
                plus_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", plus_font_size)
            except:
                plus_font = ImageFont.load_default()
        except:
            plus_font = ImageFont.load_default()
        
        plus_text = "+"
        bbox = draw.textbbox((0, 0), plus_text, font=plus_font)
        plus_width = bbox[2] - bbox[0]
        plus_height = bbox[3] - bbox[1]
        plus_x = size // 4 + button_spacing - plus_width // 2
        plus_y = start_y - plus_height // 2
        draw.text((plus_x, plus_y), plus_text, fill=number_color, font=plus_font)
    
    return img

def main():
    base_dir = "android/app/src/main/res"
    
    print("🎨 Creando iconos de calculadora para Android...")
    
    for density, size in ICON_SIZES.items():
        density_dir = os.path.join(base_dir, density)
        os.makedirs(density_dir, exist_ok=True)
        
        # Crear icono
        icon = create_calculator_icon(size)
        
        # Guardar como foreground (sin fondo)
        foreground_path = os.path.join(density_dir, "ic_launcher_foreground.png")
        icon.save(foreground_path, "PNG")
        print(f"✅ Creado: {foreground_path} ({size}x{size})")
        
        # Crear icono completo (con fondo)
        icon_with_bg = Image.new('RGBA', (size, size), (45, 45, 45, 255))
        icon_with_bg.paste(icon, (0, 0), icon)
        
        # Guardar como launcher completo
        launcher_path = os.path.join(density_dir, "ic_launcher.png")
        icon_with_bg.save(launcher_path, "PNG")
        print(f"✅ Creado: {launcher_path} ({size}x{size})")
        
        # Guardar como launcher redondo
        round_path = os.path.join(density_dir, "ic_launcher_round.png")
        icon_with_bg.save(round_path, "PNG")
        print(f"✅ Creado: {round_path} ({size}x{size})")
    
    print("\n✨ ¡Iconos creados exitosamente!")
    print("📱 Los iconos están listos para usar en la app Android")

if __name__ == "__main__":
    main()

