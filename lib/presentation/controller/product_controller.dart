import 'dart:developer';

import 'package:emarket_seller/services/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../model/model.dart';
import 'controller.dart';

class ProductController extends GetxController {
  final Database database = Database();
  final Storage storage = Storage();
  RxBool isLoading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  var uuid = const Uuid();
  final _product = Product().obs;

  Product get product => _product.value;
  set product(Product value) {
    _product.value = value;
    update();
  }

  var products = <Product>[].obs;

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
  Future<void> fetchProduct() async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      setLoading(true);
      products.bindStream(database.getProduct(id));
      for (var product in products) {
        products.add(product);
      }
      update();
    } catch (e) {
      debugPrint('Error fetching product: $e');
      log('Error fetching product: $e');
    } finally {
      setLoading(false);
    }
  }

  // To add a new product
  void addProduct() async {
    String id = Get.find<AuthController>().user!.uid;
    try {
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
    } catch (e) {
      debugPrint('Error adding product: $e');
      log('Error adding product: $e');
    }
  }

  void pickProductImage() async {
    bool isAuthorized = await Permission.storage.isGranted;
    if (!isAuthorized) {
      var status = await Permission.storage.request();
      if (status.isDenied) {
        Get.dialog(
          AlertDialog(
            title: const Text('Perizinan Ditolak'),
            content: const Text(
                'Anda tidak memberikan izin untuk mengakses galeri foto'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('tolak'),
              ),
              TextButton(
                onPressed: () => isAuthorized = true,
                child: const Text('Izinkan'),
              ),
            ],
          ),
        );
        return;
      }
    }
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    if (image != null) {
      await uploadProductImage(image);
      var imageUrl = await storage.getProductUrl(image.name);
      newProduct.update('imageUrl', (_) => imageUrl, ifAbsent: () => imageUrl);
    }
    if (image == null) {
      Fluttertoast.showToast(msg: 'Tidak ada gambar yang dipilih');
    }
  }

  uploadProductImage(XFile image) async {
    try {
      setLoading(true);
      final storage = Storage();
      final downloadUrl = await storage.uploadProductImage(image, (progress) {
        log('Upload progress: $progress');
        uploadProgress.value = progress;
      });
      newProduct['imageUrl'] = downloadUrl;
    } catch (e) {
      debugPrint('Error uploading product image: $e');
    } finally {
      setLoading(false);
    }
  }

  void updateName(String productId, String value) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateProduct(id, productId, 'name', value);
      product.name = value;
      debugPrint('Product name updated: $_product.value.name');
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

  void decreaseQuantity(String productId, int value) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateProduct(id, productId, 'quantity', value);
      debugPrint('Product updated: $productId');
      update();
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  reduceQuantity(String productId) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      final quantity = _product.value.quantity--;
      await database.updateProduct(id, productId, 'quantity', quantity);
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
    products.clear();
  }

  @override
  void dispose() {
    fetchProduct();
    super.dispose();
  }
}
