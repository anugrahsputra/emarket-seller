// import 'package:emarket_seller/presentation/controller/controller.dart';
// import 'package:emarket_seller/services/services.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:mockito/mockito.dart';

// class MockDatabase extends Mock implements Database {}

// class MockGeolocator extends Mock implements Geolocator {}

// void main() {
//   late MockFirebaseAuth mockFirebaseAuth;
//   late MockDatabase mockDatabase;

//   setUp(() {
//     mockFirebaseAuth = MockFirebaseAuth(signedIn: true);
//     mockDatabase = MockDatabase();

//     Get.put<AuthController>(AuthController(
//       auth: mockFirebaseAuth,
//       database: mockDatabase,
//     ));
//   });

//   test('signIn test', () async {
//     final controller = Get.find<AuthController>();
//     await controller.signIn(email: "test@test.com", password: "password");

//     verify(mockFirebaseAuth.signInWithEmailAndPassword(
//             email: "test@test.com", password: "password"))
//         .called(1);
//   });

//   test('createSeller test', () async {
//     final controller = Get.find<AuthController>();
//     await controller.createSeller(
//         displayName: "Seller Test",
//         storeName: "Store Test",
//         email: "test@test.com",
//         photoUrl: "photo_url",
//         password: "password",
//         phoneNumber: "1234567890");

//     verify(mockFirebaseAuth.createUserWithEmailAndPassword(
//             email: "test@test.com", password: "password"))
//         .called(1);
//   });

//   tearDown(() {
//     Get.reset();
//   });
// }
