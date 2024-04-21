import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewDraft {
  final String user;
  final String? title;
  final String? content;
  final Timestamp date;
  final String? imageUrl;
  final bool uploaded;
  final Map<String, double> ratings;
  final List<String> selectedCategories;

  ReviewDraft({
    required this.user,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.uploaded,
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
