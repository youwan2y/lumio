#!/bin/bash

# VIP 功能自动化测试脚本

echo "🧪 VIP 功能自动化测试"
echo "========================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 运行单元测试
run_unit_tests() {
    echo "📦 运行单元测试..."
    echo "----------------------------------------"

    # SupabaseService 测试
    echo "1️⃣  测试 SupabaseService..."
    if flutter test test/services/supabase_service_test.dart; then
        echo -e "${GREEN}✅ SupabaseService 测试通过${NC}"
    else
        echo -e "${RED}❌ SupabaseService 测试失败${NC}"
        return 1
    fi
    echo ""

    # AppState 测试
    echo "2️⃣  测试 AppState..."
    if flutter test test/providers/app_state_test.dart; then
        echo -e "${GREEN}✅ AppState 测试通过${NC}"
    else
        echo -e "${RED}❌ AppState 测试失败${NC}"
        return 1
    fi
    echo ""

    return 0
}

# 运行 Widget 测试
run_widget_tests() {
    echo "🎨 运行 Widget 测试..."
    echo "----------------------------------------"

    # PremiumDialog 测试
    echo "3️⃣  测试 PremiumDialog..."
    if flutter test test/widgets/premium_dialog_test.dart; then
        echo -e "${GREEN}✅ PremiumDialog 测试通过${NC}"
    else
        echo -e "${RED}❌ PremiumDialog 测试失败${NC}"
        return 1
    fi
    echo ""

    # QuestionScreen 测试
    echo "4️⃣  测试 QuestionScreen..."
    if flutter test test/screens/question_screen_test.dart; then
        echo -e "${GREEN}✅ QuestionScreen 测试通过${NC}"
    else
        echo -e "${RED}❌ QuestionScreen 测试失败${NC}"
        return 1
    fi
    echo ""

    return 0
}

# 运行集成测试
run_integration_tests() {
    echo "🚀 运行集成测试..."
    echo "----------------------------------------"

    echo "5️⃣  运行 VIP 流程集成测试..."
    if flutter test test/integration/vip_flow_test.dart; then
        echo -e "${GREEN}✅ VIP 流程集成测试通过${NC}"
    else
        echo -e "${RED}❌ VIP 流程集成测试失败${NC}"
        return 1
    fi
    echo ""

    return 0
}

# 运行所有测试
run_all_tests() {
    echo "🧪 开始运行所有测试..."
    echo "========================================"
    echo ""

    local failed=0

    # 运行单元测试
    if ! run_unit_tests; then
        failed=1
    fi

    # 运行 Widget 测试
    if ! run_widget_tests; then
        failed=1
    fi

    # 运行集成测试
    if ! run_integration_tests; then
        failed=1
    fi

    echo ""
    echo "========================================"
    if [ $failed -eq 0 ]; then
        echo -e "${GREEN}✅ 所有测试通过！${NC}"
        echo ""
        echo "📊 测试覆盖："
        echo "   • SupabaseService - VIP 权限检查"
        echo "   • AppState - VIP 状态管理"
        echo "   • PremiumDialog - VIP 对话框 UI"
        echo "   • QuestionScreen - VIP 状态显示"
        echo "   • VIP Flow - 完整用户流程"
        echo ""
        echo "🎉 VIP 功能测试完成！"
    else
        echo -e "${RED}❌ 部分测试失败${NC}"
        echo ""
        echo "请检查上面的错误信息并修复问题"
        return 1
    fi
}

# 菜单选择
show_menu() {
    echo "选择要运行的测试："
    echo "1) 运行所有测试"
    echo "2) 仅运行单元测试"
    echo "3) 仅运行 Widget 测试"
    echo "4) 仅运行集成测试"
    echo "5) 运行单个测试文件"
    echo "q) 退出"
    echo ""
    read -p "请选择 (1-5, q): " choice

    case $choice in
        1)
            run_all_tests
            ;;
        2)
            run_unit_tests
            ;;
        3)
            run_widget_tests
            ;;
        4)
            run_integration_tests
            ;;
        5)
            echo ""
            echo "可用的测试文件："
            echo "  • test/services/supabase_service_test.dart"
            echo "  • test/providers/app_state_test.dart"
            echo "  • test/widgets/premium_dialog_test.dart"
            echo "  • test/screens/question_screen_test.dart"
            echo "  • test/integration/vip_flow_test.dart"
            echo ""
            read -p "输入测试文件路径: " test_file
            if [ -f "$test_file" ]; then
                flutter test "$test_file"
            else
                echo -e "${RED}❌ 文件不存在: $test_file${NC}"
            fi
            ;;
        q|Q)
            echo "退出测试"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选择${NC}"
            show_menu
            ;;
    esac
}

# 主程序
main() {
    # 检查 Flutter 是否安装
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter 未安装${NC}"
        exit 1
    fi

    # 检查依赖
    echo "📦 检查依赖..."
    flutter pub get
    echo ""

    # 显示菜单
    show_menu
}

# 运行主程序
main
