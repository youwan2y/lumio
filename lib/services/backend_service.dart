import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 后端服务 - 安全的使用次数和付费管理
class BackendService {
  // TODO: 替换为你的后端 URL
  static const String baseUrl = 'https://your-backend.com';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  String? _userId;
  String? _deviceId;

  // 初始化 - 获取或创建用户 ID
  Future<void> initialize() async {
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

  // 检查使用权限并增加使用次数
  Future<Map<String, dynamic>> checkAndUse() async {
    try {
      final response = await _dio.post(
        '/check-and-use',
        data: {
          'userId': _userId,
          'deviceId': _deviceId,
        },
      );

      return response.data;
    } catch (e) {
      debugPrint('检查使用权限失败: $e');
      return {
        'canUse': false,
        'remaining': 0,
        'error': e.toString(),
      };
    }
  }

  // 验证购买
  Future<bool> verifyPurchase(String receiptData) async {
    try {
      final response = await _dio.post(
        '/verify-purchase',
        data: {
          'userId': _userId,
          'receiptData': receiptData,
        },
      );

      return response.data['success'] == true;
    } catch (e) {
      debugPrint('验证购买失败: $e');
      return false;
    }
  }

  // 生成壁纸（通过后端调用 AI API）
  Future<Map<String, dynamic>> generateWallpaper(String description) async {
    try {
      final response = await _dio.post(
        '/generate-wallpaper',
        data: {
          'userId': _userId,
          'description': description,
        },
      );

      return response.data;
    } catch (e) {
      debugPrint('生成壁纸失败: $e');
      throw Exception('生成失败: $e');
    }
  }

  // 获取用户 ID
  String? get userId => _userId;

  // 获取设备 ID
  String? get deviceId => _deviceId;
}
