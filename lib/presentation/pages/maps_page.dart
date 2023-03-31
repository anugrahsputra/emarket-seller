import 'dart:developer';

import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.buyer}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
  final Buyer buyer;
}

class _MapPageState extends State<MapPage> {
  final buyerController = Get.find<BuyerController>();
  final locationController = Get.find<LocationController>();
  final sellerController = Get.find<SellerController>();
  late GoogleMapController mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  Map<PolylineId, Polyline> polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    getDirections();
    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(
        widget.buyer.location.latitude,
        widget.buyer.location.longitude,
      ),
      PointLatLng(
        sellerController.seller.location.latitude,
        sellerController.seller.location.longitude,
      ),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      log(result.errorMessage.toString());
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
      ),
      body: GetBuilder<SellerController>(
        builder: (controller) {
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.buyer.location.latitude,
                widget.buyer.location.longitude,
              ),
              zoom: 16,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('buyerLoc'),
                position: LatLng(
                  widget.buyer.location.latitude,
                  widget.buyer.location.longitude,
                ),
                infoWindow: InfoWindow(
                  title: widget.buyer.displayName,
                  snippet: widget.buyer.address,
                ),
              ),
              Marker(
                markerId: const MarkerId('sellerLoc'),
                position: LatLng(
                  sellerController.seller.location.latitude,
                  sellerController.seller.location.longitude,
                ),
                infoWindow: InfoWindow(
                  title: sellerController.seller.displayName,
                  snippet: sellerController.seller.address,
                ),
              ),
            },
            polylines: Set<Polyline>.of(polylines.values),
          );
        },
      ),
    );
  }
}
