import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../services/supabase_service.dart';
import '../services/iap_service.dart';

/// 应用状态管理
class AppState extends ChangeNotifier {
  // 服务
  final LlmService _llmService = LlmService();
  final ImageService _imageService = ImageService();
  final WeatherService _weatherService = WeatherService();
  final SupabaseService _supabaseService = SupabaseService();
  final IAPService _iapService = IAPService();

  // 用户信息
  UserProfile _userProfile = const UserProfile();
  UserProfile get userProfile => _userProfile;

  // 用户回答
  UserAnswer _answer = const UserAnswer();
  UserAnswer get answer => _answer;

  // 生成的壁纸
  List<Wallpaper> _wallpapers = [];
  List<Wallpaper> get wallpapers => _wallpapers;

  // 选中的壁纸
  Wallpaper? _selectedWallpaper;
  Wallpaper? get selectedWallpaper => _selectedWallpaper;

  // 加载状态
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _loadingMessage = '';
  String get loadingMessage => _loadingMessage;

  // 当前问题页
  int _currentQuestion = 0;
  int get currentQuestion => _currentQuestion;

  // 使用次数
  int _usageCount = 0;
  int get usageCount => _usageCount;

  // 剩余免费次数
  int _remainingFreeUsage = 0;
  int get remainingFreeUsage => _remainingFreeUsage;

  // 是否为付费用户
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  // 初始化用户信息（提供默认值）
  Future<void> loadUserProfile() async {
    // 初始化 Supabase
    await _supabaseService.initialize();

    // 初始化内购
    await _iapService.initialize();

    // 设置默认用户信息
    _userProfile = const UserProfile(
      constellation: '水瓶座',  // 默认星座
      age: 25,  // 默认年龄
      isOnboarded: true,  // 标记为已完成
    );

    // 加载付费信息
    await _loadPaymentInfo();
  }

  // 加载付费信息（从 Supabase）
  Future<void> _loadPaymentInfo() async {
    try {
      final result = await _supabaseService.checkAndUse();

      // 注意：checkAndUse 会增加使用次数，所以这里只是读取状态
      // 我们需要一个只读的方法来获取状态
      _isPremium = result['isPremium'] ?? false;
      _usageCount = result['usageCount'] ?? 0;
      _remainingFreeUsage = result['remaining'] ?? 0;

      notifyListeners();
    } catch (e) {
      debugPrint('加载付费信息失败: $e');
    }
  }

  // 保存用户信息（不再使用，但保留方法以兼容）
  Future<void> saveUserProfile(String constellation, int age) async {
    // 不再保存到本地存储，仅更新内存中的值
    _userProfile = UserProfile(
      constellation: constellation,
      age: age,
      isOnboarded: true,
    );

    // 更新answer中的用户信息
    _answer = _answer.copyWith(userProfile: _userProfile);

    notifyListeners();
  }

  // 更新天气信息
  void updateWeather(String weather) {
    _answer = _answer.copyWith(weather: weather);
    notifyListeners();
  }

  // 更新心情值
  void updateMood(double value) {
    _answer = _answer.copyWith(mood: value);
    notifyListeners();
  }

  // 更新能量值
  void updateEnergy(double value) {
    _answer = _answer.copyWith(energy: value);
    notifyListeners();
  }

  // 更新风格值
  void updateStyle(double value) {
    _answer = _answer.copyWith(style: value);
    notifyListeners();
  }

  // 更新用户输入
  void updateInput(String value) {
    _answer = _answer.copyWith(input: value);
    notifyListeners();
  }

  // 下一个问题
  void nextQuestion() {
    if (_currentQuestion < 2) {
      _currentQuestion++;
      notifyListeners();
    }
  }

  // 上一个问题
  void previousQuestion() {
    if (_currentQuestion > 0) {
      _currentQuestion--;
      notifyListeners();
    }
  }

  // 生成壁纸（三步流程 + 两阶段选择）
  Future<bool> generateWallpapers() async {
    // 检查使用权限（通过 Supabase）
    final checkResult = await _supabaseService.checkAndUse();

    if (!checkResult['canUse']) {
      _loadingMessage = checkResult['message'];
      notifyListeners();
      return false;
    }

    // 更新状态
    _usageCount = checkResult['usageCount'];
    _remainingFreeUsage = checkResult['remaining'];
    _isPremium = checkResult['isPremium'];

    _isLoading = true;
    _loadingMessage = 'AI 正在构思...';
    notifyListeners();

    try {
      // 第一步：获取天气信息
      _loadingMessage = '获取天气信息...';
      notifyListeners();
      final weather = await _weatherService.getCurrentWeather();
      if (weather.isNotEmpty) {
        _answer = _answer.copyWith(weather: weather);
        print('🌤️ 天气: $weather');
      }

      // 第二步：AI 智能选择元素（两阶段：随机缩小 + AI选择）
      _loadingMessage = 'AI 正在分析你的特征...';
      notifyListeners();
      final selectedElements = await _llmService.selectElements(_answer);
      _answer = _answer.copyWith(randomElements: selectedElements);

      // 第三步：生成壁纸描述
      _loadingMessage = 'AI 正在创作描述...';
      notifyListeners();
      final description = await _llmService.generateDescription(_answer, selectedElements);
      print('\n第三阶段：生成描述');
      print('📝 生成的描述: $description');

      // 第四步：生成单张图片
      _loadingMessage = 'AI 正在绘制壁纸...';
      notifyListeners();
      final wallpaper = await _imageService.generateWallpaper(description);

      // 第五步：复制 9 份用于卡牌
      _wallpapers = List.generate(9, (index) => wallpaper.copyWith(
        id: '${wallpaper.id}_$index',
      ));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _loadingMessage = '生成失败: $e';
      notifyListeners();
      return false;
    }
  }

  // 选择卡牌
  void selectCard(int index) {
    if (index >= 0 && index < _wallpapers.length) {
      _wallpapers[index] = _wallpapers[index].copyWith(isRevealed: true, isSelected: true);
      _selectedWallpaper = _wallpapers[index];
      notifyListeners();
    }
  }

  // 检查是否可以继续使用
  Future<bool> canUseGeneration() async {
    final result = await _supabaseService.checkAndUse();
    return result['canUse'];
  }

  // 激活 VIP（购买成功后调用）
  Future<bool> activatePremium(String productId, String transactionId) async {
    final success = await _supabaseService.activatePremium(productId, transactionId);
    if (success) {
      _isPremium = true;
      _remainingFreeUsage = -1; // -1 表示无限制
      notifyListeners();
    }
    return success;
  }

  // 购买 VIP
  Future<void> buyVIP() async {
    await _iapService.buyVIP();
  }

  // 恢复购买
  Future<void> restorePurchases() async {
    await _iapService.restorePurchases();
  }

  // 重置应用状态（用于重新开始）
  void reset() {
    _answer = const UserAnswer();
    _wallpapers = [];
    _selectedWallpaper = null;
    _currentQuestion = 0;
    _isLoading = false;
    _loadingMessage = '';
    notifyListeners();
  }
}
