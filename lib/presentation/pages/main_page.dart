import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  static const String routeName = '/main-page';
  MainPage({Key? key}) : super(key: key);

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<Widget> pageList = [
    Homepage(),
    OrderPage(),
    ProfilePage(),
  ];

  final List<NavigationDestination> navigationDestinations = [
    const NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.shopping_cart),
      label: 'Orders',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavbarController>(
      builder: (_) {
        return Scaffold(
          body: pageList[controller.tabIndex.value],
          bottomNavigationBar: NavigationBar(
            destinations: navigationDestinations,
            onDestinationSelected: (index) {
              controller.changedTabIndex(index);
            },
            selectedIndex: controller.tabIndex.value,
          ),
        );
      },
    );
  }
}
