import 'package:emarket_seller/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPage extends StatelessWidget {
  OrderPage({Key? key}) : super(key: key);

  final OrderController orderController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan', style: GoogleFonts.roboto()),
      ),
      body: GetX<OrderController>(
        init: OrderController(),
        initState: (_) {
          orderController.getOrders();
        },
        builder: (controller) {
          debugPrint('Orders length: ${controller.orders.length}');
          return ListView.builder(
            itemCount: orderController.orders.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailOrder(
                        order: orderController.orders[index],
                      ));
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                      orderController.orders[index].displayName,
                      style: GoogleFonts.roboto(),
                    ),
                    subtitle: Text(
                      orderController.orders[index].note,
                      style: GoogleFonts.roboto(),
                    ),
                    trailing: Text(
                      orderController.orders[index].total.toString(),
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
