import 'package:emarket_seller/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:emarket_seller/services/database.dart';
import 'package:emarket_seller/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NewProductPage extends StatelessWidget {
  NewProductPage({Key? key}) : super(key: key);

  final ProductController productController = Get.put(ProductController());
  final AuthController controller = Get.find<AuthController>();
  Storage storage = Storage();
  Database database = Database();
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Makanan',
      'Minuman',
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      child: const Center(
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 80,
                        ),
                      ),
                    ),
                    onTap: () async {
                      ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tidak ada gambar yang dipilih'),
                          ),
                        );
                      }
                      if (image != null) {
                        await storage.uploadImage(image);
                        var imageUrl = await storage.getDownloadUrl(image.name);
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
                    style: GoogleFonts.roboto(
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
