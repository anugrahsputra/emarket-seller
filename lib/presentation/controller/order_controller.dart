import 'dart:developer';

import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final Database database = Database();
  RxBool isLoading = false.obs;
  final orders = RxList<Orders>([]);
  final carts = RxList<Cart>([]);
  final isProcessing = false.obs;
  final isCancelled = false.obs;
  final isShipping = false.obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  Future<void> getOrders() async {
    String sellerId = Get.find<AuthController>().user!.uid;
    try {
      orders.bindStream(database.getOrders(sellerId));
      update();
    } on Exception catch (e) {
      log('Error getting orders: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> processOrder(
    Orders order,
    String field,
    bool value,
    List<Cart> cartList,
  ) async {
    String sellerId = Get.find<AuthController>().user!.uid;
    final productController = Get.find<ProductController>();

    for (Cart cart in cartList) {
      final product = productController.products.firstWhere(
        (product) => product.id == cart.productId,
        orElse: () => Product(),
      );
      final newQuantity = product.quantity - cart.quantity;
      Map<String, dynamic> data = {
        'quantity': newQuantity,
      };

      await database.updateOrderStatus(order.id, order.buyerId, field, value);
      await database.updateProduct(sellerId, cart.productId, data);
    }

    isProcessing.value = value;
    update();
  }

  Future<void> cancelOrder(Orders order, String field, bool value) async {
    await database.updateOrderStatus(order.id, order.buyerId, field, value);
    isCancelled.value = value;
    update();
  }
}
