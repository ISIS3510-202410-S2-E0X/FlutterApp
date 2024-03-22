import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String user;
  final String? title;
  final String? content;
  final Timestamp date;
  final String? imageUrl;
  final Map<String, double> ratings;
  final List<String> selectedCategories;

  Review({
    required this.user,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.ratings,
    required this.selectedCategories,
  });
}

class RatingsKeys {
  static const String cleanliness = 'cleanliness';
  static const String waitingTime = 'waitTime';
  static const String service = 'service';
  static const String foodQuality = 'foodQuality';
}
