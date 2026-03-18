#!/usr/bin/env python3
import requests
import json

# Supabase 配置
SUPABASE_URL = "https://sbplxmqcvigdqzrgaonv.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNicGx4bXFjdmlnZHF6cmdhb252Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIyNzMzODUsImV4cCI6MjA1Nzg0OTM4NX0.OZVVCi0PRiFMxhGqHxQhD8RwLFpvAQ2-V8lVqGPB-7c"

# 查询所有用户
def get_all_users():
    url = f"{SUPABASE_URL}/rest/v1/usage_counts?select=*"
    headers = {
        "apikey": SUPABASE_ANON_KEY,
        "Authorization": f"Bearer {SUPABASE_ANON_KEY}",
        "Content-Type": "application/json"
    }

    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        users = response.json()

        print("\n📊 数据库中的用户状态：")
        print("=" * 80)
        for user in users:
            print(f"\n👤 用户 ID: {user['user_id']}")
            print(f"   使用次数: {user['usage_count']}")
            print(f"   是否 VIP: {user['is_premium']}")
            print(f"   VIP 过期时间: {user.get('premium_expires_at', '无')}")
            print(f"   创建时间: {user['created_at']}")
            print(f"   更新时间: {user['updated_at']}")
        print("=" * 80)

        return users
    except Exception as e:
        print(f"❌ 查询失败: {e}")
        return None

# 查询特定用户
def get_user(user_id):
    url = f"{SUPABASE_URL}/rest/v1/usage_counts?user_id=eq.{user_id}"
    headers = {
        "apikey": SUPABASE_ANON_KEY,
        "Authorization": f"Bearer {SUPABASE_ANON_KEY}",
        "Content-Type": "application/json"
    }

    try:
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        users = response.json()

        if users:
            user = users[0]
            print(f"\n👤 用户 {user_id} 的状态：")
            print("=" * 80)
            print(f"   使用次数: {user['usage_count']}")
            print(f"   是否 VIP: {user['is_premium']}")
            print(f"   VIP 过期时间: {user.get('premium_expires_at', '无')}")
            print(f"   创建时间: {user['created_at']}")
            print(f"   更新时间: {user['updated_at']}")
            print("=" * 80)
            return user
        else:
            print(f"❌ 用户 {user_id} 不存在")
            return None
    except Exception as e:
        print(f"❌ 查询失败: {e}")
        return None

if __name__ == "__main__":
    print("\n🔍 Supabase 数据库查询工具")
    print("=" * 80)

    # 查询所有用户
    users = get_all_users()

    # 如果有用户，查询第一个用户的详细信息
    if users:
        print("\n" + "=" * 80)
        get_user(users[0]['user_id'])
