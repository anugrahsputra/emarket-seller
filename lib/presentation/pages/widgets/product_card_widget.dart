import 'dart:developer';

import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.product,
    required this.index,
  }) : super(key: key);

  final Product product;
  final String index;
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: product.quantity == 0
          ? const Color.fromARGB(255, 230, 200, 199)
          : const Color(0xffdee2e6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image(
                image: NetworkImage(
                  product.imageUrl,
                ),
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: const Color(0xffa5a5a5),
                        highlightColor: const Color(0xfff8f9fa),
                        child: Container(
                          color: const Color(0xff212529),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Harga: ${PriceFormatter.format(product.price)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Stock: ${product.quantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final imageUrl = product.imageUrl;
                final ref = FirebaseStorage.instance.refFromURL(imageUrl);
                log(imageUrl);
                debugPrint(imageUrl);
                await ref.delete();
                debugPrint('product image deleted: $imageUrl');
                productController.newProduct.value = {};
                productController.deleteProduct(product);
              },
              icon: const Icon(
                Icons.delete,
                color: Color(0xffdc3545),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
