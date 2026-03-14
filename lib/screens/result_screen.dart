import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import '../config/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';
import '../widgets/page_transitions.dart';
import 'splash_screen.dart';

/// 结果页面
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final wallpaper = state.selectedWallpaper;

        if (wallpaper == null) {
          return const Scaffold(
            body: Center(child: Text('没有选中的壁纸')),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              // 壁纸预览
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: wallpaper.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.lightGray,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppTheme.black),
                        ),
                      ),
                    ),
                    // 顶部栏
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 20,
                          right: 20,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => _restart(context),
                              icon: const Icon(Icons.refresh, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 底部操作区
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 描述
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        wallpaper.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.gray,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 保存到相册按钮
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _saveToGallery(context, wallpaper.imageUrl),
                        icon: const Icon(Icons.download),
                        label: const Text('保存到相册'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.black,
                          side: const BorderSide(color: AppTheme.black),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 再来一次
                    PrimaryButton(
                      text: '再来一次',
                      onPressed: () => _restart(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveToGallery(BuildContext context, String url) async {
    try {
      // 请求相册权限
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('需要相册权限才能保存图片'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // 显示加载提示
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Text('正在保存...'),
              ],
            ),
            backgroundColor: AppTheme.black,
            duration: Duration(minutes: 1),
          ),
        );
      }

      // 下载图片
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      // 添加水印
      final watermarkedImage = await _addWatermark(response.data);

      // 保存到相册
      final result = await ImageGallerySaver.saveImage(
        watermarkedImage,
        quality: 100,
        name: 'lumio_wallpaper_${DateTime.now().millisecondsSinceEpoch}',
      );

      // 清除加载提示
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // 显示结果
      if (context.mounted) {
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ 已保存到相册'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存失败，请重试'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 添加水印到图片
  Future<Uint8List> _addWatermark(Uint8List imageData) async {
    try {
      // 解码图片
      final image = img.decodeImage(imageData);
      if (image == null) return imageData;

      // 水印文字
      const watermarkText = 'Lumio - Lucy Wall Paper';

      // 设置字体大小（根据图片高度自适应）
      final fontSize = (image.height * 0.025).round().clamp(12, 24);

      // 绘制文字
      final textImage = img.drawString(
        image,
        watermarkText,
        font: img.arial24,
        x: image.width - 280, // 距离右边
        y: image.height - 50, // 距离底部
        color: img.ColorRgba8(255, 255, 255, 128), // 白色半透明
      );

      // 编码为 JPEG
      return Uint8List.fromList(img.encodeJpg(textImage, quality: 95));
    } catch (e) {
      // 如果添加水印失败，返回原图
      print('添加水印失败: $e');
      return imageData;
    }
  }

  void _restart(BuildContext context) {
    context.read<AppState>().reset();
    Navigator.of(context).pushAndRemoveUntil(
      BookPageRoute(page: const SplashScreen()),
      (route) => false,
    );
  }
}
