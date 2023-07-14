import 'dart:developer';

import 'package:emarket_seller/common/common.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:emarket_seller/presentation/controller/controller.dart';
import 'package:emarket_seller/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final SellerController sellerController = Get.put(SellerController());
  final AuthController authController = Get.find<AuthController>();
  final Database database = Database();

  late GoogleMapController mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    markers.add(
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
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    markers.add(
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    getDirections();
    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
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
      color: const Color.fromARGB(255, 78, 111, 255),
      points: polylineCoordinates,
      width: 5,
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
        initState: (_) async {
          sellerController.seller = (await database.getSeller(
            authController.user!.uid,
          ))!;
        },
        builder: (controller) {
          return Stack(
            children: [
              buildMap(),
              buildBuyerInfo(context),
            ],
          );
        },
      ),
    );
  }

  buildMap() {
    return GoogleMap(
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.buyer.location.latitude,
          widget.buyer.location.longitude,
        ),
        zoom: 14.8,
      ),
      markers: markers,
      polylines: Set<Polyline>.of(polylines.values),
    );
  }

  buildBuyerInfo(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 30,
          left: 24,
          right: 24,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              offset: Offset(3, 3),
              spreadRadius: -1,
              blurRadius: 7,
              color: Color.fromRGBO(98, 97, 97, 0.5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.buyer.photoUrl),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.buyer.displayName,
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    Text(widget.buyer.phoneNumber),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.phone_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
