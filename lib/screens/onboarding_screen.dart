import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';
import '../widgets/page_transitions.dart';
import 'question_screen.dart';

/// 首次登录用户信息输入页面
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? _selectedConstellation;
  bool _isLoading = false;

  // 星座列表（使用星座符号）
  static const List<Map<String, dynamic>> _constellations = [
    {'name': '白羊座', 'symbol': '♈'},
    {'name': '金牛座', 'symbol': '♉'},
    {'name': '双子座', 'symbol': '♊'},
    {'name': '巨蟹座', 'symbol': '♋'},
    {'name': '狮子座', 'symbol': '♌'},
    {'name': '处女座', 'symbol': '♍'},
    {'name': '天秤座', 'symbol': '♎'},
    {'name': '天蝎座', 'symbol': '♏'},
    {'name': '射手座', 'symbol': '♐'},
    {'name': '摩羯座', 'symbol': '♑'},
    {'name': '水瓶座', 'symbol': '♒'},
    {'name': '双鱼座', 'symbol': '♓'},
  ];

  Future<void> _handleSubmit() async {
    if (_selectedConstellation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择你的星座'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 保存用户信息（不保存年龄）
      await context.read<AppState>().saveUserProfile(
        _selectedConstellation!,
        0, // 默认年龄为0，表示未设置
      );

      // 跳转到问题页面
      if (mounted) {
        Navigator.of(context).pushReplacement(
          FadePageRoute(page: const QuestionScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // 标题
              const Text(
                '欢迎使用 Lumio',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '选择你的星座，开始探索',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.gray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 星座选择网格
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: _constellations.length,
                itemBuilder: (context, index) {
                  final constellation = _constellations[index];
                  final isSelected = _selectedConstellation == constellation['name'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedConstellation = constellation['name'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.black : AppTheme.lightGray,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? null
                            : Border.all(color: AppTheme.gray.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            constellation['symbol'] as String,
                            style: TextStyle(
                              fontSize: 28,
                              color: isSelected ? AppTheme.white : AppTheme.gray,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            constellation['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? AppTheme.white : AppTheme.black,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 说明文字
              const Text(
                '星座信息将帮助我们为你生成更个性化的壁纸',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.gray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // 提交按钮
              PrimaryButton(
                text: '开始探索',
                onPressed: _handleSubmit,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
