-- ========================================
-- Lumio VIP 功能数据库表结构
-- ========================================

-- 1. 创建使用次数表
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

-- 3. 启用 RLS (Row Level Security)
ALTER TABLE usage_counts ENABLE ROW LEVEL SECURITY;

-- 4. 创建允许匿名访问的策略（生产环境需要更严格的策略）
CREATE POLICY "Allow anonymous read" ON usage_counts
  FOR SELECT
  USING (true);

CREATE POLICY "Allow anonymous insert" ON usage_counts
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow anonymous update" ON usage_counts
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- 5. 创建更新时间的触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 6. 创建触发器
DROP TRIGGER IF EXISTS update_usage_counts_updated_at ON usage_counts;
CREATE TRIGGER update_usage_counts_updated_at
    BEFORE UPDATE ON usage_counts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 7. 创建购买记录表（用于验证购买）
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

-- 8. 创建购买记录索引
CREATE INDEX IF NOT EXISTS idx_purchases_user_id ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_purchases_transaction_id ON purchases(transaction_id);
CREATE INDEX IF NOT EXISTS idx_purchases_expires_date ON purchases(expires_date);

-- 9. 启用购买记录的 RLS
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;

-- 10. 创建购买记录的访问策略
CREATE POLICY "Allow anonymous read purchases" ON purchases
  FOR SELECT
  USING (true);

CREATE POLICY "Allow anonymous insert purchases" ON purchases
  FOR INSERT
  WITH CHECK (true);

-- ========================================
-- 说明：
-- 1. usage_counts 表：记录用户使用次数和 VIP 状态
-- 2. purchases 表：记录购买历史，用于验证和续费
-- 3. RLS 策略：当前允许匿名访问（生产环境需要更严格的策略）
-- 4. 普通用户：usage_count >= 1 时禁止使用
-- 5. VIP 用户：is_premium=true 且 premium_expires_at > NOW()
-- ========================================

-- 查询示例：
-- 检查用户是否可以使用
-- SELECT
--   user_id,
--   usage_count,
--   is_premium,
--   premium_expires_at,
--   (is_premium AND premium_expires_at > NOW()) as is_vip_active,
--   (NOT is_premium OR premium_expires_at <= NOW()) AND usage_count >= 1 as is_limit_reached
-- FROM usage_counts
-- WHERE user_id = 'user_xxx';
