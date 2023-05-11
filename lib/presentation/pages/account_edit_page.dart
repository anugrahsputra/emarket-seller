import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountEditPage extends StatelessWidget {
  AccountEditPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final SellerController controller = Get.put(SellerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit account'),
          actions: [
            IconButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Silahkan masukkan password anda'),
                    content: FormText(
                      controller: passwordController,
                      hintText: 'Password anda',
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock_rounded),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Batal'),
                      ),
                      Obx(() => controller.loading.value
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: () async {
                                await controller.updateAccount(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                                await controller.fetchSeller();
                                Get.back();
                                Get.back();
                              },
                              child: const Text('Konfirmasi'),
                            )),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.check_rounded),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              FormText(
                controller: emailController,
                hintText: 'Email anda',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_rounded),
              ),
            ],
          ),
        ));
  }
}
