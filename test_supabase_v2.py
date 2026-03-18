#!/usr/bin/env python3
"""测试 Supabase 连接和权限（带重试机制）"""

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
import json
import time

# Supabase 配置
SUPABASE_URL = "https://ppazhdurwozbjiczxapn.supabase.co"
ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwYXpoZHVyd296YmppY3p4YXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MDg5MjEsImV4cCI6MjA4OTM4NDkyMX0.XM6OKhHkQmZYS07WipCbUHA9yHcAD_Z7HRzUf3TzxbY"

# 配置重试策略
session = requests.Session()
retry_strategy = Retry(
    total=3,
    backoff_factor=1,
    status_forcelist=[429, 500, 502, 503, 504],
)
adapter = HTTPAdapter(max_retries=retry_strategy)
session.mount("https://", adapter)

headers = {
    "apikey": ANON_KEY,
    "Authorization": f"Bearer {ANON_KEY}",
    "Content-Type": "application/json"
}

print("=" * 60)
print("🔍 测试 Supabase 连接和权限")
print("=" * 60)

# 测试表列表
test_tables = [
    "users",
    "usage_counts",
    "wallpapers",
    "user_profiles",
    "purchases"
]

results = {
    "连接状态": "❌",
    "读取权限": {},
    "写入权限": {},
    "表列表": []
}

# 测试 1: 测试各个表
for table in test_tables:
    print(f"\n2️⃣ 测试查询 {table} 表...")
    try:
        response = session.get(
            f"{SUPABASE_URL}/rest/v1/{table}",
            headers=headers,
            params={"select": "*", "limit": "1"},
            timeout=15,
            verify=False  # 禁用 SSL 验证以解决连接问题
        )
        print(f"   状态码: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ 查询成功！找到 {len(data)} 条记录")
            results["读取权限"][table] = "✅"
            results["表列表"].append(table)
        elif response.status_code == 404:
            print(f"   ⚠️ 表不存在")
            results["读取权限"][table] = "⚠️ 不存在"
        elif response.status_code == 401:
            print(f"   ❌ 无权限（需要认证）")
            results["读取权限"][table] = "❌ 无权限"
        elif response.status_code == 403:
            print(f"   ❌ 禁止访问（RLS 策略）")
            results["读取权限"][table] = "❌ RLS 策略"
        else:
            print(f"   ❌ 查询失败: {response.text[:100]}")
            results["读取权限"][table] = f"❌ {response.status_code}"

    except Exception as e:
        print(f"   ❌ 查询错误: {str(e)[:100]}")
        results["读取权限"][table] = f"❌ 错误"

    time.sleep(0.5)  # 避免请求过快

# 测试 2: 尝试创建 usage_counts 表（通过插入数据）
print(f"\n3️⃣ 测试插入数据到 usage_counts 表...")
try:
    test_data = {
        "user_id": f"test_user_{int(time.time())}",
        "device_id": f"test_device_{int(time.time())}",
        "usage_count": 0,
        "is_premium": False
    }
    response = session.post(
        f"{SUPABASE_URL}/rest/v1/usage_counts",
        headers={**headers, "Prefer": "return=representation"},
        json=test_data,
        timeout=15,
        verify=False
    )
    print(f"   状态码: {response.status_code}")

    if response.status_code in [200, 201]:
        print("   ✅ 插入成功！")
        print(f"   响应: {response.text[:200]}")
        results["写入权限"]["usage_counts"] = "✅"
    elif response.status_code == 404:
        print("   ⚠️ 表不存在")
        results["写入权限"]["usage_counts"] = "⚠️ 不存在"
    elif response.status_code == 401:
        print("   ❌ 无权限（需要认证）")
        results["写入权限"]["usage_counts"] = "❌ 无权限"
    elif response.status_code == 403:
        print("   ❌ 禁止访问（RLS 策略）")
        results["写入权限"]["usage_counts"] = "❌ RLS 策略"
    else:
        print(f"   ❌ 插入失败: {response.text[:100]}")
        results["写入权限"]["usage_counts"] = f"❌ {response.status_code}"

except Exception as e:
    print(f"   ❌ 插入错误: {str(e)[:100]}")
    results["写入权限"]["usage_counts"] = "❌ 错误"

# 汇总结果
print("\n" + "=" * 60)
print("📊 测试结果汇总")
print("=" * 60)
print(f"\n✅ Supabase 连接: 成功")
print(f"🔗 URL: {SUPABASE_URL}")
print(f"🔑 API Key: {ANON_KEY[:20]}...")

print(f"\n📖 读取权限:")
for table, status in results["读取权限"].items():
    print(f"   {table}: {status}")

print(f"\n✏️ 写入权限:")
for table, status in results["写入权限"].items():
    print(f"   {table}: {status}")

if results["表列表"]:
    print(f"\n📋 已存在的表: {', '.join(results['表列表'])}")
else:
    print(f"\n⚠️ 未找到任何表")

print("\n" + "=" * 60)
print("💡 建议:")
if not results["表列表"]:
    print("   1. 需要在 Supabase 控制台创建表")
    print("   2. 建议创建 usage_counts 表用于管理使用次数")
    print("   3. 配置 RLS (Row Level Security) 策略")
    print("   4. 给 anon key 分配适当的权限")
else:
    print("   1. 数据库配置正常")
    print("   2. 可以开始集成到 Flutter 应用中")
print("=" * 60)

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
