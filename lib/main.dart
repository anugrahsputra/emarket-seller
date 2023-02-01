import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/controller.dart';
import 'firebase_options.dart';
import 'presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Emarket Seller',
      initialBinding: AuthBinding(),
      theme: ThemeData(
          primaryColor: const Color(0xff212529),
          appBarTheme: AppBarTheme(
            surfaceTintColor: const Color(0xfff8f9fa),
            color: const Color(0xfff8f9fa),
            iconTheme: const IconThemeData(color: Color(0xff212529)),
            titleTextStyle: GoogleFonts.roboto(
              color: const Color(0xff212529),
              fontSize: 20,
            ),
          ),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Color(0xffdee2e6),
          ),
          scaffoldBackgroundColor: const Color(0xfff8f9fa),
          cardColor: const Color(0xffa5a5a5),
          iconTheme: const IconThemeData(
            color: Color(0xfff8f9fa),
          ),
          fontFamily: GoogleFonts.roboto().fontFamily,
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            bodyMedium: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            bodySmall: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            displayLarge: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            displayMedium: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            displaySmall: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            headlineMedium: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            headlineSmall: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            titleLarge: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            labelSmall: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            titleMedium: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
            titleSmall: GoogleFonts.roboto(
              color: const Color(0xff212529),
            ),
          )),
      home: const Root(),
      getPages: [
        GetPage(name: '/home', page: () => Homepage()),
        GetPage(name: '/new-product-page', page: () => NewProductPage()),
        GetPage(name: '/signin', page: () => SignInPage()),
        GetPage(name: '/signup', page: () => SignUpPage()),
      ],
    );
  }
}

class Root extends GetWidget<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AuthController>(
      initState: (_) async {
        Get.put<SellerController>(SellerController());
      },
      builder: (_) {
        return Loading(
          loading: controller.loading,
          child: controller.user?.uid != null ? Homepage() : SignInPage(),
        );
      },
    );
  }
}
