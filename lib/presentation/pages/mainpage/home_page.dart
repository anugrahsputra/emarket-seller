import 'dart:developer';

import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final AuthController controller = Get.put(AuthController());
  final ProductController productController = Get.put(ProductController());
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await controller.signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: InkWell(
                onTap: () {
                  Get.toNamed('/new-product-page');
                },
                child: const Card(
                  margin: EdgeInsets.zero,
                  color: Color(0xff495057),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Tambah produk baru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GetX<ProductController>(
                initState: (_) async {
                  await productController.fetchProduct();
                },
                builder: (productController) {
                  if (productController.products.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada produk'),
                    );
                  } else if (productController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: productController.products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: ProductCard(
                            index: controller.user!.uid,
                            product: productController.products[index],
                          ),
                          onTap: () {
                            Get.toNamed('/detail-product-page',
                                arguments: productController.products[index]);
                            log('detailProduct(${productController.products[index].id}))');
                          },
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
