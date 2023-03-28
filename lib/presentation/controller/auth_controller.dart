import 'package:emarket_seller/model/seller.dart';
import 'package:emarket_seller/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();
  final loading = false.obs;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  void createSeller(String displayName, String storeName, String email,
      String photoUrl, String password) async {
    try {
      loading.value = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      SellerModel seller = SellerModel(
        id: credential.user!.uid,
        displayName: displayName,
        storeName: storeName,
        email: email,
        photoUrl: photoUrl,
      );
      if (await Database().createNewSeller(seller)) {
        Get.find<SellerController>().seller = seller;
        Get.find<ProductController>().update();
        Get.back();
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error creating Account",
        'Mohon Diisi Dengan Benar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff343a40),
        colorText: const Color(0xfff8f9fa),
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  void signIn(String email, String password) async {
    try {
      loading.value = true;
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<SellerController>().seller =
          (await Database().getSeller(credential.user!.uid))!;
      Get.find<SellerController>().update();
      Get.find<ProductController>().update();
      Get.back();
      loading.value = false;
    } catch (e) {
      loading.value = false;
      Get.snackbar(
        "Error signing in",
        "check your email and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff343a40),
        colorText: const Color(0xfff8f9fa),
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeInOut,
        margin: const EdgeInsets.all(15),
      );
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      Get.find<SellerController>().clear();
      // Get.find<ProductController>().clearProducts();
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _firebaseUser.close();
    super.dispose();
  }
}
