#!/bin/bash

# ========================================
# Lumio VIP 功能快速测试脚本
# ========================================

echo "========================================"
echo "🧪 Lumio VIP 功能测试"
echo "========================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否在项目根目录
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ 请在项目根目录运行此脚本${NC}"
    exit 1
fi

echo "📋 测试前检查："
echo ""

# 检查 Supabase 配置
echo -e "${YELLOW}1. 检查 Supabase 配置...${NC}"
if grep -q "ppazhdurwozbjiczxapn.supabase.co" lib/services/supabase_service.dart; then
    echo -e "${GREEN}   ✅ Supabase URL 已配置${NC}"
else
    echo -e "${RED}   ❌ Supabase URL 未配置${NC}"
fi

# 检查依赖
echo -e "${YELLOW}2. 检查依赖...${NC}"
if grep -q "supabase_flutter" pubspec.yaml; then
    echo -e "${GREEN}   ✅ supabase_flutter 已添加${NC}"
else
    echo -e "${RED}   ❌ supabase_flutter 未添加${NC}"
fi

if grep -q "in_app_purchase" pubspec.yaml; then
    echo -e "${GREEN}   ✅ in_app_purchase 已添加${NC}"
else
    echo -e "${RED}   ❌ in_app_purchase 未添加${NC}"
fi

echo ""
echo "========================================"
echo "📝 测试步骤："
echo "========================================"
echo ""
echo "1️⃣  在 Supabase 创建数据库表"
echo "   - 访问: https://supabase.com/dashboard"
echo "   - 进入 SQL Editor"
echo "   - 执行: supabase_schema.sql"
echo ""
echo "2️⃣  运行应用"
echo "   - flutter run -d ios"
echo ""
echo "3️⃣  测试普通用户"
echo "   - 首次生成: ✅ 应该成功"
echo "   - 第二次生成: ❌ 应该显示 VIP 对话框"
echo ""
echo "4️⃣  测试 VIP 用户"
echo "   - 在数据库手动设置 VIP"
echo "   - 或使用内购测试（需要沙盒账号）"
echo ""

echo "========================================"
echo "🔧 快速测试命令："
echo "========================================"
echo ""
echo "# 重置用户为普通用户（1次机会）"
echo "psql -h ppazhdurwozbjiczxapn.supabase.co -U postgres -d postgres -c \"UPDATE usage_counts SET usage_count = 0, is_premium = FALSE, premium_expires_at = NULL;\""
echo ""
echo "# 手动设置用户为 VIP"
echo "psql -h ppazhdurwozbjiczxapn.supabase.co -U postgres -d postgres -c \"UPDATE usage_counts SET is_premium = TRUE, premium_expires_at = NOW() + INTERVAL '30 days';\""
echo ""
echo "# 查看所有用户"
echo "psql -h ppazhdurwozbjiczxapn.supabase.co -U postgres -d postgres -c \"SELECT * FROM usage_counts;\""
echo ""

echo "========================================"
echo "✨ 准备就绪！"
echo "========================================"
echo ""
echo "下一步："
echo "1. 在 Supabase 执行 supabase_schema.sql"
echo "2. 运行: flutter run -d ios"
echo "3. 参考 VIP_TESTING.md 进行测试"
echo ""
