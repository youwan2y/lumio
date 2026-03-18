import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supabase 服务 - VIP 功能和使用次数管理
class SupabaseService {
  // Supabase 配置（从 CLAUDE.md 中读取）
  static const String supabaseUrl = 'https://ppazhdurwozbjiczxapn.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBwYXpoZHVyd296YmppY3p4YXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MDg5MjEsImV4cCI6MjA4OTM4NDkyMX0.XM6OKhHkQmZYS07WipCbUHA9yHcAD_Z7HRzUf3TzxbY';

  late final SupabaseClient _client;
  String? _userId;
  String? _deviceId;

  // 单例模式
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  /// 初始化 Supabase
  Future<void> initialize() async {
    try {
      // 检查是否已初始化
      if (_userId != null) {
        debugPrint('✅ Supabase 已初始化');
        return;
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: kDebugMode,
      );
      _client = Supabase.instance.client;

      // 获取或创建用户 ID
      await _getOrCreateUserId();

      debugPrint('✅ Supabase 初始化成功');
      debugPrint('👤 用户 ID: $_userId');
    } catch (e) {
      debugPrint('❌ Supabase 初始化失败: $e');
      rethrow;
    }
  }

  /// 获取或创建用户 ID
  Future<void> _getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();

    // 获取或创建用户 ID
    _userId = prefs.getString('user_id');
    if (_userId == null) {
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('user_id', _userId!);
    }

    // 获取设备 ID
    _deviceId = prefs.getString('device_id');
    if (_deviceId == null) {
      _deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('device_id', _deviceId!);
    }
  }

  /// 检查用户是否可以使用生成功能
  /// 返回：{canUse: bool, remaining: int, isPremium: bool, message: String}
  Future<Map<String, dynamic>> checkAndUse() async {
    try {
      // 1. 查询用户数据
      final response = await _client
          .from('usage_counts')
          .select()
          .eq('user_id', _userId!)
          .maybeSingle();

      Map<String, dynamic> userData;

      if (response == null) {
        // 首次使用，创建用户记录
        userData = await _createUserRecord();
      } else {
        userData = response;
      }

      // 2. 检查 VIP 状态
      final isPremium = userData['is_premium'] as bool? ?? false;
      final premiumExpiresAt = userData['premium_expires_at'] as String?;
      final usageCount = userData['usage_count'] as int? ?? 0;

      // 检查 VIP 是否过期
      bool isVipActive = false;
      if (isPremium && premiumExpiresAt != null) {
        final expiresAt = DateTime.parse(premiumExpiresAt);
        isVipActive = expiresAt.isAfter(DateTime.now());

        // 如果 VIP 已过期，更新数据库
        if (!isVipActive && isPremium) {
          await _updatePremiumStatus(false, null);
        }
      }

      // 3. 判断是否可以使用
      bool canUse;
      int remaining;
      String message;

      if (isVipActive) {
        // VIP 用户：无限使用
        canUse = true;
        remaining = -1; // -1 表示无限
        message = 'VIP 用户，享受无限次生成';

        // 增加使用次数（统计用）
        await _incrementUsageCount(usageCount);
      } else if (usageCount < 1) {
        // 普通用户：还可以使用
        canUse = true;
        remaining = 1 - usageCount;
        message = '剩余 $remaining 次免费使用机会';

        // 增加使用次数
        await _incrementUsageCount(usageCount);
      } else {
        // 普通用户：已用完
        canUse = false;
        remaining = 0;
        message = '免费使用次数已用完，请升级到 VIP';
      }

      return {
        'canUse': canUse,
        'remaining': remaining,
        'isPremium': isVipActive,
        'usageCount': usageCount + (canUse ? 1 : 0),
        'message': message,
      };
    } catch (e) {
      debugPrint('❌ 检查使用权限失败: $e');
      return {
        'canUse': false,
        'remaining': 0,
        'isPremium': false,
        'message': '检查权限失败: $e',
      };
    }
  }

  /// 创建用户记录
  Future<Map<String, dynamic>> _createUserRecord() async {
    final data = {
      'user_id': _userId,
      'device_id': _deviceId,
      'usage_count': 0,
      'is_premium': false,
    };

    await _client.from('usage_counts').insert(data);
    return data;
  }

  /// 增加使用次数
  Future<void> _incrementUsageCount(int currentCount) async {
    await _client
        .from('usage_counts')
        .update({'usage_count': currentCount + 1})
        .eq('user_id', _userId!);
  }

  /// 更新 VIP 状态
  Future<void> _updatePremiumStatus(bool isPremium, DateTime? expiresAt) async {
    final data = {
      'is_premium': isPremium,
      'premium_expires_at': expiresAt?.toIso8601String(),
    };

    await _client
        .from('usage_counts')
        .update(data)
        .eq('user_id', _userId!);
  }

  /// 激活 VIP（购买成功后调用）
  Future<bool> activatePremium(String productId, String transactionId) async {
    try {
      // 1. 记录购买
      await _client.from('purchases').insert({
        'user_id': _userId,
        'product_id': productId,
        'transaction_id': transactionId,
        'purchase_date': DateTime.now().toIso8601String(),
        'expires_date': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        'is_valid': true,
      });

      // 2. 更新 VIP 状态
      await _updatePremiumStatus(
        true,
        DateTime.now().add(Duration(days: 30)),
      );

      debugPrint('✅ VIP 激活成功');
      return true;
    } catch (e) {
      debugPrint('❌ VIP 激活失败: $e');
      return false;
    }
  }

  /// 获取用户 ID
  String? get userId => _userId;

  /// 获取设备 ID
  String? get deviceId => _deviceId;
}
