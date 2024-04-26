import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final Map<String, String> user;
  final String? title;
  final String? content;
  final Timestamp date;
  final String? imageUrl;
  final Map<String, double> ratings;
  final List<String> selectedCategories;
  String? spot;

  Review({
    required this.user,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.ratings,
    required this.selectedCategories,
    this.spot,
  });
}

class RatingsKeys {
  static const String cleanliness = 'cleanliness';
  static const String waitingTime = 'waitTime';
  static const String service = 'service';
  static const String foodQuality = 'foodQuality';
}
