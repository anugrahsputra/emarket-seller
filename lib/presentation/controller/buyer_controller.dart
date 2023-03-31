import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:get/get.dart';

class BuyerController extends GetxController {
  final Database database = Database();
  final Rx<Buyer> _buyer = const Buyer().obs;
  final loading = false.obs;

  var buyers = <Buyer>[].obs;

  Buyer get buyer => _buyer.value;

  set buyer(Buyer value) {
    _buyer.value = value;
  }

  void clear() {
    _buyer.value = const Buyer();
  }

  @override
  void onInit() {
    getBuyer();
    super.onInit();
  }

  getBuyer() async {
    buyers.bindStream(database.getBuyer());
    update();
  }
}
