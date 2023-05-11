import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:emarket_seller/services/database.dart';
import 'package:emarket_seller/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NewProductPage extends StatelessWidget {
  NewProductPage({Key? key}) : super(key: key);

  final ProductController productController = Get.put(ProductController());
  final AuthController controller = Get.find<AuthController>();
  final Storage storage = Storage();
  final Database database = Database();
  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Makanan',
      'Minuman',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xff495057),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(
                        () {
                          if (productController.isLoading.value) {
                            var progress =
                                productController.uploadProgress.value;
                            return Center(
                              child: Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else {
                            return productController.newProduct['imageUrl'] ==
                                    null
                                ? const Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_rounded,
                                      size: 80,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      productController.newProduct['imageUrl']!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  );
                          }
                        },
                      ),
                    ),
                    onTap: () async {
                      ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image == null) {
                        Fluttertoast.showToast(
                            msg: 'Tidak ada gambar yang dipilih');
                      }
                      if (image != null) {
                        // await storage.uploadImage(image, ); // <== HERE
                        await productController.uploadProductImage(image);
                        var imageUrl = await storage.getProductUrl(image.name);
                        productController.newProduct.update(
                          'imageUrl',
                          (_) => imageUrl,
                          ifAbsent: () => imageUrl,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'file name',
                    style: GoogleFonts.poppins(
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(
                    color: Color(0xff212529),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff212529),
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Nama produk',
                ),
                onChanged: (value) {
                  productController.newProduct.update(
                    'name',
                    (_) => value,
                    ifAbsent: () => value,
                  );
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                iconSize: 20,
                iconEnabledColor: const Color(0xff212529),
                decoration: const InputDecoration(
                  hintText: 'Product Category',
                  hintStyle: TextStyle(color: Color(0xff212529)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff212529),
                    ),
                  ),
                ),
                items: categories.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  productController.newProduct.update(
                    'category',
                    (_) => value,
                    ifAbsent: () => value,
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: Color(0xff212529),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff212529),
                          ),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Harga',
                      ),
                      onChanged: (value) {
                        productController.newProduct.update(
                          'price',
                          (_) => int.parse(value),
                          ifAbsent: () => int.parse(value),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(
                          color: Color(0xff212529),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff212529),
                          ),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Stok',
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
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(
                    color: Color(0xff212529),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff212529),
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Deskripsi',
                ),
                onChanged: (value) {
                  productController.newProduct.update(
                    'description',
                    (_) => value,
                    ifAbsent: () => value,
                  );
                },
              ),
              const SizedBox(height: 10),
              ButtonWidget(
                title: 'Simpan',
                onPressed: () {
                  productController.addProduct();

                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
