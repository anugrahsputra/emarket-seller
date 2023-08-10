import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderController extends GetxController {
  final Database database = Database();
  RxBool isLoading = false.obs;
  final orders = RxList<Orders>([]);
  final carts = RxList<Cart>([]);
  RxBool isProcessing = false.obs;
  RxBool isCancelled = false.obs;
  RxBool isShipping = false.obs;
  RxBool sortByDate = false.obs;
  RxInt totalSales = 0.obs;
  RxInt totalItemsSold = 0.obs;
  RxInt averageSales = 0.obs;
  RxBool showCompleteOrders = false.obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
    getDailySales();
  }

  setLoading(bool value) {
    isLoading.value = value;
    update();
  }

  Future<void> getOrders() async {
    String sellerId = Get.find<AuthController>().user!.uid;
    setLoading(true);
    try {
      orders.bindStream(database.getOrders(sellerId));
      update();
    } on Exception catch (e) {
      log('Error getting orders: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> getDailySales() async {
    String sellerId = Get.find<AuthController>().user!.uid;
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day);
    final DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    int totalSale = 0;

    Map<String, int> productSales = {};

    setLoading(true);
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await database.getDailySales(sellerId, start, end);

      Map<String, int> dailySales = {};
      List<QueryDocumentSnapshot> documents = snapshot.docs.where((doc) {
        DateTime docDate = DateFormat('MMMM d, y H:mm').parse(doc['date']);
        return docDate.isAfter(start) &&
            docDate.isBefore(end) &&
            doc['isDelivered'] == true;
        // return doc['isDelivered'] == true;
      }).toList();
      if (documents.isEmpty) {
        dailySales[DateFormat('yyyy-MM-dd').format(now)] = 0;
      } else {
        for (var doc in documents) {
          DateTime docDate = DateFormat('MMMM d, y H:mm').parse(doc['date']);
          String dateString = DateFormat('yyyy-MM-dd').format(docDate);
          int total = doc['total'];

          dailySales.update(dateString, (value) => value + total,
              ifAbsent: () => total);
        }
      }

      dailySales.forEach((date, total) {
        int totalItemSold = 0;
        totalSale += total;

        List<Orders> ordersForDate = orders.where((order) {
          DateTime orderDate = DateFormat('MMMM d, y H:mm').parse(order.date);
          return orderDate.isAfter(start) &&
              orderDate.isBefore(end) &&
              order.isDelivered == true;
        }).toList();

        for (var order in ordersForDate) {
          int itemSold = order.cart.length;
          totalItemSold += itemSold;

          for (var product in order.cart) {
            if (productSales.containsKey(product.name)) {
              productSales[product.name] =
                  productSales[product.name]! + product.quantity;
            } else {
              productSales[product.name] = product.quantity;
            }
          }
        }
        totalItemsSold.value = totalItemSold;
      });
      double averageSale = totalSale / dailySales.length;
      List<MapEntry<String, int>> sortedProducts = productSales.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      List<String> topSellingProducts = sortedProducts
          .sublist(0, sortedProducts.length > 5 ? 5 : sortedProducts.length)
          .map((entry) => entry.key)
          .toList();

      totalSales.value = totalSale;

      averageSales.value = averageSale.toInt();
      log('Total Sales: $totalSale');
      log('Total Items Sold: $totalItemsSold');
      log('Average Sale Amount: $averageSales');
      log('Top Selling Products: $topSellingProducts');
      update();
    } catch (e) {
      log('Error getting daily sales: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pullToRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    await getOrders();
  }

  Future<void> shipsOrder(Orders order, bool value) async {
    await database.updateOrderStatus(
      order.id,
      order.buyerId,
      'isShipping',
      value,
    );
    isShipping.value = value;
    update();
  }

  Future<void> processOrder(
    Orders order,
    String field,
    bool value,
    List<Cart> cartList,
  ) async {
    String sellerId = Get.find<AuthController>().user!.uid;
    final productController = Get.find<ProductController>();

    for (Cart cart in cartList) {
      final product = productController.products.firstWhere(
        (product) => product.id == cart.productId,
        orElse: () => Product(),
      );
      final newQuantity = product.quantity - cart.quantity;
      Map<String, dynamic> data = {
        'quantity': newQuantity,
      };

      await database.updateOrderStatus(order.id, order.buyerId, field, value);
      await database.updateProduct(sellerId, cart.productId, data);
    }

    isProcessing.value = value;
    update();
  }

  Future<void> cancelOrder(Orders order, bool value) async {
    await database.updateOrderStatus(
        order.id, order.buyerId, 'isCancelled', value);
    isCancelled.value = value;
    update();
  }
}
