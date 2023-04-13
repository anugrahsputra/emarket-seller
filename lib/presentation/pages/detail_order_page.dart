import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/pages/maps_page.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailOrder extends StatelessWidget {
  DetailOrder({
    Key? key,
    required this.order,
    required this.buyer,
  }) : super(key: key);

  final Orders order;
  final Buyer buyer;
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());

    return Scaffold(
      key: ValueKey(order.id),
      appBar: AppBar(
        title: const Text('Detail Order'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: context.mediaQuerySize.height,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Informasi Pesanan',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                    ),
                  ),
                  order.isCancelled
                      ? Text(
                          'Pesanan ditolak',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        )
                      : order.isProcessing
                          ? Text(
                              'Sedang Diproses',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            )
                          : Text(
                              'Belum Diproses',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Nama',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    order.displayName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'No. Hp',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    buyer.phoneNumber,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Alamat',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: Text(
                      buyer.address,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.to(() => MapPage(
                            buyer: buyer,
                          ));
                    },
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Item',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.cart.length,
                itemBuilder: (context, index) {
                  return OrderedProductCard(
                    index: index,
                    cart: order.cart[index],
                  );
                },
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sub Total',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    PriceFormatter.format(order.total),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ongkos Kirim',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Gratis',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    PriceFormatter.format(order.total),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: () async {
                      orderController.processOrder(order, 'isProcessing',
                          !orderController.isProcessing.value, order.cart);
                      Fluttertoast.showToast(
                        msg: 'Pesanan diterima. Segera antar pesanan!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green[100],
                        textColor: Colors.black,
                        fontSize: 16.0,
                      );
                      Get.back();
                    },
                    child: Text(
                      'Terima Pesanan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      orderController.cancelOrder(
                        order,
                        'isCancelled',
                        !orderController.isCancelled.value,
                      );
                      Fluttertoast.showToast(
                        msg: 'Pesanan ditolak',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red[100],
                        textColor: Colors.black,
                        fontSize: 16.0,
                      );
                      Get.back();
                    },
                    child: Text(
                      'Tolak Pesanan',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(
      BuildContext context, String message, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
