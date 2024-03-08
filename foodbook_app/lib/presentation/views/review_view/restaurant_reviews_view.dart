import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_reviews/review_item.dart';

class ReviewListView extends StatelessWidget {
  final Restaurant restaurant;

  const ReviewListView({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...restaurant.reviews.map((review) => ReviewItem(review: review)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
