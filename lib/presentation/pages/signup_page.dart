import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends GetWidget<AuthController> {
  final nameController = TextEditingController();
  final storeNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final LocationController locationController = Get.put(LocationController());

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.97,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Loading(
                loading: controller.loading,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 140,
                    ),
                    Form(
                      child: Column(
                        children: [
                          FormText(
                            controller: nameController,
                            hintText: 'Nama',
                            prefixIcon: const Icon(Icons.person_rounded),
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormText(
                            controller: storeNameController,
                            hintText: 'Nama Toko/usaha',
                            prefixIcon: const Icon(Icons.store_rounded),
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormText(
                            controller: emailController,
                            hintText: 'Alamat Email',
                            prefixIcon: const Icon(Icons.email_rounded),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormText(
                            controller: phoneNumberController,
                            hintText: 'Nomor Telepon',
                            prefixIcon: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.phone_rounded),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('+62'),
                              ],
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormText(
                            controller: passwordController,
                            obscureText: true,
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock_rounded),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ButtonWidget(
                            onPressed: () async {
                              controller.createSeller(
                                displayName: nameController.text,
                                storeName: storeNameController.text,
                                email: emailController.text,
                                photoUrl:
                                    'https://ui-avatars.com/api/?name=${nameController.text}',
                                password: passwordController.text,
                                phoneNumber: phoneNumberController.text,
                              );
                              await locationController.getCurrentLocation();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            title: 'Daftar',
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    BottomTextWidget(
                      onTap: () {
                        Get.back();
                      },
                      text1: 'SUdah Punya Akun?',
                      text2: 'Masuk',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
