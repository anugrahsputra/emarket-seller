import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  Future<String> uploadProductImage(
      XFile image, Function(double)? onProgress) async {
    final storageRef = storage.ref('product_images/${image.name}');
    final uploadTask = storageRef.putFile(File(image.path));

    uploadTask.snapshotEvents.listen((event) {
      final progress = event.bytesTransferred / event.totalBytes;
      onProgress?.call(progress);
    });

    final snapshot = await uploadTask.whenComplete(() {});

    final downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<String> getProductUrl(String imageName) async {
    String downloadURL =
        await storage.ref('product_images/$imageName').getDownloadURL();

    return downloadURL;
  }

  Future<String> uploadProfileImage(
      XFile image, Function(double)? onProgress) async {
    final storageRef = storage.ref('profile_images/${image.name}');
    final uploadTask = storageRef.putFile(File(image.path));

    uploadTask.snapshotEvents.listen((event) {
      final progress = event.bytesTransferred / event.totalBytes;
      onProgress?.call(progress);
    });

    final snapshot = await uploadTask.whenComplete(() {});

    final downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  Future<String> getProfileUrl(String imageName) async {
    String downloadURL =
        await storage.ref('profile_images/$imageName').getDownloadURL();

    return downloadURL;
  }
}
