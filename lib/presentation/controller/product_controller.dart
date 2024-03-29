import 'dart:developer';

import 'package:emarket_seller/services/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../model/model.dart';
import 'controller.dart';

class ProductController extends GetxController {
  final Database database = Database();
  final Storage storage = Storage();
  RxBool isLoading = false.obs;
  RxBool isEdit = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  RxDouble rating = 0.0.obs;
  RxInt numRatings = 0.obs;
  var uuid = const Uuid();
  final Rx<Product> _product = Product().obs;

  Product get product => _product.value;
  set product(Product value) {
    _product.value = value;
    ever(_product, (_) => debugPrint('Product has been changed'));
    update();
  }

  var products = <Product>[].obs;

  @override
  void onInit() {
    fetchProduct();
    super.onInit();
  }

  var newProduct = {}.obs;

  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  Future<void> fetchProduct() async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      setLoading(true);
      products.bindStream(database.getProduct(id));
      update();
    } catch (e) {
      debugPrint('Error fetching product: $e');
      log('Error fetching product: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> pullToRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    await fetchProduct();
  }

  void getProduct(String produkid) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      setLoading(true);
      final product = (await database.product(id, produkid))!;
      this.product = product;
      update();
    } catch (e) {
      debugPrint('Error fetching product: $e');
      log('Error fetching product: $e');
    } finally {
      setLoading(false);
    }
  }

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
        numRatings: numRatings.value,
        rating: rating.value,
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
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (image == null) {
      Fluttertoast.showToast(msg: 'Tidak ada gambar yang dipilih');
      return;
    }

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Gambar',
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );

    if (croppedImage != null) {
      final XFile croppedFile = XFile(croppedImage.path);
      await uploadProductImage(croppedFile);
      var imageUrl = await storage.getProductUrl(croppedFile.name);
      newProduct.update('imageUrl', (_) => imageUrl, ifAbsent: () => imageUrl);
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

  void updateProduct(String productId, Map<String, dynamic> data) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateProduct(id, productId, data);
      update();
    } catch (e) {
      debugPrint('Error updating product: $e');
    }
  }

  reduceQuantity(String productId) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      final quantity = _product.value.quantity--;
      Map<String, dynamic> data = {
        'quantity': quantity,
      };
      await database.updateProduct(id, productId, data);
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
