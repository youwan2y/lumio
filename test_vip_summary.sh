#!/bin/bash

echo "🧪 VIP 功能自动化测试报告"
echo "========================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 测试计数
total_tests=0
passed_tests=0
failed_tests=0

# 运行测试函数
run_test() {
    local test_name=$1
    local test_file=$2

    echo -e "${BLUE}▶ 运行: $test_name${NC}"
    echo "----------------------------------------"

    if flutter test "$test_file" --reporter compact 2>&1 | grep -q "All tests passed!"; then
        echo -e "${GREEN}✅ 通过${NC}"
        ((passed_tests++))
    else
        echo -e "${RED}❌ 失败${NC}"
        ((failed_tests++))
    fi

    ((total_tests++))
    echo ""
}

# 运行所有测试
echo "📦 开始测试..."
echo ""

run_test "SupabaseService 单元测试" "test/services/supabase_service_test.dart"
run_test "AppState 单元测试" "test/providers/app_state_test.dart"
run_test "PremiumDialog Widget 测试" "test/widgets/premium_dialog_test.dart"
run_test "QuestionScreen Widget 测试" "test/screens/question_screen_test.dart"

echo "========================================"
echo "📊 测试总结"
echo "========================================"
echo -e "总测试数: ${BLUE}$total_tests${NC}"
echo -e "通过: ${GREEN}$passed_tests${NC}"
echo -e "失败: ${RED}$failed_tests${NC}"
echo ""

if [ $failed_tests -eq 0 ]; then
    echo -e "${GREEN}🎉 所有测试通过！VIP 功能正常工作！${NC}"
    echo ""
    echo "✅ 测试覆盖："
    echo "   • SupabaseService - VIP 权限检查 ✓"
    echo "   • AppState - VIP 状态管理 ✓"
    echo "   • PremiumDialog - VIP 对话框 UI ✓"
    echo "   • QuestionScreen - VIP 状态显示 ✓"
    echo ""
    echo "🎯 VIP 功能已完全实现并测试通过！"
else
    echo -e "${RED}❌ 有 $failed_tests 个测试失败${NC}"
    echo ""
    echo "请运行 'flutter test' 查看详细错误信息"
fi

echo ""
echo "========================================"
