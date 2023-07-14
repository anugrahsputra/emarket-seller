import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BuyerController buyerController = Get.find<BuyerController>();
    // final ProductController productController = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan', style: GoogleFonts.poppins()),
      ),
      body: GetX<OrderController>(
        init: Get.find<OrderController>(),
        builder: (controller) {
          debugPrint('Orders length: ${controller.orders.length}');
          return controller.orders.isEmpty
              ? const Center(
                  child: Text('Belum ada pesanan'),
                )
              : RefreshIndicator(
                  onRefresh: controller.pullToRefresh,
                  child: ListView.builder(
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      const defaultBuyer = Buyer();
                      final order = controller.orders[index];
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
                              controller.orders[index].displayName,
                              style: GoogleFonts.poppins(),
                            ),
                            subtitle: Text(
                              controller.orders[index].note,
                              style: GoogleFonts.poppins(),
                            ),
                            trailing: Text(
                              PriceFormatter.format(
                                  controller.orders[index].total),
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
