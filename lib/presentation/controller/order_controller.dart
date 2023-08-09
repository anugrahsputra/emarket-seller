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
  final isProcessing = false.obs;
  final isCancelled = false.obs;
  final isShipping = false.obs;
  RxBool sortByDate = false.obs;
  RxInt totalSales = 0.obs;
  RxInt totalItemsSold = 0.obs;
  RxInt averageSales = 0.obs;

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

  Future<Map<String, int>> getDailySales() async {
    String sellerId = Get.find<AuthController>().user!.uid;
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day);
    final DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

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
        totalSales.value = total;
        log('Date: $date - Total Sales: $totalSales');
        update();
      });
      return dailySales;
    } catch (e) {
      log('Error getting daily sales: $e');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  Future<void> dailySalesSummary() async {
    try {
      Map<String, int> dailySales = await getDailySales();
      int totalSale = 0;
      int totalItemSold = 0;
      Map<String, int> productSales = {};
      dailySales.forEach((date, total) {
        totalSale += total;

        List<Orders> ordersForDate = orders.where((order) {
          DateTime orderDate = DateFormat('dd-MM-yyyy').parse(order.date);
          DateTime formattedDate = DateFormat('yyyy-MM-dd').parse(date);
          return orderDate.isAtSameMomentAs(formattedDate) &&
              order.isDelivered == true;
        }).toList();

        for (var order in ordersForDate) {
          int itemSold = order.cart.length;
          totalItemSold += itemSold;

          for (var product in order.cart) {
            if (productSales.containsKey(product.name)) {
              productSales.update(
                  product.name, (value) => value + product.quantity,
                  ifAbsent: () => product.quantity);
            } else {
              productSales[product.name] = product.quantity;
            }
          }
        }
      });

      double averageSale = totalSale / dailySales.length;
      List<MapEntry<String, int>> sortedProducts = productSales.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      List<String> topSellingProducts = sortedProducts
          .sublist(
            0,
            sortedProducts.length < 5 ? sortedProducts.length : 5,
          )
          .map((entry) => entry.key)
          .toList();

      totalSales.value = totalSale;
      totalItemsSold.value = totalItemSold;
      averageSales.value = averageSale.toInt();
      log('Total Sales: $totalSales');
      log('Total Items Sold: $totalItemsSold');
      log('Average Sale Amount: $averageSales');
      log('Top Selling Products: $topSellingProducts');
      update();
    } catch (e) {
      log('Error getting daily sales summary: $e');
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
