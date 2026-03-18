import 'package:shared_preferences/shared_preferences.dart';

/// 付费服务
class PaymentService {
  static const int _freeUsageLimit = 10; // 免费使用次数
  static const String _usageCountKey = 'usage_count';
  static const String _isPremiumKey = 'is_premium';

  // 获取使用次数
  Future<int> getUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_usageCountKey) ?? 0;
  }

  // 增加使用次数
  Future<void> incrementUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = await getUsageCount();
    await prefs.setInt(_usageCountKey, currentCount + 1);
  }

  // 检查是否可以继续使用
  Future<bool> canUseGeneration() async {
    final isPremium = await isPremiumUser();
    if (isPremium) return true;

    final count = await getUsageCount();
    return count < _freeUsageLimit;
  }

  // 获取剩余免费次数
  Future<int> getRemainingFreeUsage() async {
    final isPremium = await isPremiumUser();
    if (isPremium) return -1; // -1 表示无限制

    final count = await getUsageCount();
    final remaining = _freeUsageLimit - count;
    return remaining > 0 ? remaining : 0;
  }

  // 检查是否为付费用户
  Future<bool> isPremiumUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPremiumKey) ?? false;
  }

  // 设置为付费用户
  Future<void> setPremiumUser(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumKey, isPremium);
  }

  // 重置使用次数（测试用）
  Future<void> resetUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usageCountKey);
  }

  // 获取免费使用限制
  int get freeUsageLimit => _freeUsageLimit;
}
