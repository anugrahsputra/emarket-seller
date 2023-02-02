import 'package:emarket_seller/controller/controller.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.product,
    required this.index,
  }) : super(key: key);

  final Product product;
  final String index;

  final ProductController productController = Get.find<ProductController>();
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          Dialog(
            insetAnimationCurve: Curves.easeInOut,
            insetAnimationDuration: const Duration(milliseconds: 300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Edit Product',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xff212529),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff212529),
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: product.name,
                      ),
                      onChanged: (value) {
                        productController.newProduct.update(
                          'name',
                          (_) => value,
                          ifAbsent: () => value,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              floatingLabelStyle: const TextStyle(
                                color: Color(0xff212529),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff212529),
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: 'Rp. $product.price',
                            ),
                            onChanged: (value) {
                              productController.newProduct.update(
                                'price',
                                (_) => double.parse(value),
                                ifAbsent: () => double.parse(value),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              floatingLabelStyle: const TextStyle(
                                color: Color(0xff212529),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff212529),
                                ),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: product.quantity.toString(),
                            ),
                            onChanged: (value) {
                              productController.newProduct.update(
                                'quantity',
                                (_) => int.parse(value),
                                ifAbsent: () => int.parse(value),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xffadb5bd),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FilledButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0xff495057),
                              ),
                            ),
                            onPressed: () async {
                              productController.updateProduct(product);

                              Get.back();
                            },
                            child: const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Card(
        color: const Color(0xffdee2e6),
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
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        product.price.toString(),
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
      ),
    );
  }
}
