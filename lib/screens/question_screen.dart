import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';
import '../widgets/page_transitions.dart';
import 'loading_screen.dart';

/// 问题页面
class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // 顶部栏
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // 统一使用IconButton，保持布局一致性
                      IconButton(
                        onPressed: state.currentQuestion > 0 ? state.previousQuestion : null,
                        icon: const Icon(Icons.arrow_back_ios),
                        // 禁用时不透明，保持占位
                        style: IconButton.styleFrom(
                          disabledForegroundColor: Colors.transparent,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${state.currentQuestion + 1}/3',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.gray,
                        ),
                      ),
                    ],
                  ),
                ),

                // 问题内容
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: _buildQuestionContent(context, state),
                  ),
                ),

                // 进度指示器
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ProgressDots(current: state.currentQuestion),
                ),

                // 底部按钮
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: PrimaryButton(
                    text: state.currentQuestion < 2 ? '下一步' : '生成壁纸',
                    onPressed: () => _handleNext(context, state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionContent(BuildContext context, AppState state) {
    final question = Questions.all[state.currentQuestion];
    double value;
    ValueChanged<double> onChanged;

    switch (state.currentQuestion) {
      case 0:
        value = state.answer.mood;
        onChanged = state.updateMood;
        break;
      case 1:
        value = state.answer.energy;
        onChanged = state.updateEnergy;
        break;
      case 2:
        return _buildQuestion3(context, state, question);
      default:
        value = state.answer.mood;
        onChanged = state.updateMood;
    }

    return MoodSlider(
      value: value,
      onChanged: onChanged,
      question: question,
    );
  }

  Widget _buildQuestion3(BuildContext context, AppState state, Question question) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 问题标题
          const Text(
            '你喜欢什么样的风格?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            '选择你偏好的视觉风格',
            style: TextStyle(fontSize: 16, color: AppTheme.gray),
          ),
          const SizedBox(height: 30),

          // 数值显示
          Text(
            '${(state.answer.style * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 20),

          // 拖动条
          Slider(
            value: state.answer.style,
            onChanged: state.updateStyle,
          ),
          const SizedBox(height: 8),

          // 标签
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.brush, size: 16, color: AppTheme.gray),
                    const SizedBox(width: 4),
                    Text('抽象', style: TextStyle(fontSize: 14, color: AppTheme.gray)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.camera_alt, size: 16, color: AppTheme.gray),
                    const SizedBox(width: 4),
                    Text('写实', style: TextStyle(fontSize: 14, color: AppTheme.gray)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 输入框
          TextField(
            onChanged: state.updateInput,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '添加你的灵感...\n例如: 星空、海洋、樱花',
              hintStyle: TextStyle(color: AppTheme.gray),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext(BuildContext context, AppState state) {
    if (state.currentQuestion < 2) {
      state.nextQuestion();
    } else {
      // 跳转到加载页（书本翻页效果）
      Navigator.of(context).pushReplacement(
        BookPageRoute(page: const LoadingScreen()),
      );
    }
  }
}
