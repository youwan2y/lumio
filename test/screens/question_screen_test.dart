import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lume_lucy_paperwall/screens/question_screen.dart';
import 'package:lume_lucy_paperwall/providers/app_state.dart';
import 'package:lume_lucy_paperwall/config/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('QuestionScreen VIP 状态显示测试', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
      SharedPreferences.setMockInitialValues({});
    });

    Future<void> pumpQuestionScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: MaterialApp(
            home: QuestionScreen(),
          ),
        ),
      );
    }

    testWidgets('应该显示 VIP 高级版标识', (WidgetTester tester) async {
      // 设置为 VIP 用户
      await appState.loadUserProfile();
      await appState.activatePremium('test', 'test');

      await pumpQuestionScreen(tester);

      // 验证 VIP 标识
      expect(find.text('高级版'), findsOneWidget);
      expect(find.byIcon(Icons.all_inclusive), findsOneWidget);

      print('✅ VIP 高级版标识显示正确');
    });

    testWidgets('应该显示剩余免费次数', (WidgetTester tester) async {
      // 设置为普通用户，有剩余次数
      await appState.loadUserProfile();

      await pumpQuestionScreen(tester);

      // 验证剩余次数显示（可能是 "剩余 1 次" 或类似）
      final remainingText = find.textContaining('剩余');
      expect(remainingText, findsOneWidget);

      print('✅ 剩余次数显示正确');
    });

    testWidgets('应该显示次数已用完警告', (WidgetTester tester) async {
      // 设置为普通用户，已用完次数
      await appState.loadUserProfile();
      await appState.canUseGeneration(); // 使用一次
      await appState.canUseGeneration(); // 再次使用（应该用完）

      await pumpQuestionScreen(tester);

      // 验证警告标识
      expect(find.text('次数已用完'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);

      print('✅ 次数已用完警告显示正确');
    });

    testWidgets('应该显示当前问题进度', (WidgetTester tester) async {
      await appState.loadUserProfile();

      await pumpQuestionScreen(tester);

      // 验证进度显示
      expect(find.text('1/3'), findsOneWidget);

      // 进入下一个问题
      appState.nextQuestion();
      await tester.pump();

      expect(find.text('2/3'), findsOneWidget);

      print('✅ 问题进度显示正确');
    });

    testWidgets('下一步按钮应该正常工作', (WidgetTester tester) async {
      await appState.loadUserProfile();

      await pumpQuestionScreen(tester);

      // 第一页应该显示"下一步"
      expect(find.text('下一步'), findsOneWidget);

      // 点击下一步
      await tester.tap(find.text('下一步'));
      await tester.pump();

      // 应该进入第二页
      expect(appState.currentQuestion, equals(1));

      print('✅ 下一步按钮工作正常');
    });

    testWidgets('最后一页应该显示"生成壁纸"按钮', (WidgetTester tester) async {
      await appState.loadUserProfile();

      await pumpQuestionScreen(tester);

      // 进入第三页
      appState.nextQuestion();
      appState.nextQuestion();
      await tester.pump();

      // 应该显示"生成壁纸"
      expect(find.text('生成壁纸'), findsOneWidget);

      print('✅ 生成壁纸按钮显示正确');
    });

    testWidgets('返回按钮应该正常工作', (WidgetTester tester) async {
      await appState.loadUserProfile();

      await pumpQuestionScreen(tester);

      // 进入第二页
      appState.nextQuestion();
      await tester.pump();

      // 点击返回按钮
      final backButton = find.byIcon(Icons.arrow_back_ios);
      await tester.tap(backButton);
      await tester.pump();

      // 应该返回第一页
      expect(appState.currentQuestion, equals(0));

      print('✅ 返回按钮工作正常');
    });

    testWidgets('第一页返回按钮应该禁用', (WidgetTester tester) async {
      await appState.loadUserProfile();

      await pumpQuestionScreen(tester);

      // 查找返回按钮
      final backButton = find.byIcon(Icons.arrow_back_ios);
      expect(backButton, findsOneWidget);

      // 验证按钮是否禁用（通过 IconButton 的 onPressed 为 null）
      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: backButton,
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNull);

      print('✅ 第一页返回按钮已禁用');
    });
  });
}
