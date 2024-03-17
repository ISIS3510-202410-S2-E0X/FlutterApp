import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodbook_app/data/dtos/review_dto.dart';

class ReviewRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("reviews");

  Future<void> create({ required ReviewDTO review }) async {
    try {
      await _fireCloud.add(review.toJson());
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}
