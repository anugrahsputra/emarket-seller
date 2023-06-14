import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailProductPage extends GetWidget<ProductController> {
  DetailProductPage({Key? key, required this.product}) : super(key: key);

  final Product product;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((time) {
      Future.delayed(const Duration(seconds: 3), () {
        if (product.quantity < 5) {
          showAlertDialog(context, product.name);
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Produk',
          style: GoogleFonts.plusJakartaSans(),
        ),
      ),
      body: GetBuilder<ProductController>(
        init: ProductController(),
        initState: (_) {
          controller.fetchProduct();
          nameController.text = product.name;
          priceController.text = product.price.toString();
          stockController.text = product.quantity.toString();
          descriptionController.text = product.description;
        },
        builder: (productController) {
          return buildContent(productController);
        },
      ),
    );
  }

  showAlertDialog(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Peringatan'),
          content: Text('Stok $productName kurang dari 5'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  buildContent(ProductController controller) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ditambahkan Pada: 06-06-2069'),
                    Text('Sisa Stok PRoduk: ${product.quantity}')
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
