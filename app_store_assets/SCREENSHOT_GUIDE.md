# Nivolune App Store 截图指南

## 📸 截图要求

### 必需尺寸
1. **6.5 英寸**（iPhone 14 Pro Max / 15 Pro Max）
   - 尺寸: 2778 x 1284 px
   - 比例: 19.5:9
   - 设备: iPhone 14 Pro Max, iPhone 15 Pro Max, iPhone 17 Pro

2. **5.5 英寸**（iPhone 8 Plus）
   - 尺寸: 2208 x 1242 px
   - 比例: 16:9
   - 设备: iPhone 8 Plus, iPhone 7 Plus, iPhone 6s Plus

---

## 🎯 推荐截图场景（5张）

### 1. 启动页
**内容**: 应用 Logo 和"开始探索"按钮
**目的**: 展示品牌调性，吸引用户

**截图步骤**:
1. 启动应用
2. 等待启动页完全加载
3. 按下截图快捷键
   - iOS 模拟器: `Cmd + S`
   - 真机: `电源键 + 音量+`

**要点**:
- ✅ Logo 居中清晰
- ✅ 按钮完全可见
- ✅ 背景渐变完整

---

### 2. 问题页面 - 心情选择
**内容**: 心情滑块选择界面
**目的**: 展示个性化交互

**截图步骤**:
1. 点击"开始探索"
2. 首次使用：输入星座和年龄，点击保存
3. 进入第一个问题页面（心情选择）
4. 调整滑块到中间位置
5. 截图

**要点**:
- ✅ 滑块清晰可见
- ✅ 问题标题完整
- ✅ 进度指示器（1/3）

---

### 3. 问题页面 - 能量选择
**内容**: 能量滑块选择界面
**目的**: 展示多样化选项

**截图步骤**:
1. 点击"下一步"
2. 进入第二个问题页面（能量选择）
3. 调整滑块到合适位置
4. 截图

**要点**:
- ✅ 与第一张保持一致性
- ✅ 进度指示器（2/3）
- ✅ 返回按钮可见

---

### 4. 卡牌页面
**内容**: 9 张卡牌网格布局
**目的**: 展示核心功能 - 卡牌翻转

**截图步骤**:
1. 完成所有 3 个问题
2. 点击"生成我的壁纸"
3. 等待加载完成（约 1 分钟）
4. 进入卡牌页面
5. 点击中间的卡牌翻转
6. 截图

**要点**:
- ✅ 9 张卡牌完整可见
- ✅ 至少一张卡牌翻转显示壁纸
- ✅ 卡牌阴影和 3D 效果

---

### 5. 结果页面
**内容**: 高清壁纸 + 保存按钮
**目的**: 展示最终成果

**截图步骤**:
1. 点击翻转后的卡牌
2. 进入结果页面
3. 等待壁纸完全加载
4. 截图

**要点**:
- ✅ 壁纸高清完整
- ✅ 保存按钮清晰
- ✅ 水印可见（右下角）

---

## 🔧 截图方法

### 方法 1: iOS 模拟器截图（推荐）

1. **启动模拟器**
   ```bash
   flutter run -d <device_id>
   ```

2. **截图**
   - 快捷键: `Cmd + S`
   - 保存位置: 桌面

3. **获取设备 ID**
   ```bash
   flutter devices
   ```

---

### 方法 2: 命令行截图

```bash
# 截取当前模拟器屏幕
xcrun simctl io booted screenshot screenshot_1.png

# 截取所有设备
xcrun simctl io <device_id> screenshot screenshot_1.png
```

---

### 方法 3: 真机截图

1. **连接 iPhone**
2. **运行应用**
   ```bash
   flutter run -d <device_id>
   ```
3. **截图**: 同时按下电源键和音量+键
4. **导出**: 在 Photos 应用中导出

---

## 📐 截图尺寸调整

如果需要调整截图尺寸，可以使用以下工具：

### 使用 ImageMagick（命令行）

```bash
# 安装 ImageMagick
brew install imagemagick

# 调整尺寸到 2778x1284
convert original.png -resize 2778x1284 screenshot_6.5inch.png

# 调整尺寸到 2208x1242
convert original.png -resize 2208x1242 screenshot_5.5inch.png
```

### 使用 Python PIL

