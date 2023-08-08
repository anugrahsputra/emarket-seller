import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/pages/maps_page.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailOrder extends StatelessWidget {
  const DetailOrder({Key? key, required this.order, required this.buyer})
      : super(key: key);

  final Orders order;
  final Buyer buyer;

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              buildRow(title: 'Nama', value: order.displayName),
              const SizedBox(
                height: 10,
              ),
              buildRow(title: 'No. Hp', value: buyer.phoneNumber),
              SizedBox(height: 10.h),
              buildAddress(),
              SizedBox(height: 20.h),
              Text(
                'Item',
                style: GoogleFonts.poppins(fontSize: 25),
              ),
              SizedBox(height: 10.h),
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
              buildFooter(
                title: 'Sub Total',
                value: PriceFormatter.format(order.total),
              ),
              buildFooter(
                title: 'Ongkos Kirim',
                value: 'Gratis',
              ),
              buildFooter(
                title: 'Total',
                value: PriceFormatter.format(order.total),
              ),
              const SizedBox(
                height: 20,
              ),
              orderStatus(),
            ],
          ),
        ),
      ),
    );
  }

  buildFooter({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  buildAddress() {
    return Row(
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
            order.address,
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
                  order: order,
                ));
          },
          icon: const Icon(
            Icons.location_on,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  buildRow({required String title, required String value}) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  orderStatus() {
    final orderController = Get.find<OrderController>();
    if (order.isCancelled) {
      return buildStatusText('Pesanan ditolak');
    } else if (order.isProcessing) {
      if (order.isShipping) {
        if (order.isDelivered) {
          return buildStatusText('Pesanan sudah diterima oleh pembeli');
        } else {
          return buildStatusText('Pesanan sedang diantarkan oleh pembeli');
        }
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: buildButton(
                onPressed: () async {
                  orderController.shipsOrder(
                    order,
                    !orderController.isShipping.value,
                  );
                  showToastMessage(
                    'Pesanan Diantarkan.',
                    Colors.green[100],
                  );
                  Get.back();
                },
                buttonText: 'Antarkan pesanan',
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: buildButtonTonal(
                onPressed: () async {
                  orderController.cancelOrder(
                    order,
                    !orderController.isShipping.value,
                  );
                  showToastMessage(
                    'Pesanan Dibatalkan',
                    Colors.red[100],
                  );
                  Get.back();
                },
                buttonText: 'Batalkan pesanan',
              ),
            ),
          ],
        );
      }
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: buildButton(
              onPressed: () async {
                orderController.processOrder(order, 'isProcessing',
                    !orderController.isProcessing.value, order.cart);
                showToastMessage(
                  'Pesanan Diterima. Segera Antarkan pesanan!',
                  Colors.green[100],
                );
                Get.back();
              },
              buttonText: 'Terima pesanan',
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: buildButtonTonal(
              onPressed: () async {
                orderController.cancelOrder(
                  order,
                  !orderController.isShipping.value,
                );
                showToastMessage(
                  'Pesanan Ditolak',
                  Colors.red[100],
                );
                Get.back();
              },
              buttonText: 'Tolak pesanan',
            ),
          ),
        ],
      );
    }
  }

  buildStatusText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
      ),
    );
  }

  showToastMessage(String message, Color? color) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  buildButtonTonal({required onPressed, required buttonText}) {
    return FilledButton.tonal(
      onPressed: onPressed,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  buildButton({required onPressed, required buttonText}) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }
}
