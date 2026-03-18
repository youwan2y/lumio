#!/usr/bin/env python3
"""
Lumio App Icon Generator
生成 1024x1024 的应用图标
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math

def create_lumio_icon():
    # 创建 1024x1024 的画布
    size = 1024
    img = Image.new('RGB', (size, size), (0, 0, 0))
    draw = ImageDraw.Draw(img)

    # 渐变背景 - 蓝紫色系
    for y in range(size):
        # 从深蓝到紫色的渐变
        r = int(75 + (138 - 75) * y / size)
        g = int(0 + (43 - 0) * y / size)
        b = int(130 + (226 - 130) * y / size)
        draw.line([(0, y), (size, y)], fill=(r, g, b))

    # 添加光晕效果
    center_x, center_y = size // 2, size // 2

    # 绘制多层光圈
    for i in range(8):
        radius = 250 + i * 30
        opacity = 255 - i * 30
        # 创建带透明度的图层
        glow_layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        glow_draw = ImageDraw.Draw(glow_layer)

        # 绘制渐变光圈
        for r in range(radius, radius - 50, -5):
            alpha = int(opacity * (radius - r) / 50)
            glow_draw.ellipse(
                [center_x - r, center_y - r, center_x + r, center_y + r],
                outline=(255, 255, 255, alpha),
                width=3
            )

        # 合并图层
        img.paste(Image.alpha_composite(img.convert('RGBA'), glow_layer).convert('RGB'))

    # 绘制中心光球
    core_radius = 120
    for i in range(100):
        radius = core_radius - i
        if radius > 0:
            alpha = int(255 * (1 - i / 100))
            # 渐变白色到淡黄色
            color = (255, 255, int(200 + 55 * i / 100))
            draw.ellipse(
                [center_x - radius, center_y - radius, center_x + radius, center_y + radius],
                fill=color,
                outline=None
            )

    # 绘制光芒射线
    num_rays = 12
    for i in range(num_rays):
        angle = (2 * math.pi * i / num_rays) - math.pi / 2
        # 射线起点和终点
        inner_radius = 140
        outer_radius = 350

        x1 = center_x + inner_radius * math.cos(angle)
        y1 = center_y + inner_radius * math.sin(angle)
        x2 = center_x + outer_radius * math.cos(angle)
        y2 = center_y + outer_radius * math.sin(angle)

        # 绘制渐变射线
        for j in range(30):
            alpha = int(150 * (1 - j / 30))
            offset = j * 0.5
            draw.line(
                [(x1, y1), (x2, y2)],
                fill=(255, 255, 255, alpha),
                width=8 - j // 5
            )

    # 绘制装饰圆环
    ring_radius = 400
    draw.ellipse(
        [center_x - ring_radius, center_y - ring_radius,
         center_x + ring_radius, center_y + ring_radius],
        outline=(255, 255, 255, 100),
        width=2
    )

    # 添加文字 "L"
    try:
        # 尝试使用系统字体
        font_size = 300
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
    except:
        # 如果找不到字体，使用默认字体
        font = ImageFont.load_default()

    # 绘制字母 L
    text = "L"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    text_x = center_x - text_width // 2
    text_y = center_y - text_height // 2 - 50

    # 文字阴影
    shadow_offset = 8
    draw.text((text_x + shadow_offset, text_y + shadow_offset), text,
              fill=(0, 0, 0, 128), font=font)

    # 文字主体
    draw.text((text_x, text_y), text, fill=(255, 255, 255), font=font)

    # 应用模糊效果让边缘更柔和
    img = img.filter(ImageFilter.SMOOTH)

    # 保存图标
    output_path = 'AppIcon_1024x1024.png'
    img.save(output_path, 'PNG', quality=95)
    print(f"✅ 应用图标已生成: {output_path}")

    return output_path

if __name__ == '__main__':
    print("🎨 开始生成 Lumio 应用图标...")
    create_lumio_icon()
    print("🎉 完成！")
