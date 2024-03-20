import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class SubtitleSection extends StatelessWidget {
  final Restaurant restaurant;

  const SubtitleSection({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
        SizedBox(width: 4),
        Text(
          '${restaurant.waitTimeMin}-${restaurant.waitTimeMax} · ',
          style: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 53, 53, 53),
          ),
        ),
        Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
        SizedBox(width: 4),
        Text(
          '0 km',
          style: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 53, 53, 53),
          ),
        ),
      ],
    );
  }
}
