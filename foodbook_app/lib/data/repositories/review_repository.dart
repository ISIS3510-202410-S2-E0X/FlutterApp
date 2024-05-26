import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodbook_app/data/data_access_objects/user_reviews_dao.dart';
import 'package:foodbook_app/data/data_sources/user_reviews_sa.dart';
import 'package:foodbook_app/data/dtos/review_dto.dart';
import 'package:foodbook_app/data/models/review.dart';

class ReviewRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("reviews");
  final _fireCloudReportReviews = FirebaseFirestore.instance.collection("reviewReports");

  Future<String> create({ required ReviewDTO review }) async {
    try {
      DocumentReference reviewRef = await _fireCloud.add(review.toJson());
      return reviewRef.id;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: "Failed to add review: '${e.code}': ${e.message}"
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future getReviewById(String id) async {
    try {
      DocumentSnapshot review = await _fireCloud.doc(id).get();
      return review.data();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: "Failed to get review: '${e.code}': ${e.message}"
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Review>> fetchReviews(List<String> reviewIds) async {
    List<Review> reviews = [];
    print('REVIEW IDS: $reviewIds');
    for (String id in reviewIds) {
      var reviewData = await getReviewById(id);
      print('REVIEW DATA: $reviewData');
      if (reviewData != null) {
        ReviewDTO reviewDTO = ReviewDTO.fromJson(reviewData);
        reviews.add(reviewDTO.toModel());
      }
    }
    return reviews;
  }

  Future<String> saveImage(File image) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('reviewImages');

    String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    SettableMetadata metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );

    try {
      print('IMAGEN ACÁ: ${image.path}, ${image.runtimeType}, ${image}');
      await referenceImageToUpload.putFile(File(image.path), metadata);
      String path = await referenceImageToUpload.getDownloadURL();
      return path;
    } catch(error) {
      if (kDebugMode) {
        print("Failed to save image with error: $error");
      }
      throw Exception("Failed to save image: $error");
    }
  }

  Future<ImageProvider> getImage(String fullPath) async {
    final ref = FirebaseStorage.instance.ref().child(fullPath);
    final String downloadUrl = await ref.getDownloadURL();
    return NetworkImage(downloadUrl);
  }

  Future<List<Review>> fetchUserReviews(String mail, String name) async {
    var cutmail = mail.split('@')[0];
    var res = await UserReviewsServiceAdapter().getUserReviews(cutmail, name);

    List<Review> revs = res
          .map((c) => ReviewDTO.fromJson(c).toModel())
          .toList();
    for (var rev in revs) {
      UserReviewsDAO().cacheReview(rev, cutmail);
    }
    print(revs[0].date);
    return revs;
  }
  Future<List<Review>> fetchUserReviewsFromCache(String mail) async {
    try {
      var cutmail = mail.split('@')[0];
      List<Review> revs = [];
      List<String> res = await UserReviewsDAO().getCachedReviews(cutmail);
      for (var key in res) {
        String review= await UserReviewsDAO().getReview(key);
        if (review != "") {
          
          revs.add(ReviewDTO.fromJsonCache(jsonDecode(review)).toModel());
        }
      }
      return revs;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> getReviewId(Review review) async {
    Map<String, dynamic> attributes = {
        'date': review.date,
        'title': review.title,
        'content': review.content,
        'user': review.user,
      };

    Query query = _fireCloud;

    attributes.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });

    QuerySnapshot querySnapshot = await query.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    if (documents.isNotEmpty) {
      print("ID del documento encontrado: ${documents.first.id}");
      return documents.first.id;
    } else {
      print("No se encontró ningún documento con esos atributos.");
      return null;
    }
  }

  Future<String> reportReview({ required String report, required Review review, required String user }) async {
    try {
      String? reviewId = await getReviewId(review);
      DocumentReference reviewRef = _fireCloud.doc(reviewId);

      DocumentReference reportRef = await _fireCloudReportReviews.add({
        'date': Timestamp.fromDate(DateTime.now()),
        'reason': report,
        'reportedBy': user,
        'reviewId': reviewRef,
      });
      return reportRef.id;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: "Failed to report review: '${e.code}': ${e.message}"
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
}
  

