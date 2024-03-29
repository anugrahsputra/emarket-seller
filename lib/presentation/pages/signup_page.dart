import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    SizedBox(height: 50.h),
                    Text(
                      'Daftar Untuk',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 45.h,
                      child: AnimatedTextKit(
                        pause: const Duration(milliseconds: 1000),
                        repeatForever: false,
                        totalRepeatCount: 3,
                        animatedTexts: [
                          TyperAnimatedText(
                            'Buka Toko',
                            textStyle: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff67AD53),
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TyperAnimatedText(
                            'Akun Baru',
                            textStyle: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff294159),
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                          TyperAnimatedText(
                            'Mulai Jualan',
                            textStyle: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff14e3ff),
                            ),
                            speed: const Duration(milliseconds: 100),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
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
