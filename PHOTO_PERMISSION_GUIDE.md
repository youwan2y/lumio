# 📸 相册权限配置完整指南

## ✅ 已完成配置

### iOS 配置
**文件**: `ios/Runner/Info.plist`

```xml
<!-- 添加到相册权限 -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>需要相册权限以保存壁纸</string>

<!-- 访问相册权限 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>需要相册权限以保存壁纸</string>
```

✅ **状态**: 已配置完成

---

### Android 配置
**文件**: `android/app/src/main/AndroidManifest.xml`

```xml
<!-- 写入外部存储（相册）权限 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- 读取外部存储权限 -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

✅ **状态**: 已配置完成

---

### Dart 代码
**文件**: `lib/screens/result_screen.dart`

```dart
Future<void> _saveToGallery(BuildContext context, String url) async {
  try {
    // 请求相册权限
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      // 显示权限被拒绝的提示
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('需要相册权限才能保存图片'),
          ),
        );
      }
      return;
    }

    // 下载图片并添加水印
    final dio = Dio();
    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final watermarkedImage = await _addWatermark(response.data);

    // 保存到相册
    final result = await ImageGallerySaver.saveImage(
      watermarkedImage,
      quality: 100,
      name: 'lumio_wallpaper_${DateTime.now().millisecondsSinceEpoch}',
    );

    // 显示成功提示
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✓ 已保存到相册')),
      );
    }
  } catch (e) {
    // 处理错误
  }
}
```

✅ **状态**: 已配置完成

---

## 🔧 需要的操作

### ⚠️ 重要：必须重新构建

因为修改了 Android 原生配置（AndroidManifest.xml），**必须重新构建应用**：

```bash
# 停止当前运行的应用（如果在运行）
# 按 q 退出

# 清理构建缓存
flutter clean

# 重新构建并运行
flutter run -d ios  # iOS
flutter run -d android  # Android
```

**为什么需要重新构建？**
- 修改了 AndroidManifest.xml（Android 原生配置）
- 这属于原生层面的修改，热重载和热重启都无法应用
- 必须完全重新编译

---

## 📱 权限工作流程

### iOS 权限流程

```
用户点击"保存到相册"
    ↓
Permission.photos.request()
    ↓
首次请求 → 系统弹窗
    "Lumio 想要访问您的照片"
    [不允许] [允许]
    ↓
用户选择：
    ├─ 允许 → 保存图片 ✅
    └─ 不允许 → 显示提示 "需要相册权限"
```

### Android 权限流程

```
用户点击"保存到相册"
    ↓
Permission.photos.request()
    ↓
首次请求 → 系统弹窗
    "Lumio 需要访问设备上的照片、媒体内容和文件"
    [拒绝] [允许]
    ↓
用户选择：
    ├─ 允许 → 保存图片 ✅
    └─ 拒绝 → 显示提示 "需要相册权限"
```

---

## 🎯 测试步骤

### 1. 重新构建应用

```bash
cd lume_lucy_paperwall
flutter clean
flutter run -d ios  # 或 android
```

### 2. 测试保存功能

1. 启动应用
2. 生成壁纸
3. 选择一张卡牌
4. 点击"保存到相册"按钮
5. **首次会弹出权限请求对话框**
6. 点击"允许"
7. 等待保存完成
8. 看到 "✓ 已保存到相册" 提示

### 3. 验证图片

- **iOS**: 打开"照片"应用，查看最近的图片
- **Android**: 打开"相册"或"图库"应用，查看最近的图片

---

## 🐛 常见问题

### 问题1：没有弹出权限请求对话框

**可能原因**:
- 之前已经授予或拒绝过权限

**解决方法**:
- **iOS**: 设置 → 隐私与安全 → 照片 → Lumio
- **Android**: 设置 → 应用 → Lumio → 权限

---

### 问题2：权限被拒绝后如何重新请求？

**当前代码行为**:
- 如果用户拒绝，会显示提示 "需要相册权限才能保存图片"
- 但不会自动跳转到设置

**改进建议**（可选）:
```dart
final status = await Permission.photos.request();
if (!status.isGranted) {
  if (status.isPermanentlyDenied) {
    // 权限被永久拒绝，引导用户到设置
    await openAppSettings();
  } else {
    // 权限被拒绝
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('需要相册权限才能保存图片')),
    );
  }
  return;
}
```

---

### 问题3：Android 保存失败

**可能原因**:
- Android 10+ 的分区存储限制

**解决方法**:
在 `android/app/src/main/AndroidManifest.xml` 中添加：
```xml
<application
    android:requestLegacyExternalStorage="true"
    ...>
```

---

### 问题4：iOS 保存失败

**可能原因**:
- Info.plist 配置不正确

**检查**:
```bash
# 查看 Info.plist
cat ios/Runner/Info.plist | grep PhotoLibrary
```

应该看到：
```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>需要相册权限以保存壁纸</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要相册权限以保存壁纸</string>
```

---

## 📊 权限类型说明

### iOS 权限

| 权限 | 用途 | 配置键 |
|------|------|--------|
| 添加到相册 | 保存图片到相册 | NSPhotoLibraryAddUsageDescription |
| 访问相册 | 读取相册内容 | NSPhotoLibraryUsageDescription |

### Android 权限

| 权限 | 用途 | 级别 |
|------|------|------|
| WRITE_EXTERNAL_STORAGE | 写入外部存储 | dangerous |
| READ_EXTERNAL_STORAGE | 读取外部存储 | dangerous |

---

## 🔄 权限状态

```dart
// 检查权限状态
final status = await Permission.photos.status;

// 可能的状态：
// - PermissionStatus.granted: 已授权 ✅
// - PermissionStatus.denied: 已拒绝 ❌
// - PermissionStatus.permanentlyDenied: 永久拒绝 ⚠️
// - PermissionStatus.restricted: 受限（iOS家长控制）
// - PermissionStatus.limited: 有限访问（iOS选择部分照片）
```

---

## 🎨 完整的保存流程

```
用户点击"保存到相册"
    ↓
检查权限状态
    ├─ 已授权 → 直接保存
    ├─ 未决定 → 请求权限
    │   ├─ 允许 → 保存图片
    │   └─ 拒绝 → 显示提示
    └─ 已拒绝 → 显示提示
    ↓
下载图片（带加载提示）
    ↓
添加水印（右下角半透明文字）
    ↓
保存到相册
    ↓
显示结果（成功/失败）
```

---

## ✅ 配置检查清单

- [x] iOS Info.plist 配置权限描述
- [x] Android AndroidManifest.xml 添加权限
- [x] Dart 代码请求权限
- [x] 使用 image_gallery_saver 保存图片
- [x] 添加水印功能
- [x] 错误处理和用户提示

---

## 🚀 下一步

1. **重新构建应用**（必须）
   ```bash
   flutter clean
   flutter run -d ios
   ```

2. **测试保存功能**
   - 生成壁纸
   - 点击保存
   - 检查相册

3. **如果遇到问题**
   - 查看控制台日志
   - 检查权限设置
   - 参考上面的常见问题

---

**配置完成！** 🎉

现在你的应用已经完整配置了相册保存功能。记得重新构建应用才能生效！
