import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class CategorySection extends StatelessWidget {
  final Restaurant restaurant;

  const CategorySection({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Truncate the list to the first 5 categories and modify strings to eliminate text after a period
    List<String> modifiedCategories = restaurant.categories
      .map((category) => category.split('.')[0])  // Take the text before the first period
      .take(5)  // Only take the first 5 categories
      .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: modifiedCategories.map((category) => Container(
          margin: EdgeInsets.only(right: 8),
          child: Chip(
            label: Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent, // Changed color to grey
          ),
        )).toList(),
      ),
    );
  }
}

