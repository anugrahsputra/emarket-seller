import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      LocationModel location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      String address = await Get.find<LocationController>()
          .getAddressFromLatLng(position.latitude, position.longitude);
      SellerModel seller = SellerModel(
        id: credential.user!.uid,
        displayName: displayName,
        storeName: storeName,
        address: address,
        location: location,
        email: email,
        photoUrl: photoUrl,
      );
      if (await Database().createNewSeller(seller)) {
        Get.find<SellerController>().seller = seller;
        Get.find<ProductController>().update();
        Get.find<LocationController>().update();
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

  void updatePassword(String currentPassword, String newPassword) async {
    try {
      loading.value = true;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user!.reauthenticateWithCredential(credential);
      await _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw 'Password salah';
      } else {
        throw 'Terjadi kesalahan saat mengubah password';
      }
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
