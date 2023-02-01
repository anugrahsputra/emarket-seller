import 'package:emarket_seller/controller/auth_controller.dart';
import 'package:emarket_seller/controller/product_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
  }
}
