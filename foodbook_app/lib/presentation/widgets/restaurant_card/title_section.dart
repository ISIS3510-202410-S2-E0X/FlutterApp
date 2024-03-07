import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class TitleSection extends StatelessWidget {
  final Restaurant restaurant;

  const TitleSection({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            fontSize: 18, // Increased font size
            color: Colors.black, // Default color for all spans
          ),
          children: [
            TextSpan(
              text: restaurant.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: ' · '), // Dot separator
            TextSpan(
              text: restaurant.priceRange,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

