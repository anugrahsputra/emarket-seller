import 'dart:io';

import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage({Key? key, required this.seller}) : super(key: key);

  final SellerModel seller;
  final SellerController sellerController = Get.put(SellerController());
  final Storage storage = Storage();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Obx(
        () => sellerController.loading.value
            ? Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffe9ecef),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        child: Obx(() {
                          final newProfilePicture =
                              sellerController.newProfilePicture.value;
                          if (newProfilePicture != null) {
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  FileImage(File(newProfilePicture.path)),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(seller.photoUrl),
                            );
                          }
                        }),
                        onTap: () {
                          sellerController.selectNewProfilePicture();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormText(
                      hintText: seller.displayName,
                      prefixIcon: const Icon(Icons.person),
                      keyboardType: TextInputType.name,
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      onPressed: () async {
                        Map<String, dynamic> data = {
                          'displayName': nameController.text.isNotEmpty
                              ? nameController.text
                              : seller.displayName,
                        };
                        await sellerController.updateSellerInfo(data);
                        await sellerController.uploadProfileImage();
                        await sellerController.fetchSeller();
                        Get.back();
                        sellerController.update();
                      },
                      title: 'Update',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
