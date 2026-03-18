#!/usr/bin/env python3
"""测试 Supabase 连接和权限"""

import requests
import json

# Supabase 配置
SUPABASE_URL = "https://ppazhdurwozbjiczxapn.supabase.co"
ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwYXpoZHVyd296YmppY3p4YXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MDg5MjEsImV4cCI6MjA4OTM4NDkyMX0.XM6OKhHkQmZYS07WipCbUHA9yHcAD_Z7HRzUf3TzxbY"

headers = {
    "apikey": ANON_KEY,
    "Authorization": f"Bearer {ANON_KEY}",
    "Content-Type": "application/json"
}

print("=" * 60)
print("🔍 测试 Supabase 连接和权限")
print("=" * 60)

# 测试 1: 获取数据库表列表
print("\n1️⃣ 测试获取数据库表...")
try:
    response = requests.get(
        f"{SUPABASE_URL}/rest/v1/",
        headers=headers,
        timeout=10
    )
    print(f"状态码: {response.status_code}")
    if response.status_code == 200:
        print("✅ 连接成功！")
        print(f"响应: {response.text[:200]}")
    else:
        print(f"❌ 连接失败")
        print(f"响应: {response.text}")
except Exception as e:
    print(f"❌ 连接错误: {e}")

# 测试 2: 尝试查询 users 表（如果存在）
print("\n2️⃣ 测试查询 users 表...")
try:
    response = requests.get(
        f"{SUPABASE_URL}/rest/v1/users",
        headers=headers,
        params={"select": "*"},
        timeout=10
    )
    print(f"状态码: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"✅ 查询成功！找到 {len(data)} 条记录")
        if data:
            print(f"示例数据: {json.dumps(data[0], indent=2, ensure_ascii=False)}")
    else:
        print(f"❌ 查询失败")
        print(f"响应: {response.text}")
except Exception as e:
    print(f"❌ 查询错误: {e}")

# 测试 3: 尝试查询 usage_counts 表（如果存在）
print("\n3️⃣ 测试查询 usage_counts 表...")
try:
    response = requests.get(
        f"{SUPABASE_URL}/rest/v1/usage_counts",
        headers=headers,
        params={"select": "*"},
        timeout=10
    )
    print(f"状态码: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"✅ 查询成功！找到 {len(data)} 条记录")
        if data:
            print(f"示例数据: {json.dumps(data[0], indent=2, ensure_ascii=False)}")
    else:
        print(f"⚠️ 表不存在或无权限")
        print(f"响应: {response.text}")
except Exception as e:
    print(f"❌ 查询错误: {e}")

# 测试 4: 尝试插入测试数据
print("\n4️⃣ 测试插入数据到 usage_counts 表...")
try:
    test_data = {
        "user_id": "test_user_123",
        "device_id": "test_device_456",
        "usage_count": 0,
        "is_premium": False
    }
    response = requests.post(
        f"{SUPABASE_URL}/rest/v1/usage_counts",
        headers=headers,
        json=test_data,
        timeout=10
    )
    print(f"状态码: {response.status_code}")
    if response.status_code in [200, 201]:
        print("✅ 插入成功！")
        print(f"响应: {response.text}")
    else:
        print(f"❌ 插入失败")
        print(f"响应: {response.text}")
except Exception as e:
    print(f"❌ 插入错误: {e}")

print("\n" + "=" * 60)
print("🏁 测试完成")
print("=" * 60)
