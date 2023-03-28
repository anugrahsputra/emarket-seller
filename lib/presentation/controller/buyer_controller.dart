import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:get/get.dart';

class BuyerController extends GetxController {
  final Database database = Database();
  final loading = false.obs;

  var buyer = <Buyer>[].obs;

  @override
  void onInit() {
    getBuyer();
    super.onInit();
  }

  getBuyer() async {
    buyer.bindStream(database.getBuyer());
    update();
  }
}
