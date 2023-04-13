import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/common.dart';
import 'firebase_options.dart';
import 'presentation/controller/controller.dart';
import 'presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
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
        colorSchemeSeed: const Color(0xff212529),
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Color(0xff212529)),
          titleTextStyle: GoogleFonts.poppins(
            color: const Color(0xff212529),
            fontSize: 20,
          ),
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xffdee2e6),
        ),
        // scaffoldBackgroundColor: const Color(0xfff8f9fa),

        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: textTheme,
      ),
      home: const Root(),
      getPages: Routes.routes,
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
          child: controller.user?.uid != null ? MainPage() : SignInPage(),
        );
      },
    );
  }
}
