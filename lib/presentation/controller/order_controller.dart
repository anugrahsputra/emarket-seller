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

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  getOrders() async {
    String sellerId = Get.find<AuthController>().user!.uid;
    orders.bindStream(database.getOrders(sellerId));
    update();
  }

  processOrder(
      Orders order, String field, bool value, List<Cart> cartList) async {
    String sellerId = Get.find<AuthController>().user!.uid;
    final productController = Get.find<ProductController>();

    for (Cart cart in cartList) {
      final product = productController.products.firstWhere(
        (product) => product.id == cart.productId,
        orElse: () => Product(),
      );
      final newQuantity = product.quantity - cart.quantity;

      await database.updateOrderStatus(order.id, order.buyerId, field, value);
      await database.updateProduct(
          sellerId, cart.productId, 'quantity', newQuantity);
    }

    isProcessing.value = value;
    update();
  }

  cancelOrder(Orders order, String field, bool value) async {
    await database.updateOrderStatus(order.id, order.buyerId, field, value);
    isCancelled.value = value;
    update();
  }
}
