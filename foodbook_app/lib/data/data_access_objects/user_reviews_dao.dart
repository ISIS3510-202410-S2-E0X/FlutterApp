

import 'dart:convert';

import 'package:foodbook_app/data/dtos/review_dto.dart';
import 'package:foodbook_app/data/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserReviewsDAO{

  Future<void> cacheReview(Review review, String user) async {
    // Code to cache review
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userCache = prefs.getStringList("${user}Reviews") ?? [];
    print("Current cache: $userCache");
    var currentLength = userCache.length;
    var reviewId = "${user}_$currentLength";
    print("Cached review with id: $reviewId");
    if (!userCache.contains(reviewId)) {
      userCache.add(reviewId);
      await prefs.setStringList("${user}Reviews", userCache);
    }
    await prefs.setString(reviewId, serializeReview(review));
  }

  String serializeReview(Review review) {
    ReviewDTO reviewDTO = ReviewDTO.fromModel(review);
    var serializado = reviewDTO.toJsonCache(); 
    return json.encode(serializado);
  }

  Future<List<String>> getCachedReviews(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("${user}Reviews") ?? [];
  }
  Future<String> getReview(String reviewId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(reviewId) ?? "";
  }
}


// class UserReviewsDAO {
  

//   // Store JSON in Hive
//   Future<void> storeJsonInCache(Review review, String user ) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> userCache = prefs.getStringList("${user}Reviews") ?? [];
//     var box = Hive.box("${user}Reviews");
//     var currentLength = userCache.length;
//     if (!userCache.contains("${user}_$currentLength")) {
//       userCache.add("${user}_$currentLength");
//       await prefs.setStringList("${user}Reviews", userCache);
//       var reviewId = "${user}_$currentLength";
//     var json = ReviewDTO.fromModel(review).toJsonCache();
//     print("Cached review with id: $reviewId");
//     print("Caching review: $json");
//     await box.put(reviewId, json);
//     }
    
//   }

//   // Retrieve JSON from Hive
//   Future<Map<String, dynamic>?> getJsonFromCache(String user, String key) async {
//     var box = Hive.box("${user}Reviews");
//     return box.get(key) as Map<String, dynamic>?;
//   }
//   Future<List<String>> getCachedReviews(String user) async {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      return prefs.getStringList("${user}Reviews") ?? [];
//   }

// }





