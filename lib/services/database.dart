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

  Future<void> updateProduct(Product product, String id) {
    return _firestore
        .collection('sellers')
        .doc(id)
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
  }

  Future<void> deleteProduct(Product product, String id) {
    return _firestore
        .collection('sellers')
        .doc(id)
        .collection('products')
        .doc(product.id)
        .delete();
  }
}
