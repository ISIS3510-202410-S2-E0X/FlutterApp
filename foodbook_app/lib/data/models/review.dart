class Review {
  final String user;
  final String title;
  final String content;
  final DateTime date;
  final String? imageUrl;
  final Map<String, int> ratings;
  final String selectedCategories; // makes sense to change the data type to Category

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
