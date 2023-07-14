import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:get/get.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SellerController>(SellerController(), permanent: true);
    Get.put<BuyerController>(BuyerController(), permanent: true);
    Get.lazyPut(() => TokenController(), fenix: true);
    Get.lazyPut(() => BottomNavbarController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => LocationController(), fenix: true);
  }
}
