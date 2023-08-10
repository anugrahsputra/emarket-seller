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

    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<OrderController>().pullToRefresh();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Pesanan', style: GoogleFonts.poppins()),
            actions: [
              Obx(
                () => IconButton(
                  onPressed: () {
                    Get.find<OrderController>().sortByDate.toggle();
                    Get.find<OrderController>().getOrders();
                  },
                  icon: Icon(
                    Get.find<OrderController>().sortByDate.value
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              TabBar(
                onTap: (index) {
                  Get.find<OrderController>().showCompleteOrders.value =
                      index == 1;
                },
                tabs: const [
                  Tab(
                    text: 'Belum Selesai',
                  ),
                  Tab(
                    text: 'Selesai',
                  ),
                ],
              ),
              Expanded(
                child: buildList(buyerController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildList(BuyerController buyerController) {
    return GetX<OrderController>(
      init: Get.find<OrderController>(),
      builder: (controller) {
        debugPrint('Orders length: ${controller.orders.length}');
        List<Orders> filteredOrders = controller.orders
            .where((order) =>
                order.isDelivered == controller.showCompleteOrders.value)
            .toList();
        if (filteredOrders.isEmpty) {
          return const Center(
            child: Text('Belum ada pesanan'),
          );
        } else {
          if (controller.sortByDate.value) {
            controller.orders.sort((a, b) => b.date.compareTo(a.date));
          } else {
            controller.orders.sort((a, b) => a.date.compareTo(b.date));
          }
          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              const defaultBuyer = Buyer();
              final order = filteredOrders[index];
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
                child: OrderCard(order: filteredOrders[index]),
              );
            },
          );
        }
      },
    );
  }
}
