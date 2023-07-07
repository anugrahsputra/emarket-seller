import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPage extends StatelessWidget {
  OrderPage({Key? key}) : super(key: key);

  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());
    final BuyerController buyerController = Get.put(BuyerController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan', style: GoogleFonts.poppins()),
      ),
      body: GetX<OrderController>(
        builder: (controller) {
          debugPrint('Orders length: ${controller.orders.length}');
          return controller.orders.isEmpty
              ? const Center(
                  child: Text('Belum ada pesanan'),
                )
              : RefreshIndicator(
                  onRefresh: controller.pullToRefresh,
                  child: ListView.builder(
                    itemCount: orderController.orders.length,
                    itemBuilder: (context, index) {
                      const defaultBuyer = Buyer();
                      final order = orderController.orders[index];
                      final buyer = buyerController.buyers.firstWhere(
                        (buyer) => buyer.id == order.buyerId,
                        orElse: () => defaultBuyer,
                      );
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => DetailOrder(
                                order: order,
                                buyer: buyer,
                              ));
                        },
                        child: Card(
                          key: ValueKey(order.id),
                          child: ListTile(
                            title: Text(
                              orderController.orders[index].displayName,
                              style: GoogleFonts.poppins(),
                            ),
                            subtitle: Text(
                              orderController.orders[index].note,
                              style: GoogleFonts.poppins(),
                            ),
                            trailing: Text(
                              PriceFormatter.format(
                                  orderController.orders[index].total),
                              style: GoogleFonts.poppins(),
                            ),
                            tileColor: order.isCancelled
                                ? Colors.red[100]
                                : order.isProcessing
                                    ? Colors.green[100]
                                    : Colors.yellow[100],
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
