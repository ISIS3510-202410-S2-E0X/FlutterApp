import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class CategorySection extends StatelessWidget {
  final Restaurant restaurant;

  const CategorySection({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: restaurant.categories.map((category) => Container(
          margin: EdgeInsets.only(right: 8),
          child: Chip(
            label: Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Color.fromARGB(255, 199, 199, 199), // Changed color to grey
          ),
        )).toList(),
      ),
    );
  }
}
