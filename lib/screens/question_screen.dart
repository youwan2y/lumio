import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/models.dart';
import '../providers/app_state.dart';
import '../widgets/widgets.dart';
import '../widgets/premium_dialog.dart';
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
                _buildTopBar(state),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: _buildQuestionContent(context, state),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ProgressDots(current: state.currentQuestion),
                ),
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

  Widget _buildTopBar(AppState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: state.currentQuestion > 0 ? state.previousQuestion : null,
            icon: const Icon(Icons.arrow_back_ios),
            style: IconButton.styleFrom(
              disabledForegroundColor: Colors.transparent,
            ),
          ),
          const Spacer(),
          _buildUsageIndicator(state),
          const SizedBox(width: 8),
          Text(
            '${state.currentQuestion + 1}/3',
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.gray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageIndicator(AppState state) {
    if (state.isPremium) {
      return _buildBadge(
        icon: Icons.all_inclusive,
        text: '高级版',
        color: AppTheme.accent,
      );
    } else if (state.remainingFreeUsage > 0) {
      return _buildBadge(
        icon: Icons.auto_awesome,
        text: '剩余 ${state.remainingFreeUsage} 次',
        color: AppTheme.accent,
      );
    } else {
      return _buildBadge(
        icon: Icons.warning,
        text: '次数已用完',
        color: Colors.red,
      );
    }
  }

  Widget _buildBadge({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(BuildContext context, AppState state) {
    if (state.currentQuestion == 2) {
      return _buildQuestion3(context, state);
    }

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
      default:
        value = state.answer.style;
        onChanged = state.updateStyle;
    }

    return MoodSlider(
      value: value,
      onChanged: onChanged,
      question: question,
    );
  }

  Widget _buildQuestion3(BuildContext context, AppState state) {
    final question = Questions.all[2];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Expanded(
          child: MoodSlider(
            value: state.answer.style,
            onChanged: state.updateStyle,
            question: question,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: state.updateInput,
            decoration: const InputDecoration(
              hintText: '或者输入你自己的想法...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Future<void> _handleNext(BuildContext context, AppState state) async {
    if (state.currentQuestion < 2) {
      state.nextQuestion();
    } else {
      final canGenerate = await state.canUseGeneration();

      if (!canGenerate && context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => PremiumDialog(
            remainingUses: state.remainingFreeUsage,
            onPurchase: () {
              Navigator.of(ctx).pop();
              state.buyVIP();
            },
          ),
        );
        return;
      }

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          FadeScaleRoute(page: const LoadingScreen()),
        );
      }
    }
  }
}
