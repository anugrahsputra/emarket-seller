import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut(() => SellerController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => BuyerController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
  }
}
