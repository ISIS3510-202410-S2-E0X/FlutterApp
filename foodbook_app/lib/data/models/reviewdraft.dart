import 'dart:io';

import 'package:foodbook_app/data/dtos/category_dto.dart';

class ReviewDraft {
  final String user;
  final String? title;
  final String? content;
  final String? image;
  final File? imageFile;
  final String? spot;
  final int uploaded; // SQLite no maneja Boolean, así que se convierte a int
  final Map<String, double> ratings;
  final List<CategoryDTO> selectedCategories;

  ReviewDraft({
    required this.user,
    required this.title,
    required this.content,
    required this.image,
    required this.spot,
    required this.uploaded,
    required this.ratings,
    required this.selectedCategories,
    required this.imageFile, String? imagePath,
  });
}

class RatingsKeys {
  static const String cleanliness = 'cleanliness';
  static const String waitingTime = 'waitTime';
  static const String service = 'service';
  static const String foodQuality = 'foodQuality';
}