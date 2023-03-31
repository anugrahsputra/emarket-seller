import 'dart:developer';

import 'package:emarket_seller/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../model/model.dart';
import 'controller.dart';

class ProductController extends GetxController {
  final Database database = Database();
  RxBool isLoading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  var uuid = const Uuid();

  var product = <Product>[].obs;

  @override
  void onInit() {
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
      sellerId: id,
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

  uploadProductImage(XFile image) async {
    setLoading(true);
    final storage = Storage();

    final downloadUrl = await storage.uploadProductImage(image, (progress) {
      log('Upload progress: $progress');
      uploadProgress.value = progress;
    });

    newProduct['imageUrl'] = downloadUrl;
    setLoading(false);
  }

  void updateName(String productId, String value) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateProduct(id, productId, 'name', value);
      debugPrint('Product updated: $productId');
      update();
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  void updatePrice(String productId, int value) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateProduct(id, productId, 'price', value);
      debugPrint('Product updated: $productId');
      update();
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  void updateQuantity(String productId, int value) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateProduct(id, productId, 'quantity', value);
      debugPrint('Product updated: $productId');
      update();
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  void deleteProduct(Product product) async {
    String id = Get.find<AuthController>().user!.uid;
    await database.deleteProduct(product, id);
    debugPrint('Product deleted: $product');
    update();
  }

  void clearProducts() {
    product.clear();
  }

  @override
  void dispose() {
    fetchProduct();
    super.dispose();
  }
}
