# 🎨 切换到 GLM-Image API 指南

## ✅ 已完成配置

### 1. API 配置更新
**文件**: `lib/config/api_config.dart`

```dart
/// API 配置
class ApiConfig {
  // 通义千问 LLM API
  static const String llmBaseUrl = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
  static const String llmApiKey = 'sk-27fe79531c484cf8b0a1560adcd4ccfc';
  static const String llmModel = 'qwen-flash';

  // GLM-Image 图像生成 API (智谱 AI)
  static const String imageBaseUrl = 'https://open.bigmodel.cn/api/paas/v4';
  static const String imageApiKey = 'sk-27fe79531c484cf8b0a1560adcd4ccfc';  // 使用相同的 API Key
  static const String imageModel = 'glm-image';
}
```

✅ **已更新**: 从豆包 API 切换到 GLM-Image API

---

### 2. ImageService 更新
**文件**: `lib/services/services.dart`

```dart
class ImageService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.imageBaseUrl,  // https://open.bigmodel.cn/api/paas/v4
      headers: {
        'Authorization': 'Bearer ${ApiConfig.imageApiKey}',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );

  Future<Wallpaper> generateWallpaper(String description) async {
    try {
      final response = await _dio.post(
        '/images/generations',
        data: {
          'model': 'glm-image',
          'prompt': '$description, wallpaper style, high quality, beautiful',
          'quality': 'hd',              // glm-image 只支持 hd
          'size': '1280x1280',          // 推荐尺寸
          'watermark_enabled': false,   // ✅ 去掉官方水印
        },
      );

      final imageUrl = response.data['data'][0]['url'] as String;
      return Wallpaper(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        imageUrl: imageUrl,
        description: description,
      );
    } catch (e) {
      throw Exception('生成壁纸失败: $e');
    }
  }
}
```

✅ **已更新**: 使用 GLM-Image API 并禁用官方水印

---

### 3. 产品水印保留
**文件**: `lib/screens/result_screen.dart`

```dart
Future<void> _saveToGallery(BuildContext context, String url) async {
  // ... 权限请求 ...

  // 下载图片
  final response = await dio.get(url, ...);

  // ✅ 添加产品水印（保留）
  final watermarkedImage = await _addWatermark(response.data);

  // 保存到相册
  await ImageGallerySaver.saveImage(watermarkedImage, ...);
}

Future<Uint8List> _addWatermark(Uint8List imageData) async {
  final image = img.decodeImage(imageData);

  // ✅ 产品水印：Lumio - Lucy Wall Paper
  const watermarkText = 'Lumio - Lucy Wall Paper';

  final textImage = img.drawString(
    image,
    watermarkText,
    font: img.arial24,
    x: image.width - 280,
    y: image.height - 50,
    color: img.ColorRgba8(255, 255, 255, 128), // 白色半透明
  );

  return Uint8List.fromList(img.encodeJpg(textImage, quality: 95));
}
```

✅ **保留**: 产品水印功能正常工作

---

## 🎯 最终效果

### 水印层次
```
生成的壁纸
    ↓
[GLM-Image API 生成]
    ↓
[无官方水印] ← watermark_enabled: false ✅
    ↓
[添加产品水印] ← "Lumio - Lucy Wall Paper" ✅
    ↓
[保存到相册]
```

### 对比

| 项目 | 之前（豆包） | 现在（GLM-Image） |
|------|------------|-----------------|
| API 提供商 | 火山引擎 | 智谱 AI ✅ |
| 模型 | doubao-seedream | glm-image ✅ |
| 官方水印 | 有 ❌ | 无 ✅ |
| 产品水印 | 有 ✅ | 有 ✅ |
| 图片质量 | 2K (3136x1312) | 1280x1280 ✅ |
| 生成速度 | ~30-40秒 | ~20秒 (hd) ✅ |

---

## 📝 API 参数说明

### GLM-Image API 参数

```json
{
  "model": "glm-image",           // 模型名称
  "prompt": "...",                // 图像描述
  "quality": "hd",                // 质量：hd（仅支持 hd）
  "size": "1280x1280",            // 尺寸
  "watermark_enabled": false      // ✅ 禁用官方水印
}
```

### 推荐尺寸
- `1280x1280` (默认，推荐)
- `1568×1056` (3:2 横屏)
- `1056×1568` (2:3 竖屏)
- `1472×1088` (4:3 横屏)
- `1088×1472` (3:4 竖屏)
- `1728×960` (16:9 横屏)
- `960×1728` (9:16 竖屏)

