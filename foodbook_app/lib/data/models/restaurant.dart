import 'package:foodbook_app/data/models/review.dart';

class Restaurant {
  final String id;
  final String name;
  final List<String> categories;
  final List<String> imagePaths;
  final double latitude;
  final double longitude;
  List<Review> reviews;
  final int cleanliness_avg;
  final int waiting_time_avg;
  final int service_avg;
  final int food_quality_avg;
  final int waitTimeMin;
  final int waitTimeMax;
  final String priceRange;

  Restaurant({
    required this.id,
    required this.name,
    required this.categories,
    required this.imagePaths,
    required this.latitude,
    required this.longitude,
    required this.reviews,
    required this.cleanliness_avg,
    required this.waiting_time_avg,
    required this.service_avg,
    required this.food_quality_avg,
    required this.waitTimeMin,
    required this.waitTimeMax,
    required this.priceRange,
  });
}