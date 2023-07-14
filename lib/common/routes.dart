import 'package:get/get.dart';

import '../presentation/presentation.dart';

class Routes {
  static final routes = [
    GetPage(
      name: '/main-page',
      page: () => MainPage(),
    ),
    GetPage(
      name: '/home',
      page: () => Homepage(),
    ),
    GetPage(
      name: '/order-page',
      page: () => const OrderPage(),
    ),
    GetPage(
      name: '/profile-page',
      page: () => ProfilePage(),
    ),
    GetPage(
      name: '/detail-product-page',
      page: () => DetailProductPage(
        product: Get.arguments,
      ),
    ),
    GetPage(
      name: '/edit-profile-page',
      page: () => ProfileEditPage(seller: Get.arguments),
    ),
    GetPage(
      name: '/edit-account-page',
      page: () => AccountEditPage(),
    ),
    GetPage(
      name: '/new-product-page',
      page: () => NewProductPage(),
    ),
    GetPage(
      name: '/signin',
      page: () => SignInPage(),
    ),
    GetPage(
      name: '/signup',
      page: () => SignUpPage(),
    ),
  ];
}
