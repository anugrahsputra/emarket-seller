import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final SellerController controller = Get.put(SellerController());
  final AuthController authController = Get.find<AuthController>();
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetX<SellerController>(
          initState: (_) async {
            controller.seller = (await database.getSeller(
              authController.user!.uid,
            ))!;
          },
          builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(controller.seller.photoUrl),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome ${controller.seller.displayName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Email: ${controller.seller.email}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Phone: ${controller.seller.storeName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    authController.signOut();
                    Get.delete<ProductController>();
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
