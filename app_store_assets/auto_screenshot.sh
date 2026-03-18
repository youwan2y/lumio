#!/bin/bash
# Lumio 自动化截图脚本
# 使用方法: ./auto_screenshot.sh

echo "================================"
echo "📸 Lumio App Store 截图工具"
echo "================================"
echo ""

# 设置输出目录
OUTPUT_DIR="screenshots_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUTPUT_DIR"

echo "📁 截图将保存到: $OUTPUT_DIR"
echo ""

# 检查模拟器是否运行
if ! xcrun simctl list devices | grep -q "Booted"; then
    echo "❌ 错误: 没有运行的模拟器"
    echo "请先运行: flutter run -d <device_id>"
    exit 1
fi

echo "✅ 检测到运行中的模拟器"
echo ""

# 截图函数
take_screenshot() {
    local name=$1
    local filename="${OUTPUT_DIR}/${name}.png"

    echo "📸 正在截取: $name"
    xcrun simctl io booted screenshot "$filename"

    if [ $? -eq 0 ]; then
        echo "   ✅ 已保存: $filename"
    else
        echo "   ❌ 截图失败"
        return 1
    fi
}

echo "🎯 准备截取 5 个关键界面"
echo ""
echo "请按照提示操作..."
echo ""

# 截图 1: 启动页
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1️⃣  第一张: 启动页"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "要求: 应用刚启动，显示 Logo 和'开始探索'按钮"
echo ""
read -p "准备好后按回车键截图..." -r
take_screenshot "01_Launch"
echo ""

# 截图 2: 心情选择
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2️⃣  第二张: 心情选择"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "要求: 点击'开始探索'，完成首次登录，进入第一个问题页面"
echo "      滑块调整到合适位置"
echo ""
read -p "准备好后按回车键截图..." -r
take_screenshot "02_Mood"
echo ""

# 截图 3: 能量选择
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3️⃣  第三张: 能量选择"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "要求: 点击'下一步'，进入第二个问题页面"
echo "      滑块调整到合适位置"
echo ""
read -p "准备好后按回车键截图..." -r
take_screenshot "03_Energy"
echo ""

# 截图 4: 卡牌页面
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4️⃣  第四张: 卡牌页面"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "要求: 完成所有问题，点击'生成我的壁纸'"
echo "      等待生成完成（约1分钟），进入卡牌页面"
echo "      点击中间的卡牌翻转"
echo ""
read -p "准备好后按回车键截图..." -r
take_screenshot "04_Cards"
echo ""

# 截图 5: 结果页面
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5️⃣  第五张: 结果页面"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "要求: 点击翻转后的卡牌，进入结果页面"
echo "      壁纸完全加载，显示保存按钮"
echo ""
read -p "准备好后按回车键截图..." -r
take_screenshot "05_Result"
echo ""

# 完成
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 截图完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 所有截图已保存到: $OUTPUT_DIR"
echo ""

# 显示截图列表
echo "📸 截图文件:"
ls -lh "$OUTPUT_DIR"/*.png
echo ""

# 下一步提示
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 下一步操作:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. 检查截图质量"
echo "   cd $OUTPUT_DIR"
echo "   open ."
echo ""
echo "2. 调整尺寸（如果需要）"
echo "   - 6.5英寸: 2778 x 1284 px"
echo "   - 5.5英寸: 2208 x 1242 px"
echo ""
echo "3. 重命名文件（参考 SCREENSHOT_GUIDE.md）"
echo ""
echo "4. 上传到 App Store Connect"
echo ""
echo "✅ 完成！"
