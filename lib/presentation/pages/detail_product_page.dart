import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
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
      body: GetBuilder<ProductController>(
        init: ProductController(),
        initState: (_) {
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

  buildContent(ProductController productController) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(95),
            child: Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: 10,
              ),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: ColorScheme.fromSeed(seedColor: const Color(0xff212529))
                    .background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Edit Product'),
                                  content: Form(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Name',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        productController.updateName(
                                            product.id, nameController.text);
                                        Get.back();
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            PriceFormatter.format(product.price),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Edit Product'),
                                  content: Form(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: priceController,
                                          decoration: const InputDecoration(
                                            labelText: 'Price',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        productController.updatePrice(
                                            product.id,
                                            int.parse(priceController.text));
                                        Get.back();
                                        productController.update();
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ExpandedText(
                  text: product.description,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