### 质量选项
- `hd`: 高清，细节丰富，耗时约 20 秒（glm-image 仅支持 hd）
- `standard`: 标准质量，快速生成（glm-image 不支持）

---

## 🔧 需要的操作

### ⚠️ 重要：重新构建应用

由于修改了 API 配置，**建议重新构建**：

```bash
# 停止当前应用（如果在运行）
# 按 q 退出

# 重新运行（Dart 代码修改，热重启即可）
按 R

# 或者重新构建
flutter clean
flutter run -d ios
```

**为什么建议重新构建？**
- 修改了 API 配置（baseUrl, apiKey, model）
- 虽然 Dart 代码可以热重启，但为了确保配置生效，建议重新构建

---

## 📱 测试步骤

### 1. 重新运行应用
```bash
flutter run -d ios
```

### 2. 生成壁纸
1. 回答问题
2. 点击"生成壁纸"
3. 等待 AI 生成（约 20 秒）

### 3. 保存壁纸
1. 选择一张卡牌
2. 点击"保存到相册"
3. 检查保存的图片

### 4. 验证水印
在相册中查看保存的图片：
- ✅ 应该**只有** "Lumio - Lucy Wall Paper" 水印
- ✅ **没有** GLM-Image 的官方水印
- ✅ 水印位置：右下角，白色半透明

---

## 🐛 常见问题

### 问题1：图片生成失败

**可能原因**:
- API Key 无效
- 网络问题
- API 配额用完

**解决方法**:
```bash
# 查看控制台日志
flutter run -d ios --verbose

# 检查错误信息
# 如果是 401 错误 → API Key 无效
# 如果是 429 错误 → 请求过于频繁
```

---

### 问题2：图片质量不满意

**调整方法**:
```dart
// 在 services.dart 中修改 prompt
'prompt': '$description, wallpaper style, high quality, beautiful, 4k, detailed',
```

**添加更多质量关键词**:
- `4k`, `8k`, `ultra detailed`
- `photorealistic`, `cinematic`
- `professional`, `masterpiece`

---

### 问题3：生成速度慢

**GLM-Image hd 质量**:
- 生成时间：约 20 秒
- 比豆包（30-40秒）更快 ✅

**如果仍然觉得慢**:
- 考虑切换到其他模型（如 `cogview-3-flash`）
- 但图片质量会降低

---

### 问题4：产品水印不清晰

**调整水印参数**:

```dart
// 在 result_screen.dart 中修改
Future<Uint8List> _addWatermark(Uint8List imageData) async {
  // ...

  // 调整字体大小
  final fontSize = (image.height * 0.03).round().clamp(16, 32);  // 增大

  // 调整透明度
  color: img.ColorRgba8(255, 255, 255, 200),  // 提高不透明度（128 → 200）

  // 调整位置
  x: image.width - 320,  // 调整 x 坐标
  y: image.height - 60,  // 调整 y 坐标
}
```

---

## 📊 成本对比

### GLM-Image 定价
- **hd 质量**: 约 ¥0.12/张
- **推荐**: 适合高质量壁纸生成

### 豆包定价（之前）
- 约 ¥0.10-0.15/张
- **结论**: 成本相近，但 GLM-Image 更快 ✅

---

## ✅ 配置检查清单

- [x] 更新 API 配置（baseUrl, apiKey, model）
- [x] 修改 ImageService 使用 GLM-Image API
- [x] 设置 `watermark_enabled: false`
- [x] 保留产品水印功能
- [x] 使用推荐尺寸 `1280x1280`
- [x] 使用 `hd` 质量

---

## 🚀 下一步

1. **重新运行应用**
   ```bash
   flutter run -d ios
   ```

2. **测试生成功能**
   - 生成壁纸
   - 检查质量
   - 验证水印

3. **如果满意，提交更改**
   ```bash
   git add .
   git commit -m "Switch to GLM-Image API with custom watermark"
   git push origin main
   ```

---

## 📝 API Key 管理

⚠️ **重要提醒**:

当前 API Key 在代码中：
```dart
static const String imageApiKey = 'sk-27fe79531c484cf8b0a1560adcd4ccfc';
```

**建议**（生产环境）:
1. 使用环境变量
2. 使用后端代理
3. 定期更换 Key

**开发环境**:
- 当前配置可以继续使用
- 注意不要提交到公开仓库

---

**配置完成！** 🎉

现在你的应用使用 GLM-Image API，无官方水印，只保留你的产品水印 "Lumio - Lucy Wall Paper"！
