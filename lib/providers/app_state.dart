import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/services.dart';

/// 应用状态管理
class AppState extends ChangeNotifier {
  // 服务
  final LlmService _llmService = LlmService();
  final ImageService _imageService = ImageService();
  final WeatherService _weatherService = WeatherService();

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

  // 初始化用户信息（从本地存储加载）
  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final constellation = prefs.getString('constellation');
    final age = prefs.getInt('age');
    final isOnboarded = prefs.getBool('isOnboarded') ?? false;

    _userProfile = UserProfile(
      constellation: constellation,
      age: age,
      isOnboarded: isOnboarded,
    );
    notifyListeners();
  }

  // 保存用户信息
  Future<void> saveUserProfile(String constellation, int age) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('constellation', constellation);
    await prefs.setInt('age', age);
    await prefs.setBool('isOnboarded', true);

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

  // 重置
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
