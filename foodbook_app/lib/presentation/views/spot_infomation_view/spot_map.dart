import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class SpotMap extends StatefulWidget {
  final Restaurant restaurant;

  const SpotMap({Key? key, required this.restaurant}) : super(key: key);

  @override
  _SpotMapState createState() => _SpotMapState();
}

class _SpotMapState extends State<SpotMap> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId(widget.restaurant.name.toString()),
            position: LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}