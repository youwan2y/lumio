-- ========================================
-- Lumio VIP 数据库表结构 - 完整版
-- 一键复制此文件内容到 Supabase SQL Editor 执行
-- ========================================

-- 1. 创建 usage_counts 表
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

-- 2. 创建索引
CREATE INDEX IF NOT EXISTS idx_usage_counts_user_id ON usage_counts(user_id);
CREATE INDEX IF NOT EXISTS idx_usage_counts_device_id ON usage_counts(device_id);
CREATE INDEX IF NOT EXISTS idx_usage_counts_premium ON usage_counts(is_premium, premium_expires_at);

-- 3. 启用 RLS
ALTER TABLE usage_counts ENABLE ROW LEVEL SECURITY;

-- 4. 删除已存在的策略（如果有）
DROP POLICY IF EXISTS "Allow anonymous read" ON usage_counts;
DROP POLICY IF EXISTS "Allow anonymous insert" ON usage_counts;
DROP POLICY IF EXISTS "Allow anonymous update" ON usage_counts;

-- 5. 创建新策略
CREATE POLICY "Allow anonymous read" ON usage_counts
  FOR SELECT USING (true);

CREATE POLICY "Allow anonymous insert" ON usage_counts
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow anonymous update" ON usage_counts
  FOR UPDATE USING (true) WITH CHECK (true);

-- 6. 创建触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 7. 创建触发器
DROP TRIGGER IF EXISTS update_usage_counts_updated_at ON usage_counts;
CREATE TRIGGER update_usage_counts_updated_at
    BEFORE UPDATE ON usage_counts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 8. 创建 purchases 表
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

-- 9. 创建 purchases 索引
CREATE INDEX IF NOT EXISTS idx_purchases_user_id ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_purchases_transaction_id ON purchases(transaction_id);
CREATE INDEX IF NOT EXISTS idx_purchases_expires_date ON purchases(expires_date);

-- 10. 启用 purchases RLS
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

-- 11. 删除已存在的 purchases 策略
DROP POLICY IF EXISTS "Allow anonymous read purchases" ON purchases;
DROP POLICY IF EXISTS "Allow anonymous insert purchases" ON purchases;

-- 12. 创建 purchases 策略
CREATE POLICY "Allow anonymous read purchases" ON purchases
  FOR SELECT USING (true);

CREATE POLICY "Allow anonymous insert purchases" ON purchases
  FOR INSERT WITH CHECK (true);

-- ========================================
-- 完成！
-- 执行后验证：
-- SELECT * FROM usage_counts LIMIT 1;
-- SELECT * FROM purchases LIMIT 1;
-- ========================================
