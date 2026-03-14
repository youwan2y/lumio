import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';
import '../widgets/page_transitions.dart';
import 'onboarding_screen.dart';
import 'question_screen.dart';

/// 启动页
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // 加载用户信息
    await context.read<AppState>().loadUserProfile();
  }

  void _handleStart() {
    final state = context.read<AppState>();

    if (state.userProfile.isOnboarded) {
      // 已完成首次登录，跳转到问题页面
      Navigator.of(context).pushReplacement(
        BookPageRoute(page: const QuestionScreen()),
      );
    } else {
      // 首次登录，跳转到用户信息输入页面
      Navigator.of(context).pushReplacement(
        BookPageRoute(page: const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Spacer(),
              // Logo
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.black,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        '✦',
                        style: TextStyle(
                          fontSize: 48,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'LUMIO',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'LUCY WALL PAPER',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.gray,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Slogan
              const Text(
                '发现你的幸运壁纸',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.gray,
                ),
              ),
              const SizedBox(height: 40),
              // 开始按钮
              PrimaryButton(
                text: '开始探索',
                onPressed: _handleStart,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
