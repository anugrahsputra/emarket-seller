import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_seller/model/model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewSeller(SellerModel seller) async {
    try {
      await _firestore
          .collection('sellers')
          .doc(seller.id)
          .set(seller.toDocument());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<SellerModel> getSeller(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('sellers').doc(id).get();
      return SellerModel.fromSnapshot(doc);
    } catch (e) {
      print(e);
      return const SellerModel();
    }
  }

  Future<void> addProduct(Product product, String id) async {
    return _firestore
        .collection('sellers')
        .doc(id)
        .collection('products')
        .doc(product.id)
        .set(product.toMap());
  }

  Stream<List<Product>> getProduct(String id) {
    return _firestore
        .collection('sellers')
        .doc(id)
        .collection('products')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList());
  }

  Future<void> updateProduct(
    String sellerId,
    String productId,
    String field,
    dynamic newValue,
  ) {
    return _firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('products')
        .doc(productId)
        .update({field: newValue});
  }

  Future<void> deleteProduct(Product product, String id) {
    return _firestore
        .collection('sellers')
        .doc(id)
        .collection('products')
        .doc(product.id)
        .delete();
  }

  Stream<List<Orders>> getOrders(String sellerId) {
    return _firestore
        .collectionGroup('checkout')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Orders.fromSnapshot(doc)).toList());
  }

  Future<void> updateOrderStatus(
    Orders order,
    String field,
    bool newValue,
  ) {
    return _firestore
        .collection('buyers')
        .doc(order.buyerId)
        .collection('checkout')
        .where('id', isEqualTo: order.id)
        .get()
        .then((querySnaphot) =>
            querySnaphot.docs.first.reference.update({field: newValue}));
  }
}
