import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:geolocator/geolocator.dart';

class SubtitleSection extends StatefulWidget {
  final Restaurant restaurant;

  const SubtitleSection({Key? key, required this.restaurant}) : super(key: key);

  @override
  _SubtitleSectionState createState() => _SubtitleSectionState();
}

class _SubtitleSectionState extends State<SubtitleSection> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  String _calculateDistance(Position userLocation) {
    double distanceInMeters = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      widget.restaurant.latitude,
      widget.restaurant.longitude,
    );
    double distanceInKm = distanceInMeters / 1000;
    return '${distanceInKm.toStringAsFixed(2)} km';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _determinePosition(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //  return CircularProgressIndicator();
        // } else 
        if (snapshot.hasData) {
          // Calculate the distance using the user location and restaurant location
          String distance = _calculateDistance(snapshot.data!);

          return Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
              SizedBox(width: 4),
              Text(
                '${widget.restaurant.waitTimeMin}-${widget.restaurant.waitTimeMax} · ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 53, 53, 53),
                ),
              ),
              Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
              SizedBox(width: 4),
              Text(
                distance,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 53, 53, 53),
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
              SizedBox(width: 4),
              Text(
                '${widget.restaurant.waitTimeMin}-${widget.restaurant.waitTimeMax} · ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 53, 53, 53),
                ),
              ),
              Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
              SizedBox(width: 4),
              Text(
                "- km",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 53, 53, 53),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
