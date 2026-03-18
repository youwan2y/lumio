# 📦 Nivolune App Store 上架素材包

**生成日期**: 2026-03-18
**应用版本**: 1.0.0
**状态**: ✅ 已完成

---

## 📂 文件清单

### 1. 应用信息文档

| 文件名 | 说明 | 状态 |
|--------|------|------|
| `APP_STORE_INFO.md` | App Store 完整上架信息 | ✅ 已生成 |
| `PRIVACY_POLICY.md` | 隐私政策（需部署到网站） | ✅ 已生成 |
| `SUPPORT.md` | 技术支持页面内容 | ✅ 已生成 |
| `SCREENSHOT_GUIDE.md` | 截图指南和最佳实践 | ✅ 已生成 |

### 2. 图标素材

| 文件名 | 尺寸 | 说明 | 状态 |
|--------|------|------|------|
| `AppIcon_1024x1024.png` | 1024 x 1024 px | App Store 应用图标 | ✅ 已生成 |

### 3. 截图工具

| 文件名 | 说明 | 状态 |
|--------|------|------|
| `auto_screenshot.sh` | 自动化截图脚本 | ✅ 已生成 |
| `generate_icon.py` | 图标生成脚本 | ✅ 已生成 |

---

## ✅ 已完成的内容

### 📝 文本内容

#### 应用名称
- **主名称**: Nivolune
- **副标题**: AI 智能壁纸生成

#### 应用描述
- ✅ 简短描述（170字符）
- ✅ 详细描述（约1500字符）
- ✅ 包含核心功能、使用流程、技术亮点

#### 关键词
```
壁纸,AI生成,个性化,心情,能量,卡牌,智能,高清,艺术,创意
```

#### 隐私政策
- ✅ 完整的隐私政策文档
- ✅ 包含信息收集、使用、存储说明
- ✅ 符合 App Store 要求

#### 技术支持内容
- ✅ 应用介绍
- ✅ 使用指南
- ✅ 常见问题（20+）
- ✅ 联系方式

### 🎨 视觉素材

#### 应用图标
- ✅ 1024 x 1024 px
- ✅ PNG 格式
- ✅ 蓝紫色渐变
- ✅ 光晕效果
- ✅ 字母 "L" 设计

#### 截图指南
- ✅ 5 个关键界面说明
- ✅ 截图步骤详解
- ✅ 技术要求和美化建议
- ✅ 自动化截图脚本

---

## 📋 待完成任务

### 🔴 必需任务

#### 1. 生成截图（约 30 分钟）

**方法 1: 使用自动化脚本（推荐）**
```bash
cd app_store_assets
./auto_screenshot.sh
```

**方法 2: 手动截图**
1. 确保应用在模拟器中运行
2. 按下 `Cmd + S` 截图
3. 保存 5 个关键界面

**截图清单**:
- [ ] 启动页
- [ ] 心情选择
- [ ] 能量选择
- [ ] 卡牌页面
- [ ] 结果页面

**截图尺寸**:
- [ ] 6.5 英寸 (2778 x 1284 px) - 5 张
- [ ] 5.5 英寸 (2208 x 1242 px) - 5 张

---

#### 2. 部署隐私政策页面（约 15 分钟）

**方法 1: GitHub Pages（推荐，免费）**

1. **创建 GitHub 仓库**
   ```bash
   # 创建新仓库: nivolune-privacy-policy
   ```

2. **创建 index.html**
   ```bash
   # 将 PRIVACY_POLICY.md 转换为 HTML
   # 或使用 Markdown 渲染器
   ```

3. **启用 GitHub Pages**
   - 仓库 Settings → Pages
   - Source: main branch
   - 保存

4. **获取 URL**
   ```
   https://yourusername.github.io/nivolune-privacy-policy
   ```

