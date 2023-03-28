import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class OrderController extends GetxController {
  final Database database = Database();
  final orders = RxList<Orders>([]);
  final isProcessing = false.obs;
  final isCancelled = false.obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  getOrders() async {
    String sellerId = Get.find<AuthController>().user!.uid;
    orders.bindStream(database.getOrders(sellerId));
  }

  processOrder(Orders order, String field, bool value) async {
    await database.updateOrderStatus(order, field, value);
    isProcessing.value = value;
  }

  cancelOrder(Orders order, String field, bool value) async {
    await database.updateOrderStatus(order, field, value);
    isCancelled.value = true;
  }
}
