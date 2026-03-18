# 🧪 VIP 功能自动化测试

## 快速开始

### 运行所有测试
```bash
flutter test
```

### 运行单个测试
```bash
# SupabaseService 测试（已通过 ✅）
flutter test test/services/supabase_service_test.dart

# AppState 测试
flutter test test/providers/app_state_test.dart

# PremiumDialog 测试
flutter test test/widgets/premium_dialog_test.dart

# QuestionScreen 测试
flutter test test/screens/question_screen_test.dart
```

### 使用测试脚本
```bash
# 交互式测试菜单
./run_vip_tests.sh

# 测试总结
./test_vip_summary.sh
```

## 测试覆盖

### ✅ 单元测试
- **SupabaseService** (6/6 通过)
  - VIP 权限检查
  - 使用次数限制
  - VIP 激活
  - 过期处理

- **AppState**
  - VIP 状态管理
  - 权限检查
  - 状态重置

### 🎨 Widget 测试
- **PremiumDialog**
  - VIP 对话框 UI
  - 购买按钮交互

- **QuestionScreen**
  - VIP 状态显示
  - 剩余次数显示
  - 问题导航

### 🚀 集成测试
- **VIP 完整流程**
  - 首次用户使用
  - 次数限制
  - VIP 无限使用

## 测试结果

查看最新测试报告: [VIP_TEST_REPORT.md](VIP_TEST_REPORT.md)

## 测试数据

测试会自动创建临时用户 ID，不会影响生产数据。

## 故障排查

### 测试失败
```bash
# 清理并重新运行
flutter clean
flutter pub get
flutter test
```

### 查看详细日志
```bash
flutter test --reporter expanded
```
