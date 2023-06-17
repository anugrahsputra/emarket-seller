import 'dart:developer';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/common.dart';
import 'firebase_options.dart';
import 'presentation/controller/controller.dart';
import 'presentation/presentation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, 
  );

  FirebaseMessaging notification = FirebaseMessaging.instance;
  NotificationSettings settings = await notification.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("got message in the foreground");
    log("message data: ${message.data}");

    if (message.notification != null) {
      log("message also contained a notification: ${message.notification}");
    }
  });
  log("User granted permission: ${settings.authorizationStatus}");
  
  await notification.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await notification.subscribeToTopic("newCheckout");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emarket Seller',
      initialBinding: Binding(),
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
        scaffoldBackgroundColor: const Color(0xfff8f9fa),
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
      init: AuthController(),
      builder: (_) {
        return Loading(
          loading: controller.loading,
          child: controller.user?.uid != null ? MainPage() : SignInPage(),
        );
      },
    );
  }
}
