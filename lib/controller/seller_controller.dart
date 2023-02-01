import 'package:emarket_seller/model/seller.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SellerController extends GetxController {
  final Rx<SellerModel> _seller = const SellerModel().obs;
  final loading = false.obs;

  SellerModel get seller => _seller.value;

  set seller(SellerModel value) {
    _seller.value = value;
    Get.find<ProductController>().update();
  }

  void clear() {
    _seller.value = const SellerModel();
  }
}
