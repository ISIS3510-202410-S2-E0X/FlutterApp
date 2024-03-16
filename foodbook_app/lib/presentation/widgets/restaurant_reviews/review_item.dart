// review_item_widget.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/review.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener intl en tu pubspec.yaml para usar DateFormat

class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({Key? key, required this.review}) : super(key: key);

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20.0,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            // Text('by ${review.user} - ${DateFormat('dd/MM/yyyy').format(review.date)}'),
            Text('by ${review.user} - ${review.date}'),
            const SizedBox(height: 10),
            Text(review.content),
            const SizedBox(height: 10),
            // ignore: avoid_print
            if (review.imageUrl != null) Image.asset(review.imageUrl!, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('Cleanliness')),
                _buildRatingStars(review.ratings['cleanliness'] ?? 0),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Waiting Time')),
                _buildRatingStars(review.ratings['waitingTime'] ?? 0),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Service')),
                _buildRatingStars(review.ratings['service'] ?? 0),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Food Quality')),
                _buildRatingStars(review.ratings['foodQuality'] ?? 0),
              ],
            ),
            const SizedBox(height: 10),
            // Asumiendo que selectedCategories es una cadena de texto que contiene categorías separadas por comas
            // Text('Categories: ${review.selectedCategories}'),
            Text('Categories: ${review.selectedCategories.map((c) => c.name).join(', ')}'),
          ],
        ),
      ),
    );
  }
}
