import 'dart:developer';

import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AuthController extends GetxController {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rxn<User> _firebaseUser = Rxn<User>();
  late final Database _database = Database();
  final TokenController token = Get.put(TokenController());
  final loading = false.obs;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> createSeller({
    required String displayName,
    required String storeName,
    required String email,
    required String photoUrl,
    required String password,
    required String phoneNumber,
  }) async {
    loading.value = true;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final location = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final address = await Get.find<LocationController>()
          .getAddressFromLatLng(position.latitude, position.longitude)
          .then((value) => value);
      final seller = SellerModel(
        id: credential.user!.uid,
        displayName: displayName,
        storeName: storeName,
        phoneNumber: '+62$phoneNumber',
        address: address,
        location: location,
        email: email.trim(),
        photoUrl: photoUrl,
      );
      if (await _database.createNewSeller(seller)) {
        Get.find<SellerController>().seller = seller;
        Get.find<ProductController>().update();
        Get.find<LocationController>().update();
        Get.offNamedUntil('/main-page', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      Get.snackbar(
        "Error creating Account",
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff343a40),
        colorText: const Color(0xfff8f9fa),
        duration: const Duration(seconds: 3),
        forwardAnimationCurve: Curves.easeOutBack,
        margin: const EdgeInsets.all(15),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    loading.value = true;
    try {
      final credential = EmailAuthProvider.credential(
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
    } finally {
      loading.value = false;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    loading.value = true;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<SellerController>().seller =
          (await _database.getSeller(credential.user!.uid))!;
      Get.find<SellerController>().update();
      Get.find<ProductController>().update();
      Get.toNamed('/');
      update();
    } on FirebaseAuthException catch (e) {
      log(e.toString());
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
    } finally {
      loading.value = false;
    }
  }

  Future<void> signOut() async {
    loading.value = true;
    try {
      await _auth.signOut();
      _database.terminate();
      Get.offAllNamed('/');
      update();
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  @override
  void dispose() {
    _firebaseUser.close();
    super.dispose();
  }
}
