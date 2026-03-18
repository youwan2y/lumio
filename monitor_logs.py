#!/usr/bin/env python3
import time
import os

log_file = "/private/tmp/claude-501/-Users-wangyouhao-00my-flutter-lume-lucy-paperwall/8bbbbf66-d433-4f33-88ed-ebc2d2411226/tasks/bmqq7yh8p.output"

print("🔍 监控 Flutter 应用日志...")
print("=" * 80)
print("按 Ctrl+C 停止监控")
print("=" * 80)

# 读取已有内容
if os.path.exists(log_file):
    with open(log_file, 'r', encoding='utf-8') as f:
        content = f.read()
        lines = content.split('\n')
        last_line_count = len(lines)
        # 显示最后 20 行
        for line in lines[-20:]:
            if line.strip():
                print(line)
else:
    last_line_count = 0

try:
    while True:
        time.sleep(1)
        if os.path.exists(log_file):
            with open(log_file, 'r', encoding='utf-8') as f:
                content = f.read()
                lines = content.split('\n')
                current_line_count = len(lines)

                # 只显示新增的行
                if current_line_count > last_line_count:
                    for i in range(last_line_count, current_line_count):
                        line = lines[i]
                        if line.strip():
                            print(line)
                    last_line_count = current_line_count
except KeyboardInterrupt:
    print("\n\n⏹️  停止监控")
