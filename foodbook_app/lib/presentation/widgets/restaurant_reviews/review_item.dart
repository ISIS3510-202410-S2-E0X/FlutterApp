// review_item_widget.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/review.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener intl en tu pubspec.yaml para usar DateFormat

class ReviewItem extends StatelessWidget {
  final Review review;
  final bool isOffline;

  const ReviewItem({
    super.key,
    required this.review,
    required this.isOffline
  });

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
            review.title != null ? Text(review.title!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)) : const SizedBox.shrink(),
            const SizedBox(height: 4),
            // Text('by ${review.user} - ${DateFormat('dd/MM/yyyy').format(review.date)}'),
            Text('by ${review.user['name']} - ${DateFormat('dd/MM/yyyy HH:mm:ss').format(review.date.toDate())}'),
            const SizedBox(height: 10),
            review.content != null ? Text(review.content!) : const SizedBox.shrink(),
            const SizedBox(height: 10),
            // ignore: avoid_print
            if (review.imageUrl != null && !isOffline) {
              Image.network(
                review.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // If there is an error in loading the image from the network, show a placeholder image
                  return Image.asset(
                    'lib/presentation/images/review-detail-no-connection.jpeg', // Path to your placeholder image
                    fit: BoxFit.cover,
                  );
                },
              ),
            }
            if (isOffline) Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset('lib/presentation/images/review-detail-no-connection.jpeg'
                ),
              )
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('Cleanliness')),
                _buildRatingStars((review.ratings['cleanliness'] ?? 0).toInt()),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Waiting Time')),
                _buildRatingStars((review.ratings['waitTime'] ?? 0).toInt()),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Service')),
                _buildRatingStars((review.ratings['service'] ?? 0).toInt()),
              ],
            ),
            Row(
              children: [
                const Expanded(child: Text('Food Quality')),
                _buildRatingStars((review.ratings['foodQuality'] ?? 0).toInt()),
              ],
            ),
            const SizedBox(height: 10),
            // Text('Categories: ${review.selectedCategories}'),
            Text('Categories: ${review.selectedCategories.map((c) => c).join(', ')}'),
          ],
        ),
      ),
    );
  }
}
