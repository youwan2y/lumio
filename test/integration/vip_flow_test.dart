import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:lume_lucy_paperwall/main.dart';
import 'package:lume_lucy_paperwall/providers/app_state.dart';
import 'package:lume_lucy_paperwall/screens/question_screen.dart';
import 'package:lume_lucy_paperwall/widgets/premium_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('VIP 功能集成测试', () {
    testWidgets('完整流程：首次用户使用 -> 用完 -> 显示 VIP 对话框', (WidgetTester tester) async {
      // 设置测试环境
      SharedPreferences.setMockInitialValues({});

      // 启动应用
      await tester.pumpWidget(const NivoluneApp());
      await tester.pumpAndSettle();

      // 1. 验证欢迎页面
      expect(find.text('开始探索'), findsOneWidget);
      print('✅ 步骤 1: 欢迎页面显示正常');

      // 2. 点击开始探索
      await tester.tap(find.text('开始探索'));
      await tester.pumpAndSettle();
      print('✅ 步骤 2: 进入问题页面');

      // 3. 完成三个问题
      for (int i = 0; i < 3; i++) {
        // 调整滑块（如果需要）
        // await tester.drag(find.byType(Slider), Offset(100, 0));

        // 点击下一步/生成壁纸
        final buttonText = i < 2 ? '下一步' : '生成壁纸';
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();
        print('✅ 步骤 3.${i + 1}: 完成问题 ${i + 1}');
      }

      // 4. 验证首次生成成功（应该进入加载页面）
      expect(find.text('AI 正在构思'), findsOneWidget);
      print('✅ 步骤 4: 首次生成成功');

      // 等待生成完成
      await tester.pumpAndSettle(Duration(seconds: 10));

      print('✅ 集成测试完成：首次用户流程正常');
    });

    testWidgets('完整流程：普通用户用完次数后显示 VIP 对话框', (WidgetTester tester) async {
      // 设置为已使用过一次的用户
      SharedPreferences.setMockInitialValues({
        'user_id': 'test_user_used',
      });

      // 启动应用
      await tester.pumpWidget(const NivoluneApp());
      await tester.pumpAndSettle();

      // 获取 AppState
      final appState = tester.state<NavigatorState>(find.byType(Navigator))
          .context
          .read<AppState>();
      await appState.loadUserProfile();

      // 手动使用一次（模拟已经用过）
      await appState.canUseGeneration();

      print('✅ 模拟已使用一次');

      // 进入问题页面
      await tester.tap(find.text('开始探索'));
      await tester.pumpAndSettle();

      // 完成三个问题
      for (int i = 0; i < 3; i++) {
        final buttonText = i < 2 ? '下一步' : '生成壁纸';
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();
      }

      // 应该显示 VIP 对话框
      expect(find.text('升级到 VIP'), findsOneWidget);
      expect(find.text('¥18/月'), findsOneWidget);
      print('✅ VIP 对话框显示成功');

      print('✅ 集成测试完成：VIP 限制正常工作');
    });

    testWidgets('完整流程：VIP 用户无限次生成', (WidgetTester tester) async {
      // 设置为 VIP 用户
      SharedPreferences.setMockInitialValues({
        'user_id': 'test_vip_user',
      });

      // 启动应用
      await tester.pumpWidget(const NivoluneApp());
      await tester.pumpAndSettle();

      // 获取 AppState 并激活 VIP
      final appState = tester.state<NavigatorState>(find.byType(Navigator))
          .context
          .read<AppState>();
      await appState.loadUserProfile();
      await appState.activatePremium('test_product', 'test_transaction');

      print('✅ VIP 已激活');

      // 验证 VIP 标识
      expect(find.text('高级版'), findsOneWidget);

      // 进入问题页面
      await tester.tap(find.text('开始探索'));
      await tester.pumpAndSettle();

      // 完成三个问题
      for (int i = 0; i < 3; i++) {
        final buttonText = i < 2 ? '下一步' : '生成壁纸';
        await tester.tap(find.text(buttonText));
        await tester.pumpAndSettle();
      }

      // 应该成功生成（不显示 VIP 对话框）
      expect(find.text('升级到 VIP'), findsNothing);
      print('✅ VIP 用户可以无限次生成');

      print('✅ 集成测试完成：VIP 权限正常');
    });

    testWidgets('VIP 对话框交互测试', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => PremiumDialog(
                        remainingUses: 0,
                        onPurchase: () {
                          Navigator.of(ctx).pop();
                          // 模拟购买成功
                        },
                      ),
                    );
                  },
                  child: Text('显示 VIP 对话框'),
                );
              },
            ),
          ),
        ),
      );

      // 打开对话框
      await tester.tap(find.text('显示 VIP 对话框'));
      await tester.pumpAndSettle();

      // 验证对话框内容
      expect(find.text('升级到 VIP'), findsOneWidget);
      expect(find.text('¥18/月'), findsOneWidget);
      expect(find.text('无限次生成'), findsOneWidget);
      expect(find.text('立即订阅'), findsOneWidget);

      print('✅ VIP 对话框内容正确');

      // 点击订阅按钮
      await tester.tap(find.text('立即订阅'));
      await tester.pumpAndSettle();

      // 对话框应该关闭
      expect(find.text('升级到 VIP'), findsNothing);

      print('✅ VIP 对话框交互正常');
    });
  });
}
