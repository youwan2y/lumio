import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Mock Supabase Client
class MockSupabaseClient extends Mock implements SupabaseClient {}

/// Mock GoTrue Client
class MockGoTrueClient extends Mock implements GoTrueClient {}

/// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

/// 测试辅助函数
class TestHelpers {
  /// 设置测试用的 SharedPreferences
  static Future<void> setupSharedPreferences({
    String? userId,
    String? deviceId,
  }) async {
    SharedPreferences.setMockInitialValues({
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
    });
  }

  /// 创建模拟的用户数据
  static Map<String, dynamic> createUserData({
    String userId = 'test_user',
    int usageCount = 0,
    bool isPremium = false,
    String? premiumExpiresAt,
  }) {
    return {
      'user_id': userId,
      'device_id': 'test_device',
      'usage_count': usageCount,
      'is_premium': isPremium,
      'premium_expires_at': premiumExpiresAt,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  /// 创建有效的 VIP 过期时间（30天后）
  static String createValidExpiryDate() {
    return DateTime.now().add(Duration(days: 30)).toIso8601String();
  }

  /// 创建已过期的 VIP 时间
  static String createExpiredExpiryDate() {
    return DateTime.now().subtract(Duration(days: 1)).toIso8601String();
  }
}
