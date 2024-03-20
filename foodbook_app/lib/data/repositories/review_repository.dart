import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodbook_app/data/dtos/review_dto.dart';

class ReviewRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("reviews");

  Future<String> create({ required ReviewDTO review }) async {
    try {
      DocumentReference reviewRef = await _fireCloud.add(review.toJson());
      return reviewRef.id; // Esto siempre retorna un String, lo cual es correcto.
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
}
