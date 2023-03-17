import 'package:emarket_seller/controller/controller.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailOrder extends StatelessWidget {
  DetailOrder({Key? key, required this.order}) : super(key: key);

  final Orders order;
  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Order'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Informasi Pesanan',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                  ),
                ),
                Obx(
                  () => orderController.isProcessing.value
                      ? Text(
                          'Sedang Diproses',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                          ),
                        )
                      : Text(
                          'Belum Diproses',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                          ),
                        ),
                )
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
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  order.displayName,
                  style: GoogleFonts.roboto(
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
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  '083812130044',
                  style: GoogleFonts.roboto(
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
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: Text(
                    'Perumahan Grand Simpang Asri, Sukamanah',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Item',
              style: GoogleFonts.roboto(
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
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Rp. ${order.total}',
                  style: GoogleFonts.roboto(
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
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Gratis',
                  style: GoogleFonts.roboto(
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
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Rp. ${order.total}',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: () {
                      orderController.updateOrderStatus(
                        order,
                        'isProcessing',
                        !orderController.isProcessing.value,
                      );
                    },
                    child: Text(
                      'Terima Pesanan',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: Text(
                      'Tolak Pesanan',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