**方法 2: 其他静态托管**
- [Netlify](https://www.netlify.com/)（免费）
- [Vercel](https://vercel.com/)（免费）
- 自己的服务器

---

#### 3. 部署技术支持页面（约 15 分钟）

同隐私政策部署方法，使用 `SUPPORT.md` 内容。

URL 示例：
```
https://yourusername.github.io/nivolune-support
```

---

#### 4. 更新联系信息（约 5 分钟）

在以下文件中替换占位符：

**需要替换的内容**:
- `your.email@example.com` → 你的真实邮箱
- `yourusername` → 你的 GitHub 用户名
- `+86 138-0000-0000` → 你的联系电话（可选）

**文件清单**:
- [ ] `APP_STORE_INFO.md`
- [ ] `PRIVACY_POLICY.md`
- [ ] `SUPPORT.md`

---

### 🟡 可选但推荐

#### 1. 生成应用预览视频（约 1 小时）

**要求**:
- 时长: 15-30 秒
- 格式: MP4 或 MOV
- 尺寸: 与截图一致

**工具**:
- iOS 屏幕录制
- QuickTime Player
- iMovie（剪辑）

**内容**:
1. 打开应用（2秒）
2. 开始探索（1秒）
3. 选择心情能量（6秒）
4. 生成加载（2秒）
5. 卡牌翻转（5秒）
6. 保存壁纸（2秒）
7. 展示效果（4秒）

---

#### 2. 生成 iPad 截图（约 20 分钟）

**尺寸**: 2732 x 2048 px
**数量**: 2-3 张

**推荐界面**:
- 卡牌页面（展示大屏效果）
- 结果页面（展示高清壁纸）

---

#### 3. 创建营销网站（约 2 小时）

**内容**:
- 应用介绍
- 功能特性
- 下载链接
- 用户评价

**工具**:
- GitHub Pages
- Framer
- Webflow

URL 示例：
```
https://yourusername.github.io/nivolune
```

---

## 🚀 上架流程

### 步骤 1: 准备开发者账号
- [ ] 注册 Apple Developer 账号（$99/年）
- [ ] 完成个人/公司信息填写
- [ ] 等待审核通过（通常 24-48 小时）

### 步骤 2: 配置应用
```bash
# 1. 打开 Xcode 项目
open ios/Runner.xcworkspace

# 2. 配置 Bundle ID
# 选择 Runner → Signing & Capabilities
# 设置 Bundle Identifier: com.yourname.nivolune

# 3. 选择 Team
# 选择你的 Apple Developer 账号

# 4. 更新版本号
# 在 Xcode 中设置 Version: 1.0.0, Build: 1
```

### 步骤 3: 构建发布版本
```bash
# 清理项目
flutter clean
flutter pub get

# 构建 iOS Release 版本
flutter build ios --release
```

### 步骤 4: 归档并上传
```bash
# 在 Xcode 中
# 1. Product → Archive
# 2. 等待归档完成
# 3. Distribute App → App Store Connect → Upload
```

### 步骤 5: App Store Connect 配置

1. **创建应用**
   - 登录 [App Store Connect](https://appstoreconnect.apple.com/)
   - 点击"我的 App" → "+" → "新建 App"
   - 填写基本信息

2. **填写应用信息**
   - 复制 `APP_STORE_INFO.md` 中的内容
   - 上传应用图标
   - 上传截图
   - 填写隐私政策 URL
   - 填写支持网站 URL

3. **选择构建版本**
   - 等待构建版本处理完成（约 10-30 分钟）
   - 选择最新版本

4. **提交审核**
   - 检查所有必填项
   - 点击"提交审核"

### 步骤 6: 等待审核
- 通常 24-48 小时
- 关注审核状态
- 如有拒绝，根据反馈修改

### 步骤 7: 上架
- 审核通过后选择发布方式
- 手动发布或自动发布
- 应用上线！

---

## 📊 时间估算

| 任务 | 预计时间 | 状态 |
|------|----------|------|
| 文本内容准备 | - | ✅ 已完成 |
| 应用图标设计 | - | ✅ 已完成 |
| 截图生成 | 30 分钟 | ⏳ 待完成 |
| 部署隐私政策 | 15 分钟 | ⏳ 待完成 |
| 部署支持页面 | 15 分钟 | ⏳ 待完成 |
| 更新联系信息 | 5 分钟 | ⏳ 待完成 |
| Xcode 配置 | 10 分钟 | ⏳ 待完成 |
| 构建和上传 | 20 分钟 | ⏳ 待完成 |
| App Store Connect 配置 | 30 分钟 | ⏳ 待完成 |
| **总计** | **约 2 小时** | |

---

## 📝 重要提醒

### ⚠️ API Key 安全

当前 API Key 在代码中（`lib/config/api_config.dart`），建议：

**短期方案**:
- 上架前确认 API Key 有使用限制
- 监控 API 使用量

**长期方案**:
- 使用环境变量
- 使用后端代理
- 使用配置文件（不提交到 Git）

### ⚠️ 联系信息

确保使用真实有效的联系信息：
- 邮箱: 定期查看
- 网站: 保持在线
- 隐私政策: 符合实际情况

### ⚠️ 审核注意事项

**可能被拒的原因**:
1. **崩溃或 Bug**: 充分测试
2. **元数据问题**: 描述与功能一致
3. **设计问题**: UI 符合规范
4. **隐私问题**: 权限说明清晰
5. **API 使用**: 说明网络使用目的

**审核备注建议**（复制到 App Store Connect）:
```
Nivolune 是一款 AI 智能壁纸生成应用。

使用流程：
1. 打开应用，点击"开始探索"
2. 首次使用需输入星座和年龄
3. 滑动选择心情、能量、风格
4. 等待 AI 生成 9 张卡牌壁纸
5. 点击卡牌翻转查看
6. 选择喜欢的一张保存到相册

技术说明：
- 使用通义千问 API 生成描述
- 使用火山引擎 API 生成图片
- 使用 wttr.in 获取天气信息
- 相册权限仅用于保存生成的壁纸

网络使用：
- AI 图像生成需要网络连接
- 天气获取需要网络连接
- 失败不影响应用使用
```

---

## 🎯 快速开始

### 立即开始截图

**当前应用已在模拟器运行**，可以立即开始截图：

```bash
# 方法 1: 使用自动脚本
cd app_store_assets
./auto_screenshot.sh

# 方法 2: 手动截图
# 在模拟器中按 Cmd + S
```

### 完整上架流程

```bash
# 1. 截图
cd app_store_assets
./auto_screenshot.sh

# 2. 部署隐私政策
# 创建 GitHub 仓库，上传 PRIVACY_POLICY.md

# 3. 更新联系信息
# 编辑所有 .md 文件，替换 your.email@example.com

# 4. 配置 Xcode
open ios/Runner.xcworkspace

# 5. 构建上传
flutter clean && flutter pub get
flutter build ios --release
# 在 Xcode 中 Archive 并 Upload

# 6. App Store Connect 配置
# 访问 https://appstoreconnect.apple.com/
# 按照 APP_STORE_INFO.md 填写信息
```

---

## 📞 需要帮助？

如果在任何步骤遇到问题，请检查：

1. **Flutter 官方文档**: https://docs.flutter.dev/deployment/ios
2. **Apple 官方指南**: https://developer.apple.com/documentation/appstoreconnectapi
3. **常见问题**: 查看 `SUPPORT.md`

---

## ✅ 检查清单

### 上架前最终检查

#### 文本内容
- [ ] 应用描述准确无误
- [ ] 关键词优化
- [ ] 隐私政策 URL 可访问
- [ ] 支持网站 URL 可访问
- [ ] 联系信息真实有效

#### 视觉素材
- [ ] 应用图标 1024x1024
- [ ] iPhone 6.5 英寸截图 5 张
- [ ] iPhone 5.5 英寸截图 5 张
- [ ] 所有截图清晰美观
- [ ] 截图内容真实

#### 技术准备
- [ ] 应用无崩溃
- [ ] 功能完整
- [ ] 权限说明清晰
- [ ] API Key 安全
- [ ] 版本号正确

#### App Store Connect
- [ ] 开发者账号激活
- [ ] Bundle ID 配置
- [ ] 签名证书配置
- [ ] 构建版本上传成功
- [ ] 所有必填项完成

---

## 🎉 完成后

恭喜！上架成功后：

1. **分享应用**
   - 社交媒体宣传
   - 生成分享链接

2. **收集反馈**
   - 关注用户评论
   - 及时回复问题

3. **持续优化**
   - 根据反馈改进
   - 定期更新版本
   - 添加新功能

4. **数据分析**
   - App Store Connect 分析
   - 下载量监控
   - 崩溃率监控

---

**祝你上架顺利！🚀**

---

*生成日期: 2026-03-18*
*应用版本: 1.0.0*
*文档版本: 1.0*
