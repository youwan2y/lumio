# Nivolune 启动指南

## 快速启动（推荐）

### 方法一：一键启动（推荐）
```bash
# 启动模拟器 + 等待 + 运行应用
open -a Simulator && sleep 15 && flutter run -d 8E697BB0-51F8-4441-B9C7-DAFCD3721C1A
```

### 方法二：分步启动（更稳定）
```bash
# 1. 打开模拟器
open -a Simulator

# 2. 等待 5 秒让模拟器完全启动

# 3. 运行应用到 iPhone 17 Pro
flutter run -d 8E697BB0-51F8-4441-B9C7-DAFCD3721C1A
```

---

## 完整启动流程（首次启动或遇到问题时）

```bash
# 1. 进入项目目录
cd /Users/wangyouhao/00my/flutter/lume_lucy_paperwall

# 2. 获取依赖
flutter pub get

# 3. 查看可用设备
flutter devices

# 4. 启动模拟器（如果未启动）
open -a Simulator

# 5. 运行应用
flutter run -d 8E697BB0-51F8-4441-B9C7-DAFCD3721C1A
```

---

## 设备信息

**iPhone 17 Pro**
- 设备 ID: `8E697BB0-51F8-4441-B9C7-DAFCD3721C1A`
- 系统: iOS 26.2
- 状态: 当前唯一可用的模拟器

---

## 热重载快捷键（应用运行时）

在应用运行时，在终端按以下键：

- **`r`** - 热重载（修改 UI 后使用，90% 情况）
- **`R`** - 热重启（修改 main()、全局变量、pubspec.yaml 后使用）
- **`q`** - 退出应用
- **`h`** - 查看所有可用命令
- **`d`** - 分离（应用继续运行，但退出 flutter run）
- **`c`** - 清屏

---

## 查看所有模拟器

```bash
# 列出所有 iOS 模拟器
xcrun simctl list devices

# 列出 Flutter 可用设备
flutter devices
```

---

## 常见问题

### 1. 模拟器未启动
```bash
# 手动启动模拟器
open -a Simulator
```

### 2. 找不到设备
```bash
# 重启模拟器
killall Simulator
open -a Simulator
flutter devices
```

### 3. 依赖问题
```bash
# 清理并重新获取依赖
flutter clean
flutter pub get
```

### 4. Xcode 构建问题
```bash
# 清理构建缓存
flutter clean
flutter pub get
flutter run -d 8E697BB0-51F8-4441-B9C7-DAFCD3721C1A
```

---

## 开发调试

### 查看 DevTools
应用运行后，终端会显示 DevTools 链接：
```
The Flutter DevTools debugger and profiler on iPhone 17 Pro is available at:
http://127.0.0.1:xxxxx/xxxxx=/devtools/?uri=ws://127.0.0.1:xxxxx/xxxxx=/ws
```

### 查看日志
```bash
# 实时查看应用日志
flutter logs

# 详细模式运行
flutter run --verbose
```

### 性能分析
```bash
# 以 profile 模式运行
flutter run --profile

# 运行时按 P 显示性能叠加层
```

---

## 备注

- 当前只保留了 **iPhone 17 Pro** 模拟器
- 设备 ID 可能会在删除重建模拟器后改变，需要重新运行 `flutter devices` 获取
- 首次启动需要下载依赖，可能需要等待几分钟
