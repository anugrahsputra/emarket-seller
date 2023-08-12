import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends GetWidget<AuthController> {
  SignInPage({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              SvgPicture.asset(
                'assets/logo/logo.svg',
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Masuk ',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Untuk ',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 155.w,
                    // color: const Color(0xff14e3ff),
                    child: AnimatedTextKit(
                      pause: const Duration(milliseconds: 1000),
                      repeatForever: false,
                      totalRepeatCount: 3,
                      animatedTexts: [
                        TyperAnimatedText(
                          'Anter Pesanan',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff67AD53),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TyperAnimatedText(
                          'Jualan',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff294159),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TyperAnimatedText(
                          'Melanjutkan',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff14e3ff),
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70.h),
              TextFormField(
                cursorColor: const Color(0xff212529),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Alamat Email',
                  prefixIcon: const Icon(
                    Icons.email_rounded,
                    color: Color(0xff495057),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: const BorderSide(
                      style: BorderStyle.none,
                      width: 0,
                    ),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              TextFormField(
                cursorColor: const Color(0xff212529),
                obscureText: true,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock_rounded,
                    color: Color(0xff495057),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      style: BorderStyle.none,
                      width: 0,
                    ),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              ButtonWidget(
                onPressed: () async {
                  await controller.signIn(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                title: 'Masuk',
              ),
              const Spacer(),
              BottomTextWidget(
                onTap: () {
                  Get.to(() => SignUpPage());
                },
                text1: 'Belumn Punya Akun?',
                text2: 'Daftar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
