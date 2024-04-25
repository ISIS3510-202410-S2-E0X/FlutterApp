import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart';
import 'package:foodbook_app/data/models/reviewdraft.dart';

class ReviewDraftDTO {
  final String user;
  final String? title;
  final String? content;
  final String? image;
  final String? spot;
  final int uploaded;
  final Map<String, int> ratings;
  final List<CategoryDTO> selectedCategories;

  ReviewDraftDTO({
    required this.user,
    required this.title,
    required this.content,
    required this.image,
    required this.spot,
    required this.uploaded,
    required this.ratings,
    required this.selectedCategories,
  });

  factory ReviewDraftDTO.fromModel(ReviewDraft review) {
    return ReviewDraftDTO(
      user: review.user,
      title: review.title,
      content: review.content,
      image: review.image,
      spot: review.spot,
      uploaded: review.uploaded,
      ratings: review.ratings,
      selectedCategories: review.selectedCategories,
    );
  }

  ReviewDraft toModel() {
    return ReviewDraft(
      user: user,
      title: title,
      content: content,
      image: image,
      spot: spot,
      uploaded: uploaded,
      ratings: ratings,
      selectedCategories: selectedCategories,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'user': user,
      'title': title,
      'content': content,
      'image': image,
      'uploaded': uploaded,  // SQLite no maneja Boolean, así que se convierte a int
      'spot': spot,
      'cleanliness': ratings[RatingsKeys.cleanliness],
      'service': ratings[RatingsKeys.service],
      'foodQuality': ratings[RatingsKeys.foodQuality],
      'waitTime': ratings[RatingsKeys.waitingTime],
      'category1': selectedCategories.isNotEmpty ? selectedCategories[0] : null,
      'category2': selectedCategories.length > 1 ? selectedCategories[1] : null,
      'category3': selectedCategories.length > 2 ? selectedCategories[2] : null,
    };
    return json;
  }

  factory ReviewDraftDTO.fromJson(Map<String, dynamic> json) {
    var jsonCategories = [];
    if (json['category1'] != null) jsonCategories.add({ 'name' : json['category1'] });
    if (json['category2'] != null) jsonCategories.add({ 'name' : json['category2'] });
    if (json['category3'] != null) jsonCategories.add({ 'name' : json['category3'] });

    return ReviewDraftDTO(
      user: json['user'] as String,
      title: json['title'] as String?,
      content: json['content'] as String?,
      image: json['imageUrl'] as String?,
      spot: json['spot'] as String?,
      uploaded: json['uploaded'] as int,
      ratings: {
        RatingsKeys.cleanliness: json['cleanliness'] as int,
        RatingsKeys.service: json['service'] as int,
        RatingsKeys.foodQuality: json['foodQuality'] as int,
        RatingsKeys.waitingTime: json['waitTime'] as int,
      },
      selectedCategories: jsonCategories.map((category) => CategoryDTO.fromJson(category)).toList(),
    );
  }
}
