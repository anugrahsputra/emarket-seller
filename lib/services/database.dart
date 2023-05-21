import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createNewSeller(SellerModel seller) async {
    try {
      await _firestore
          .collection('sellers')
          .doc(seller.id)
          .set(seller.toDocument());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<SellerModel?> getSeller(String id) async {
    if (_auth.currentUser == null) {
      return null; // Return null if user is not authenticated
    }
    try {
      DocumentSnapshot doc =
          await _firestore.collection('sellers').doc(id).get();
      return SellerModel.fromSnapshot(doc);
    } catch (e) {
      log(e.toString());
      return const SellerModel();
    }
  }

  Future<bool?> updateSellerInfo(
      String sellerId, Map<String, dynamic> data) async {
    if (_auth.currentUser == null) {
      return null; // Return null if user is not authenticated
    }
    try {
      await _firestore.collection('sellers').doc(sellerId).update(data);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool?> addProduct(Product product, String id) async {
    if (_auth.currentUser == null) {
      return null;
    }
    try {
      await _firestore
          .collection('sellers')
          .doc(id)
          .collection('products')
          .doc(product.id)
          .set(product.toMap());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Product?> product(String id, Product product) async {
    if (_auth.currentUser == null) {
      return null;
    }
    try {
      DocumentSnapshot doc = await _firestore
          .collection('sellers')
          .doc(id)
          .collection('products')
          .doc(product.id)
          .get();
      return Product.fromSnapshot(doc);
    } catch (e) {
      log(e.toString());
      return Product();
    }
  }

  Stream<List<Product>> getProduct(String id) {
    if (_auth.currentUser == null) {
      // Return an empty stream if user is not authenticated
      return const Stream.empty();
    }
    try {
      return _firestore
          .collection('sellers')
          .doc(id)
          .collection('products')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
    } catch (e) {
      log('Error fetching product: $e');
      return const Stream.empty();
    }
  }

  Future<bool?> updateProduct(
    String sellerId,
    String productId,
    String field,
    dynamic newValue,
  ) async {
    if (_auth.currentUser == null) {
      return null; // Return null if user is not authenticated
    }
    try {
      await _firestore
          .collection('sellers')
          .doc(sellerId)
          .collection('products')
          .doc(productId)
          .update({field: newValue});
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool?> deleteProduct(Product product, String id) async {
    if (_auth.currentUser == null) {
      return null; // Return null if user is not authenticated
    }
    try {
      await _firestore
          .collection('sellers')
          .doc(id)
          .collection('products')
          .doc(product.id)
          .delete();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<List<Orders>> getOrders(String sellerId) {
    if (_auth.currentUser == null) {
      // Return an empty stream if user is not authenticated
      return const Stream.empty();
    }
    try {
      return _firestore
          .collectionGroup('checkout')
          .where('sellerId', isEqualTo: sellerId)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList());
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  Future<void> updateOrderStatus(
    String orderId,
    String buyerId,
    String field,
    bool newValue,
  ) async {
    if (_auth.currentUser == null) {
      return; // Return null if user is not authenticated
    }
    return _firestore
        .collection('buyers')
        .doc(buyerId)
        .collection('checkout')
        .doc(orderId)
        .update({field: newValue});
  }

  Stream<List<Buyer>> getBuyer() {
    if (_auth.currentUser == null) {
      // Return an empty stream if user is not authenticated
      return const Stream.empty();
    }
    try {
      return _firestore.collection('buyers').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Buyer.fromSnapshot(doc)).toList());
    } catch (e) {
      log(e.toString());
      return const Stream.empty();
    }
  }

  void terminate() {
    _firestore.terminate();
  }
}
