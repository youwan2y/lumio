import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/page_transitions.dart';
import '../widgets/premium_dialog.dart';
import 'card_screen.dart';

/// 加载页面
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // 延迟到构建完成后开始生成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generate();
    });
  }

  Future<void> _generate() async {
    final state = context.read<AppState>();
    final success = await state.generateWallpapers();

    if (!success && mounted) {
      // 生成失败，检查是否需要显示 VIP 对话框
      if (state.loadingMessage.contains('免费使用次数已用完')) {
        _showPremiumDialog();
      }
      return;
    }

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        FadeScaleRoute(page: const CardScreen()),
      );
    }
  }

  void _showPremiumDialog() {
    final state = context.read<AppState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PremiumDialog(
        remainingUses: state.remainingFreeUsage,
        onPurchase: () {
          Navigator.of(context).pop();
          state.buyVIP();
        },
      ),
    ).then((_) {
      // 对话框关闭后返回上一页
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 动画
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * 3.14159,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              '✦',
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // 状态文字
                  Text(
                    state.loadingMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.gray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 进度指示
                  const SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: AppTheme.lightGray,
                      color: AppTheme.black,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
