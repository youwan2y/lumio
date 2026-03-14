import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_theme.dart';
import '../models/models.dart';

/// 自定义拖动条
class MoodSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Question question;

  const MoodSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 问题标题
        Text(
          question.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          question.subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.gray,
          ),
        ),
        const SizedBox(height: 60),

        // 数值显示
        Text(
          '${(value * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        const SizedBox(height: 40),

        // 拖动条
        Slider(
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),

        // 标签
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  question.minLabel,
                  style: const TextStyle(fontSize: 14, color: AppTheme.gray),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  question.maxLabel,
                  style: const TextStyle(fontSize: 14, color: AppTheme.gray),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 翻转卡牌
class FlipCard extends StatefulWidget {
  final Wallpaper wallpaper;
  final bool canFlip;
  final VoidCallback onFlip;

  const FlipCard({
    super.key,
    required this.wallpaper,
    required this.canFlip,
    required this.onFlip,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 延迟预加载图片，避免在initState中使用context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImage();
    });
  }

  void _preloadImage() {
    // 预加载缩略图（使用较小的缓存尺寸）
    precacheImage(
      CachedNetworkImageProvider(
        widget.wallpaper.imageUrl,
        maxHeight: 200,  // 限制高度以创建缩略图
        maxWidth: 150,   // 限制宽度
      ),
      context,
    );
  }

  void _flip() {
    if (!widget.canFlip || _isFlipped) return;
    setState(() => _isFlipped = true);
    _controller.forward();
    widget.onFlip();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final showFront = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showFront
                ? _buildFront()
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.help_outline,
              size: 40,
              color: AppTheme.white,
            ),
            const SizedBox(height: 8),
            Text(
              'LUCKY',
              style: TextStyle(
                color: AppTheme.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.lightGray,
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: widget.wallpaper.imageUrl,
        fit: BoxFit.cover,
        memCacheWidth: 300,  // 内存缓存宽度（缩略图）
        maxWidthDiskCache: 600,  // 磁盘缓存宽度
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: AppTheme.black),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error, color: AppTheme.gray),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// 进度指示器
class ProgressDots extends StatelessWidget {
  final int current;
  final int total;

  const ProgressDots({
    super.key,
    required this.current,
    this.total = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;
        final isCompleted = index < current;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppTheme.black
                : isActive
                    ? AppTheme.black
                    : AppTheme.lightGray,
            border: isActive
                ? Border.all(color: AppTheme.black, width: 2)
                : null,
          ),
        );
      }),
    );
  }
}

/// 渐变按钮
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.black,
          foregroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppTheme.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
