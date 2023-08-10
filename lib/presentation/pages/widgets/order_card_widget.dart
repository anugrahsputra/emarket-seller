import 'package:emarket_seller/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Orders order;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: 10.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order.date,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Chip(
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: order.isCancelled == true
                    ? Colors.red[200]
                    : order.isDelivered == true
                        ? Colors.green[200]
                        : order.isShipping == true
                            ? Colors.orange[200]
                            : order.isProcessing == true
                                ? Colors.blue[200]
                                : Colors.grey[200],
                label: Text(
                  order.isCancelled == true
                      ? 'Dibatalkan'
                      : order.isDelivered == true
                          ? 'Selesai'
                          : order.isShipping == true
                              ? 'Dikirim'
                              : order.isProcessing == true
                                  ? 'Diproses'
                                  : 'Menunggu',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Nama Pembeli: ${order.displayName}',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          const Divider(
            color: Colors.black,
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(0),
              childrenPadding: const EdgeInsets.all(0),
              title: Text('Item (${order.cart.length})'),
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: order.cart.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(
                        order.cart[index].imageUrl,
                      ),
                      title: Text(
                        order.cart[index].name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        order.cart[index].price.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                        ),
                      ),
                      trailing: Text(
                        order.cart[index].quantity.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
