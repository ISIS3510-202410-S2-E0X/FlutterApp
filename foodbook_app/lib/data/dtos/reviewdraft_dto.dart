import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbook_app/data/models/reviewdraft.dart';

class ReviewDraftDTO {
  final String user;
  final String? title;
  final String? content;
  final Timestamp date;
  final String? imageUrl;
  final bool uploaded;
  final Map<String, double> ratings;
  final List<String> selectedCategories;

  ReviewDraftDTO({
    required this.user,
    required this.title,
    required this.content,
    required this.date,
    required this.imageUrl,
    required this.uploaded,
    required this.ratings,
    required this.selectedCategories,
  });

  factory ReviewDraftDTO.fromModel(ReviewDraft review) {
    return ReviewDraftDTO(
      user: review.user,
      title: review.title,
      content: review.content,
      // date: DateFormat('yyyy-MM-dd').format(review.date),
      date: review.date,
      imageUrl: review.imageUrl,
      uploaded: review.uploaded,
      ratings: review.ratings,
      selectedCategories: review.selectedCategories,
    );
  }

  ReviewDraftDTO toModel() {
    return ReviewDraftDTO(
      user: user,
      title: title,
      content: content,
      date: date,
      imageUrl: imageUrl,
      uploaded: uploaded,
      ratings: ratings,
      selectedCategories: selectedCategories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'title': title,
      'content': content,
      'date': date,
      'imageUrl': imageUrl,
      'uploaded': uploaded,
      'ratings': ratings,
      'selectedCategories': selectedCategories.map((category) => category).toList(),
    };
  }

  static ReviewDraftDTO fromJson(Map<String, dynamic> json) {
    Map<String, double> ratings = {};
    json['ratings']?.forEach((key, value) {
      ratings[key] = (value as num).toDouble();
    });

    return ReviewDraftDTO(
      user: (json['user'] as Map)['name'] as String,
      title: json['title'],
      content: json['content'],
      date: json['date'] as Timestamp,
      imageUrl: json['imageUrl'],
      uploaded: json['uploaded'],
      ratings: ratings,
      selectedCategories: List<String>.from(json['selectedCategories'] ?? []),
    );
  }
}
