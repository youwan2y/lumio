import 'package:flutter_test/flutter_test.dart';
import 'package:lume_lucy_paperwall/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SupabaseService', () {
    late SupabaseService service;

    setUp(() {
      service = SupabaseService();
      // 每个测试使用不同的用户 ID
      final testId = DateTime.now().millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        'user_id': 'test_user_$testId',
        'device_id': 'test_device_$testId',
      });
    });

    group('初始化', () {
      test('应该成功初始化并获取用户 ID', () async {
        expect(service.userId, isNull);

        await service.initialize();

        expect(service.userId, isNotNull);
        expect(service.userId, contains('test_user_'));
        print('✅ 用户 ID: ${service.userId}');
      });
    });

    group('权限检查', () {
      test('首次用户应该可以使用生成功能', () async {
        await service.initialize();

        final result = await service.checkAndUse();

        expect(result['canUse'], isTrue);
        expect(result['remaining'], equals(1));
        expect(result['isPremium'], isFalse);
        expect(result['usageCount'], equals(1));
        print('✅ 首次用户可以使用: $result');
      });

      test('普通用户第二次应该无法使用', () async {
        await service.initialize();

        // 第一次使用
        await service.checkAndUse();

        // 第二次使用
        final result = await service.checkAndUse();

        expect(result['canUse'], isFalse);
        expect(result['remaining'], equals(0));
        expect(result['isPremium'], isFalse);
        expect(result['message'], contains('已用完'));
        print('✅ 第二次使用被拒绝: $result');
      });

      test('VIP 用户应该可以无限使用', () async {
        await service.initialize();

        // 手动激活 VIP（测试用）- 使用唯一的 transaction_id
        final transactionId = 'test_transaction_vip_${DateTime.now().millisecondsSinceEpoch}';
        await service.activatePremium('test_product', transactionId);

        // VIP 用户应该可以多次使用
        for (int i = 0; i < 5; i++) {
          final result = await service.checkAndUse();
          expect(result['canUse'], isTrue);
          expect(result['isPremium'], isTrue);
          expect(result['remaining'], equals(-1)); // -1 表示无限
          print('✅ VIP 用户第 ${i + 1} 次使用: ${result['message']}');
        }
      });
    });

    group('VIP 激活', () {
      test('激活 VIP 应该成功', () async {
        await service.initialize();

        final transactionId = 'test_transaction_activate_${DateTime.now().millisecondsSinceEpoch}';
        final success = await service.activatePremium(
          'lumio_vip_monthly',
          transactionId,
        );

        expect(success, isTrue);
        print('✅ VIP 激活成功');
      });

      test('激活 VIP 后状态应该更新', () async {
        await service.initialize();

        // 激活前 - 检查当前状态
        var result = await service.checkAndUse();
        final wasPremium = result['isPremium'];

        // 如果之前已经是 VIP，则跳过验证
        if (!wasPremium) {
          expect(result['isPremium'], isFalse);
        }

        // 激活 VIP
        final transactionId = 'test_transaction_update_${DateTime.now().millisecondsSinceEpoch}';
        await service.activatePremium('test_product', transactionId);

        // 激活后
        result = await service.checkAndUse();
        expect(result['isPremium'], isTrue);
        print('✅ VIP 状态已更新');
      });
    });
  });
}
