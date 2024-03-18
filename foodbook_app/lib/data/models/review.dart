import 'package:foodbook_app/data/models/category.dart';

class Review {
  final String user;
  final String? title;
  final String? content;
  final String date; // does firebase accept dateTimes?
  final String? imageUrl;
  final Map<String, double> ratings;
  final List<CategoryModel> selectedCategories;

  Review({
    required this.user,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
    required this.ratings,
    required this.selectedCategories,
  });
}

class RatingsKeys {
  static const String cleanliness = 'cleanliness';
  static const String waitingTime = 'waitingTime';
  static const String service = 'service';
  static const String foodQuality = 'foodQuality';
}
