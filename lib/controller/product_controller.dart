import 'package:emarket_seller/services/database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/model.dart';
import 'controller.dart';

class ProductController extends GetxController {
  final Database database = Database();
  RxBool isLoading = false.obs;
  var uuid = const Uuid();

  var product = <Product>[].obs;

  @override
  void onInit() {
    String id = Get.find<AuthController>().user!.uid;
    fetchProduct();
    super.onInit();
  }

  var newProduct = {}.obs;

  // Loading state
  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  // To fetch product
  void fetchProduct() async {
    String id = Get.find<AuthController>().user!.uid;
    product.bindStream(database.getProduct(id));
    update();
  }

  // To add a new product
  void addProduct() async {
    String id = Get.find<AuthController>().user!.uid;
    Product product = Product(
      name: newProduct["name"],
      price: newProduct["price"],
      id: uuid.v4(),
      category: newProduct["category"],
      quantity: newProduct["quantity"],
      description: newProduct["description"],
      imageUrl: newProduct["imageUrl"],
    );
    await database.addProduct(product, id);
    update();
  }

  Future<void> updateProduct(Product product, String id) async {
    return await database.updateProduct(product, id);
  }

  void deleteProduct(Product product) async {
    String id = Get.find<AuthController>().user!.uid;
    await database.deleteProduct(product, id);
    update();
  }

  void clearProducts() {
    product.clear();
  }
}
