import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:foodbook_app/data/dtos/review_dto.dart';

class ReviewRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("reviews");

  Future<String> create({ required ReviewDTO review }) async {
    try {
      DocumentReference reviewRef = await _fireCloud.add(review.toJson());
      return reviewRef.id;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      // En vez de retornar un string vacío, lanzamos una excepción para mantener la consistencia.
      throw FirebaseException(
        plugin: 'cloud_firestore', 
        message: "Failed to add review: '${e.code}': ${e.message}"
      );
    } catch (e) {
      // Esto captura cualquier otro tipo de excepción que no sea FirebaseException.
      throw Exception(e.toString());
    }
  }

  Future<String> saveImage(File image) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('reviewImages');
    
    String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(image.path));
      return await referenceImageToUpload.getDownloadURL();
    } catch(error) {
      if (kDebugMode) {
        print("Failed to save image with error: $error");
      }
      throw Exception("Failed to save image: $error");
    }
  }
}