```python
from PIL import Image

img = Image.open('original.png')
# 调整到 6.5 英寸
img_65 = img.resize((2778, 1284), Image.LANCZOS)
img_65.save('screenshot_6.5inch.png')

# 调整到 5.5 英寸
img_55 = img.resize((2208, 1242), Image.LANCZOS)
img_55.save('screenshot_5.5inch.png')
```

### 使用在线工具
- [ResizeImage.net](https://resizeimage.net/)
- [ILoveIMG](https://www.iloveimg.com/resize-image)

---

## 🎨 截图美化（可选）

### 添加设备边框

使用在线工具添加设备边框：
- [MockUPhone](https://mockuphone.com/)
- [Device Shots](https://deviceshots.com/)
- [Screenpeek](https://screenpeek.io/)

### 添加文字说明

在截图上方或下方添加功能说明：
- 使用 Figma / Sketch / Photoshop
- 文字简洁明了
- 字体大小适中（60-80px）
- 颜色与品牌一致

---

## 📝 截图命名规范

建议使用以下命名规范：

```
Nivolune_Screenshot_1_Launch_6.5inch_2778x1284.png
Nivolune_Screenshot_2_Mood_6.5inch_2778x1284.png
Nivolune_Screenshot_3_Energy_6.5inch_2778x1284.png
Nivolune_Screenshot_4_Cards_6.5inch_2778x1284.png
Nivolune_Screenshot_5_Result_6.5inch_2778x1284.png

Nivolune_Screenshot_1_Launch_5.5inch_2208x1242.png
Nivolune_Screenshot_2_Mood_5.5inch_2208x1242.png
Nivolune_Screenshot_3_Energy_5.5inch_2208x1242.png
Nivolune_Screenshot_4_Cards_5.5inch_2208x1242.png
Nivolune_Screenshot_5_Result_5.5inch_2208x1242.png
```

---

## ✅ 截图检查清单

### 技术要求
- [ ] 尺寸正确（2778x1284 和 2208x1242）
- [ ] 格式为 PNG 或 JPEG
- [ ] 文件大小 < 5MB
- [ ] 无状态栏干扰
- [ ] 无调试信息

### 内容要求
- [ ] 5 张必需截图
- [ ] 每张截图展示不同功能
- [ ] 画面清晰无模糊
- [ ] 颜色准确无偏色
- [ ] 文字清晰可读

### 美观要求
- [ ] 界面整洁无杂乱
- [ ] 内容居中对称
- [ ] 渐变和动画完整
- [ ] 品牌元素一致

---

## 🚀 快速截图脚本

创建自动化截图脚本（需要应用运行中）：

```bash
#!/bin/bash
# screenshot.sh

echo "📸 开始截图..."

# 截取 5 个界面
for i in {1..5}; do
    echo "请切换到第 $i 个界面，然后按回车继续..."
    read
    xcrun simctl io booted screenshot "Nivolune_Screenshot_$i.png"
    echo "✅ 第 $i 张截图完成"
done

echo "🎉 所有截图完成！"
```

使用方法：
```bash
chmod +x screenshot.sh
./screenshot.sh
```

---

## 📊 当前应用已运行

✅ 应用已在 iPhone 17 Pro 模拟器上运行
✅ 可以开始截图

### 立即截图

**在模拟器中按下 `Cmd + S` 开始截图！**

---

## 💡 截图最佳实践

1. **展示核心功能**
   - 不要只截菜单和设置
   - 展示实际的壁纸生成流程

2. **使用真实内容**
   - 不要使用占位符
   - 使用实际生成的壁纸

3. **保持一致性**
   - 所有截图使用相同的设计风格
   - 颜色、字体、布局保持一致

4. **突出差异化**
   - 强调 AI 生成特色
   - 展示卡牌翻转独特体验

5. **第一张最重要**
   - 第一张截图决定用户是否下载
   - 选择最吸引人的界面（卡牌页面）

---

## 🎯 下一步

1. ✅ 按照指南截取 5 张关键界面
2. ✅ 调整尺寸到 6.5 英寸和 5.5 英寸
3. ✅ 重命名文件
4. ✅ 上传到 App Store Connect

---

**截图是用户的第一印象，请务必精心制作！**

生成日期：2026-03-18
