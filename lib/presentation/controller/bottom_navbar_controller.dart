import 'package:emarket_seller/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  Widget currentPage = Homepage();
  var tabIndex = 0.obs;

  Widget get getCurrentPage => currentPage;

  void changePage(int index) {
    tabIndex.value = index;
    switch (index) {
      case 0:
        currentPage = Homepage();
        update();
        break;
      case 1:
        currentPage = const OrderPage();
        update();
        break;
      case 2:
        currentPage = ProfilePage();
        update();
        break;
      default:
        currentPage = Homepage();
        update();
    }
  }
}
