import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  static const String routeName = '/main-page';
  MainPage({Key? key}) : super(key: key);

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<NavigationDestination> navigationDestinations = [
    const NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Halaman Utama',
    ),
    const NavigationDestination(
      icon: Icon(Icons.shopping_cart),
      label: 'Pesanan',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person),
      label: 'Akun',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavbarController>(
      builder: (_) {
        return Scaffold(
          body: controller.getCurrentPage,
          bottomNavigationBar: NavigationBar(
            destinations: navigationDestinations,
            onDestinationSelected: (index) {
              controller.changePage(index);
            },
            selectedIndex: controller.tabIndex.value,
          ),
        );
      },
    );
  }
}
