import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// VIP 订阅对话框
class PremiumDialog extends StatelessWidget {
  final int remainingUses;
  final VoidCallback? onPurchase;

  const PremiumDialog({
    super.key,
    required this.remainingUses,
    this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                size: 40,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 24),

            // 标题
            const Text(
              '升级到 VIP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
            const SizedBox(height: 16),

            // 描述
            Text(
              remainingUses <= 0
                  ? '您已用完免费使用次数\n升级到 VIP，享受无限次生成'
                  : '剩余 $remainingUses 次免费使用机会\n升级到 VIP，享受无限次生成',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.gray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // VIP 价格
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accent, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    '¥18/月',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accent,
                    ),
                  ),
                  Text(
                    '自动续费，可随时取消',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.gray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // VIP 权益列表
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildFeatureItem('✨ 无限次生成壁纸'),
                  _buildFeatureItem('⚡ 优先体验新功能'),
                  _buildFeatureItem('🎨 去除水印'),
                  _buildFeatureItem('💎 专属客服支持'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 订阅按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPurchase ?? () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('内购功能即将上线，敬请期待')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '立即订阅',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 稍后提醒按钮
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '稍后提醒',
                style: TextStyle(
                  color: AppTheme.gray,
                ),
              ),
            ),

            // 恢复购买
            TextButton(
              onPressed: () {
                // TODO: 实现恢复购买
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('恢复购买功能即将上线')),
                );
              },
              child: const Text(
                '恢复购买',
                style: TextStyle(
                  color: AppTheme.gray,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
