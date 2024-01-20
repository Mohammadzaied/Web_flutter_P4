import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:geolocator/geolocator.dart';

class Location_p extends StatefulWidget {
  final double Latefrom;
  final double longfrom;
  final double Lateto;
  final double longto;

  Location_p(
      {required this.Latefrom,
      required this.longfrom,
      required this.Lateto,
      required this.longto});

  @override
  State<Location_p> createState() => _Location_pState();
}

class _Location_pState extends State<Location_p> {
  late double Latefrom;
  late double longfrom;
  late double Lateto;
  late double longto;
  GoogleMapController? mapController;
  List<Marker> markers = [];

  void initState() {
    longfrom = widget.longfrom;
    Latefrom = widget.Latefrom;
    Lateto = widget.Lateto;
    longto = widget.longto;

    _addMarker(LatLng(Latefrom, longfrom), 'Package From');
    _addMarker(LatLng(Lateto, longto), 'Package To');
    super.initState();
  }

  initial() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('service location not enabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission denied');
      }
    }
  }

  _addMarker(LatLng position, String desc) {
    MarkerId markerId = MarkerId(desc);
    Marker marker = Marker(
        markerId: markerId,
        infoWindow: InfoWindow(title: desc),
        position: position);
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primarycolor,
      ),
      body: Container(
          child: GoogleMap(
        markers: markers.toSet(),
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(31.941710, 35.257820),
          zoom: 8.0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
      )),
    );
  }
}
