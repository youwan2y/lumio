#!/bin/bash

# Lume Lucy Paperwall 启动脚本

PORT=8080
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 启动 Lume Lucy Paperwall..."

# 检查端口是否被占用
check_and_kill_port() {
    local port=$1
    local pid=$(lsof -ti :$port 2>/dev/null)
    if [ -n "$pid" ]; then
        echo "⚠️  端口 $port 被占用，正在终止进程 $pid..."
        kill -9 $pid 2>/dev/null
        sleep 1
    fi
}

# 清理端口
check_and_kill_port $PORT
for p in $(seq 63100 63200); do
    check_and_kill_port $p
done

cd "$PROJECT_DIR"

# 选择运行模式
if [ "$1" == "web" ]; then
    echo "🌐 Web 模式启动..."
    flutter run -d chrome --web-port=$PORT
elif [ "$1" == "ios" ]; then
    echo "📱 iOS 模拟器模式启动..."
    flutter run -d ios
else
    echo "🖥️  macOS 桌面模式启动..."
    flutter run -d macos
fi
