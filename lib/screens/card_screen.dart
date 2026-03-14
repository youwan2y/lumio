import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';
import '../widgets/page_transitions.dart';
import 'result_screen.dart';

/// 卡牌选择页面
class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  void initState() {
    super.initState();
    // 预加载所有图片
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadAllImages();
    });
  }

  void _preloadAllImages() {
    final state = context.read<AppState>();
    for (final wallpaper in state.wallpapers) {
      precacheImage(
        CachedNetworkImageProvider(wallpaper.imageUrl),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final hasSelected = state.selectedWallpaper != null;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 标题
                Text(
                  hasSelected ? '恭喜你!' : '选择你的幸运卡牌',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasSelected ? '发现了专属壁纸' : '翻开一张，发现专属壁纸',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.gray,
                  ),
                ),
                const SizedBox(height: 30),

                // 卡牌网格
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: state.wallpapers.length,
                      itemBuilder: (context, index) {
                        final wallpaper = state.wallpapers[index];
                        final canFlip = !hasSelected;
                        final isRevealed = wallpaper.isRevealed;

                        // 已翻转的卡牌
                        if (isRevealed) {
                          return FlipCard(
                            wallpaper: wallpaper,
                            canFlip: false,
                            onFlip: () {},
                          );
                        }

                        // 未翻转的卡牌（预渲染）
                        return FlipCard(
                          wallpaper: wallpaper,
                          canFlip: canFlip,
                          onFlip: () {
                            state.selectCard(index);
                            // 延迟跳转
                            Future.delayed(const Duration(seconds: 2), () {
                              if (context.mounted) {
                                Navigator.of(context).pushReplacement(
                                  FadeScaleRoute(page: const ResultScreen()),
                                );
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),

                // 提示
                if (!hasSelected)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppTheme.gray.withValues(alpha: 0.8)),
                        const SizedBox(width: 8),
                        Text(
                          '仅限一次机会',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.gray.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
