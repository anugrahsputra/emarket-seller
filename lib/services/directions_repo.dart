import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:emarket_seller/common/common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionRepo {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionRepo({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': google_api_key,
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.data);
      final List<LatLng> polylineCoordinates =
          decoded(decoded['routes'][0]['overview_polyline']['points']);
      return polylineCoordinates;
    } else {
      throw Exception('Failed to get directions');
    }
  }
}
