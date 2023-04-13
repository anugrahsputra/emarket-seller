import 'dart:developer';

import 'package:emarket_seller/model/seller.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'controller.dart';

class SellerController extends GetxController {
  final Rx<SellerModel> _seller = const SellerModel().obs;
  final Database database = Database();
  final loading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  SellerModel get seller => _seller.value;

  Rx<XFile?> newProfilePicture = Rx<XFile?>(null);

  set seller(SellerModel value) {
    _seller.value = value;
    Get.find<ProductController>().update();
  }

  void clear() {
    _seller.value = const SellerModel();
  }

  @override
  void onReady() {
    super.onReady();
    fetchSeller();
  }

  void setLoading(bool value) {
    loading.value = value;
    update();
  }

  Future<void> fetchSeller() async {
    try {
      loading.value = true;
      final User user = FirebaseAuth.instance.currentUser!;
      seller = (await database.getSeller(user.uid))!;
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateSellerInfo(String field, dynamic newValue) async {
    String id = Get.find<AuthController>().user!.uid;
    try {
      await database.updateSellerInfo(id, field, newValue);
      log('Seller info updated');
      update();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> selectNewProfilePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      newProfilePicture.value = image;
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      if (newProfilePicture != null) {
        setLoading(true);
        final storage = Storage();

        final downloadUrl = await storage
            .uploadProfileImage(newProfilePicture.value!, (progress) {
          uploadProgress.value = progress;
        });

        await updateSellerInfo('photoUrl', downloadUrl);
        update();
        setLoading(false);
      } else {
        log('No new profile picture selected');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
