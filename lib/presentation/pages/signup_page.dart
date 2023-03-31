import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends GetWidget<AuthController> {
  final nameController = TextEditingController();
  final storeNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                      height: 180,
                    ),
                    Form(
                      child: Column(
                        children: [
                          FormText(
                            controller: nameController,
                            hintText: 'Nama',
                            icon: Icons.person,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormText(
                            controller: storeNameController,
                            hintText: 'Nama Toko/usaha',
                            icon: Icons.store_rounded,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormText(
                            controller: emailController,
                            hintText: 'Alamat Email',
                            icon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormText(
                            controller: passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_rounded,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ButtonWidget(
                            onPressed: () async {
                              controller.createSeller(
                                nameController.text,
                                storeNameController.text,
                                emailController.text,
                                'https://ui-avatars.com/api/?name=${nameController.text}',
                                passwordController.text,
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
