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
      page: () => OrderPage(),
    ),
    GetPage(
      name: '/profile-page',
      page: () => ProfilePage(),
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
