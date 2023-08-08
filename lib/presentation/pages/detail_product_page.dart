import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailProductPage extends GetWidget<ProductController> {
  DetailProductPage({Key? key, required this.product}) : super(key: key);

  final Product product;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final descriptionController = TextEditingController();

  Map<String, dynamic> getUpdatedData() {
    final name =
        nameController.text.isNotEmpty ? nameController.text : product.name;
    final price = priceController.text.isNotEmpty
        ? int.parse(priceController.text)
        : product.price;
    final quantity = stockController.text.isNotEmpty
        ? int.parse(stockController.text)
        : product.quantity;
    final description = descriptionController.text.isNotEmpty
        ? descriptionController.text
        : product.description;
    final imageUrl = controller.newProduct['imageUrl'] ?? product.imageUrl;
    return {
      'name': name,
      'query': name.toLowerCase(),
      'price': price,
      'quantity': quantity,
      'description': description,
      'imageUrl': imageUrl
    };
  }

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
        leading: IconButton(
          onPressed: () {
            if (controller.isEdit.isTrue) {
              controller.isEdit.toggle();
            } else {
              Get.back();
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.isEdit.toggle();
              if (controller.isEdit.isFalse) {
                final data = getUpdatedData();
                controller.updateProduct(product.id, data);
                controller.getProduct(product.id);
                controller.update();
                Get.back();
                Fluttertoast.showToast(
                  msg: 'Produk berhasil diupdate',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            child: Obx(
              () {
                return Text(
                  controller.isEdit.isTrue ? 'Simpan' : 'Edit',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GetBuilder<ProductController>(
          builder: (_) {
            return controller.isLoading.isTrue
                ? const Center(child: CircularProgressIndicator())
                : buildContent(controller);
          },
        ),
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
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return controller.isEdit.isTrue
                        ? GestureDetector(
                            onTap: () {
                              controller.pickProductImage();
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 120.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          controller.newProduct['imageUrl'] ==
                                                  null
                                              ? NetworkImage(product.imageUrl)
                                              : NetworkImage(controller
                                                  .newProduct['imageUrl']),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(),
                                  ),
                                ),
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: Container(
                                    width: 30.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        : Container(
                            width: 120.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(product.imageUrl),
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(),
                            ),
                          );
                  },
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Ditambahkan Pada: 06-06-2069'), //!NOTE: change the date with variable from Product model
                    Text('Sisa Stok Produk: ${product.quantity}'),
                    Row(children: [
                      RatingBarIndicator(
                        rating: product.rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Text('(${product.numRatings})')
                    ]),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => controller.isEdit.isTrue
                      ? TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: product.name,
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : Text(
                          product.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Obx(
                  () => controller.isEdit.isTrue
                      ? Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: product.price.toString(),
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: TextField(
                                controller: stockController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: product.quantity.toString(),
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          PriceFormatter.format(product.price),
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => controller.isEdit.isTrue
                      ? TextField(
                          controller: descriptionController,
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: product.description,
                            hintMaxLines: 6,
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : Text(
                          product.description,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void toggleEdit() {
    controller.isEdit.toggle();
    if (controller.isEdit.isFalse) {
      final data = getUpdatedData();
      controller.updateProduct(product.id, data);
      controller.getProduct(product.id);
      controller.update();
    }
  }
}
