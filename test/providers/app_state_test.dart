import 'package:flutter_test/flutter_test.dart';
import 'package:lume_lucy_paperwall/providers/app_state.dart';
import 'package:lume_lucy_paperwall/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppState VIP 功能测试', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
      SharedPreferences.setMockInitialValues({});
    });

    group('初始化', () {
      test('应该正确初始化 VIP 状态', () async {
        await appState.loadUserProfile();

        // 默认应该是普通用户
        expect(appState.isPremium, isFalse);
        expect(appState.remainingFreeUsage, greaterThanOrEqualTo(0));
        print('✅ 初始化完成: VIP=${appState.isPremium}, 剩余=${appState.remainingFreeUsage}');
      });
    });

    group('权限检查', () {
      test('canUseGeneration 应该返回正确的权限状态', () async {
        await appState.loadUserProfile();

        final canUse = await appState.canUseGeneration();

        // 首次应该可以使用
        expect(canUse, isTrue);
        print('✅ 首次使用权限: $canUse');
      });
    });

    group('VIP 激活', () {
      test('activatePremium 应该更新 VIP 状态', () async {
        await appState.loadUserProfile();

        // 激活前
        expect(appState.isPremium, isFalse);

        // 激活 VIP
        final success = await appState.activatePremium(
          'test_product',
          'test_transaction',
        );

        expect(success, isTrue);
        expect(appState.isPremium, isTrue);
        expect(appState.remainingFreeUsage, equals(-1)); // -1 表示无限
        print('✅ VIP 激活成功: ${appState.isPremium}');
      });
    });

    group('状态管理', () {
      test('重置状态应该清空所有数据', () async {
        await appState.loadUserProfile();

        // 设置一些状态
        appState.updateMood(0.5);
        appState.updateEnergy(0.8);
        appState.nextQuestion();

        // 重置
        appState.reset();

        expect(appState.answer.mood, equals(0.0));
        expect(appState.answer.energy, equals(0.0));
        expect(appState.currentQuestion, equals(0));
        expect(appState.wallpapers, isEmpty);
        expect(appState.selectedWallpaper, isNull);
        print('✅ 状态重置成功');
      });

      test('更新用户回答应该触发状态更新', () {
        appState.updateMood(0.7);
        expect(appState.answer.mood, equals(0.7));

        appState.updateEnergy(0.3);
        expect(appState.answer.energy, equals(0.3));

        appState.updateStyle(0.9);
        expect(appState.answer.style, equals(0.9));

        appState.updateInput('测试输入');
        expect(appState.answer.input, equals('测试输入'));

        print('✅ 状态更新成功');
      });

      test('问题导航应该正常工作', () {
        expect(appState.currentQuestion, equals(0));

        appState.nextQuestion();
        expect(appState.currentQuestion, equals(1));

        appState.nextQuestion();
        expect(appState.currentQuestion, equals(2));

        // 不能超过 2
        appState.nextQuestion();
        expect(appState.currentQuestion, equals(2));

        // 返回
        appState.previousQuestion();
        expect(appState.currentQuestion, equals(1));

        print('✅ 问题导航正常');
      });
    });
  });
}
