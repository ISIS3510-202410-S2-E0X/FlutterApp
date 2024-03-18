import 'package:foodbook_app/data/dtos/category_dto.dart';
import 'package:foodbook_app/data/models/review.dart';
// import 'package:intl/intl.dart'; 

class ReviewDTO {
  final String user;
  final String title;
  final String content;
  final String date;
  final String? imageUrl;
  final Map<String, double> ratings;
  final List<CategoryDTO> selectedCategoriesDTOs;

  ReviewDTO({
    required this.user,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl,
    required this.ratings,
    required this.selectedCategoriesDTOs,
  });

  factory ReviewDTO.fromModel(Review review) {
    return ReviewDTO(
      user: review.user,
      title: review.title,
      content: review.content,
      // date: DateFormat('yyyy-MM-dd').format(review.date),
      date: review.date,
      imageUrl: review.imageUrl,
      ratings: review.ratings,
      selectedCategoriesDTOs: review.selectedCategories.map((cat) => CategoryDTO.fromModel(cat)).toList(),
    );
  }

  Review toModel() {
    return Review(
      user: user,
      title: title,
      content: content,
      // date: DateFormat('yyyy-MM-dd').parse(this.date),
      date: date,
      imageUrl: imageUrl,
      ratings: ratings,
      selectedCategories: selectedCategoriesDTOs.map((dto) => dto.toModel()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'title': title,
      'content': content,
      'date': date,
      'imageUrl': imageUrl,
      'ratings': ratings,
      'selectedCategories': selectedCategoriesDTOs.map((dto) => dto.toJson()).toList(),
    };
  }

  static ReviewDTO fromJson(Map<String, dynamic> json) {
    var selectedCategoriesJson = json['selectedCategories'] as List<dynamic>;
    return ReviewDTO(
      user: json['user'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
      imageUrl: json['imageUrl'] as String?,
      ratings: Map<String, double>.from(json['ratings']),
      selectedCategoriesDTOs: selectedCategoriesJson.map((catJson) => CategoryDTO.fromJson(catJson)).toList(),
    );
  }
}
