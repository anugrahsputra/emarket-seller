import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
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
                    borderRadius: BorderRadius.circular(25),
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
              const SizedBox(
                height: 15,
              ),
              ButtonWidget(
                onPressed: () {
                  controller.signIn(
                    emailController.text,
                    passwordController.text,
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
