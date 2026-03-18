#!/usr/bin/env python3
"""
最简单的方法：打开 SQL Editor 并将 SQL 复制到剪贴板
"""

import webbrowser
import pyperclip
import os

print("=" * 60)
print("🚀 自动创建 Supabase 表")
print("=" * 60)
print()

# 1. 读取 SQL
sql_file = os.path.join(os.getcwd(), "supabase_tables_complete.sql")
with open(sql_file, 'r') as f:
    sql = f.read()

# 2. 复制到剪贴板
pyperclip.copy(sql)
print("✅ SQL 已复制到剪贴板！")
print()

# 3. 打开 SQL Editor
url = "https://supabase.com/dashboard/project/ppazhdurwozbjiczxapn/sql/new"
webbrowser.open(url)
print("🌐 已打开 SQL Editor！")
print()

print("=" * 60)
print()
print("📋 现在只需 2 步（10 秒）：")
print()
print("1️⃣  在打开的浏览器中按 Cmd+V")
print("2️⃣  点击 'Run' 按钮")
print()
print("=" * 60)
print()
print("✨ SQL 已经在剪贴板中，按 Cmd+V 就能粘贴！")
print()
