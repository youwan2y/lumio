import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'supabase_service.dart';

/// 内购服务
class IAPService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final SupabaseService _supabaseService = SupabaseService();

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // VIP 产品 ID
  static const String vipMonthlyProductId = 'lumio_vip_monthly';

  // 单例模式
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  /// 初始化内购
  Future<void> initialize() async {
    // 检查内购是否可用
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      debugPrint('❌ 内购不可用');
      return;
    }

    // 监听购买流
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: _updateStreamOnDone,
      onError: _updateStreamOnError,
    );

    debugPrint('✅ 内购初始化成功');
  }

  /// 购买更新回调
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          debugPrint('⏳ 购买中...');
          _showPendingUI();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          debugPrint('✅ 购买成功: ${purchaseDetails.productID}');
          // 验证购买
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            // 激活 VIP
            await _supabaseService.activatePremium(
              purchaseDetails.productID,
              purchaseDetails.purchaseID ?? '',
            );
            debugPrint('🎉 VIP 激活成功');
          } else {
            debugPrint('❌ 购买验证失败');
            _handleInvalidPurchase(purchaseDetails);
          }
          // 完成交易
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.error:
          debugPrint('❌ 购买失败: ${purchaseDetails.error}');
          _handleError(purchaseDetails.error!);
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.canceled:
          debugPrint('⚠️ 购买取消');
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          break;
        default:
          break;
      }
    }
  }

  /// 购买 VIP
  Future<void> buyVIP() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(
        {vipMonthlyProductId},
      );

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('❌ 产品未找到: ${response.notFoundIDs}');
        return;
      }

      if (response.productDetails.isEmpty) {
        debugPrint('❌ 没有可用的产品');
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;

      // 创建购买参数
      late final PurchaseParam purchaseParam;

      if (Platform.isIOS) {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
        );
      } else if (Platform.isAndroid) {
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
        );
      }

      // 发起购买
      if (Platform.isIOS) {
        final bool success = await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
        if (!success) {
          debugPrint('❌ 发起购买失败');
        }
      } else if (Platform.isAndroid) {
        final bool success = await _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam as GooglePlayPurchaseParam,
        );
        if (!success) {
          debugPrint('❌ 发起购买失败');
        }
      }
    } catch (e) {
      debugPrint('❌ 购买异常: $e');
    }
  }

  /// 恢复购买
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      debugPrint('✅ 恢复购买成功');
    } catch (e) {
      debugPrint('❌ 恢复购买失败: $e');
    }
  }

  /// 验证购买
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // TODO: 在生产环境中，应该通过后端验证购买收据
    // 这里简化处理，直接返回 true
    return true;
  }

  /// 处理无效购买
  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // 处理无效购买
    debugPrint('⚠️ 无效购买，请联系客服');
  }

  /// 显示等待 UI
  void _showPendingUI() {
    // TODO: 显示等待提示
    debugPrint('⏳ 处理中，请稍候...');
  }

  /// 处理错误
  void _handleError(IAPError error) {
    // TODO: 显示错误提示
    debugPrint('❌ 购买错误: ${error.code} - ${error.message}');
  }

  /// 流完成
  void _updateStreamOnDone() {
    _subscription?.cancel();
  }

  /// 流错误
  void _updateStreamOnError(dynamic error) {
    debugPrint('❌ 购买流错误: $error');
  }

  /// 销毁
  void dispose() {
    _subscription?.cancel();
  }
}
