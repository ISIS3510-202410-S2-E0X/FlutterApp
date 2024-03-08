import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';


class SpotDetail extends StatelessWidget {
  final Restaurant restaurant;

  const SpotDetail({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name), // Display the restaurant's name in the AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display various restaurant details here
            // For example, an image if available
            if (restaurant.imagePaths.isNotEmpty)
              Image.network(restaurant.imagePaths.first),
            // You can add more details like the restaurant's description, menu, etc.
          ],
        ),
      ),
    );
  }
}