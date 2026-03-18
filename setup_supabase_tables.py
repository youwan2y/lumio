#!/usr/bin/env python3
"""
自动创建 Supabase 表
"""

import requests
import json
import time

# Supabase 配置
SUPABASE_URL = "https://ppazhdurwozbjiczxapn.supabase.co"
ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwYXpoZHVyd296YmppY3p4YXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MDg5MjEsImV4cCI6MjA4OTM4NDkyMX0.XM6OKhHkQmZYS07WipCbUHA9yHcAD_Z7HRzUf3TzxbY"

headers = {
    "apikey": ANON_KEY,
    "Authorization": f"Bearer {ANON_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=representation"
}

print("=" * 60)
print("🔧 Supabase 表创建工具")
print("=" * 60)
print()

# SQL 语句（逐个执行）
sql_statements = [
    # 1. 创建 usage_counts 表
    """
    CREATE TABLE IF NOT EXISTS usage_counts (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      user_id TEXT UNIQUE NOT NULL,
      device_id TEXT,
      usage_count INTEGER DEFAULT 0,
      is_premium BOOLEAN DEFAULT FALSE,
      premium_expires_at TIMESTAMP WITH TIME ZONE,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    """,

    # 2. 创建索引
    "CREATE INDEX IF NOT EXISTS idx_usage_counts_user_id ON usage_counts(user_id);",
    "CREATE INDEX IF NOT EXISTS idx_usage_counts_device_id ON usage_counts(device_id);",
    "CREATE INDEX IF NOT EXISTS idx_usage_counts_premium ON usage_counts(is_premium, premium_expires_at);",

    # 3. 启用 RLS
    "ALTER TABLE usage_counts ENABLE ROW LEVEL SECURITY;",

    # 4. 创建 RLS 策略
    "CREATE POLICY \"Allow anonymous read\" ON usage_counts FOR SELECT USING (true);",
    "CREATE POLICY \"Allow anonymous insert\" ON usage_counts FOR INSERT WITH CHECK (true);",
    "CREATE POLICY \"Allow anonymous update\" ON usage_counts FOR UPDATE USING (true) WITH CHECK (true);",

    # 5. 创建触发器函数
    """
    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = NOW();
        RETURN NEW;
    END;
    $$ language 'plpgsql';
    """,

    # 6. 创建触发器
    """
    DROP TRIGGER IF EXISTS update_usage_counts_updated_at ON usage_counts;
    CREATE TRIGGER update_usage_counts_updated_at
        BEFORE UPDATE ON usage_counts
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    """,

    # 7. 创建 purchases 表
    """
    CREATE TABLE IF NOT EXISTS purchases (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      user_id TEXT NOT NULL,
      product_id TEXT NOT NULL,
      purchase_token TEXT,
      transaction_id TEXT UNIQUE,
      purchase_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      expires_date TIMESTAMP WITH TIME ZONE,
      is_valid BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    """,

    # 8. 创建 purchases 索引
    "CREATE INDEX IF NOT EXISTS idx_purchases_user_id ON purchases(user_id);",
    "CREATE INDEX IF NOT EXISTS idx_purchases_transaction_id ON purchases(transaction_id);",
    "CREATE INDEX IF NOT EXISTS idx_purchases_expires_date ON purchases(expires_date);",

    # 9. 启用 purchases RLS
    "ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;",

    # 10. 创建 purchases RLS 策略
    "CREATE POLICY \"Allow anonymous read purchases\" ON purchases FOR SELECT USING (true);",
    "CREATE POLICY \"Allow anonymous insert purchases\" ON purchases FOR INSERT WITH CHECK (true);",
]

print("⚠️  注意：Supabase REST API 不支持直接执行 DDL 语句")
print("    需要使用 SQL Editor 或 service_role key")
print()
print("📋 正在尝试通过 REST API 验证表是否存在...")
print()

# 验证表是否存在
def check_table_exists(table_name):
    try:
        response = requests.get(
            f"{SUPABASE_URL}/rest/v1/{table_name}?select=count",
            headers=headers,
            params={"limit": "1"},
            timeout=10,
            verify=False
        )
        return response.status_code == 200
    except:
        return False

# 检查表
tables_status = {
    "usage_counts": check_table_exists("usage_counts"),
    "purchases": check_table_exists("purchases")
}

print("📊 表状态检查：")
print()
for table, exists in tables_status.items():
    status = "✅ 已存在" if exists else "❌ 不存在"
    print(f"   {table}: {status}")

print()

if all(tables_status.values()):
    print("✅ 所有表已存在，无需创建！")
    print()
    print("🎉 数据库配置完成，可以开始使用 VIP 功能了！")
else:
    print("❌ 部分表不存在，需要手动创建")
    print()
    print("📝 请按照以下步骤操作：")
    print()
    print("1. 访问 Supabase SQL Editor:")
    print("   https://supabase.com/dashboard/project/ppazhdurwozbjiczxapn/sql")
    print()
    print("2. 点击 'New query'")
    print()
    print("3. 复制 supabase_schema.sql 文件的全部内容")
    print()
    print("4. 点击 'Run' 执行")
    print()
    print("5. 重新运行此脚本验证：")
    print("   python3 setup_supabase_tables.py")
    print()

print("=" * 60)

import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
