import 'dart:developer';

import 'package:emarket_seller/model/model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  final Geolocator geolocator = Geolocator();
  late Rx<LocationModel> location;

  Position? currentPosition;

  @override
  void onInit() {
    super.onInit();
    location = Rx<LocationModel>(const LocationModel(
      latitude: 0.0,
      longitude: 0.0,
    ));
    getCurrentLocation();
  }

  Future checkPermission() async {
    var status = await Permission.location.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.location.request();
      if (status != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    if (status == PermissionStatus.permanentlyDenied) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    try {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
    } catch (e) {
      return Future.error('Location services are disabled.');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      await checkPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      location.value = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng, localeIdentifier: 'id');
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            "${placemark.street}, ${placemark.locality}, ${placemark.subLocality}";
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Error getting address: $e";
    }
  }
}
