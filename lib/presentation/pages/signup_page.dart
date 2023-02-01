import 'package:emarket_seller/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends GetWidget<AuthController> {
  final nameController = TextEditingController();
  final storeNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
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
                          TextFormField(
                            cursorColor: const Color(0xff212529),
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Nama',
                              prefixIcon: const Icon(
                                color: Color(0xff495057),
                                Icons.person_rounded,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  style: BorderStyle.none,
                                  width: 0,
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            cursorColor: const Color(0xff212529),
                            controller: storeNameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Nama Toko/usaha',
                              prefixIcon: const Icon(
                                color: Color(0xff495057),
                                Icons.store_rounded,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  style: BorderStyle.none,
                                  width: 0,
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            cursorColor: const Color(0xff212529),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Alamat Email',
                              prefixIcon: const Icon(
                                color: Color(0xff495057),
                                Icons.email_rounded,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  style: BorderStyle.none,
                                  width: 0,
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            cursorColor: const Color(0xff212529),
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: const Icon(
                                color: Color(0xff495057),
                                Icons.lock_rounded,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  style: BorderStyle.none,
                                  width: 0,
                                ),
                              ),
                              filled: true,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ButtonWidget(
                            onPressed: () {
                              controller.createSeller(
                                nameController.text,
                                storeNameController.text,
                                emailController.text,
                                'https://www.seekpng.com/png/detail/110-1100707_person-avatar-placeholder.png',
                                passwordController.text,
                              );
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
