import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:foodbook_app/data/models/category.dart';

class CategoryRepository {
  // final _fireCloud = FirebaseFirestore.instance.collection("categories");

  // Future<void> create({ required String name }) async {
  //   try {
  //     await _fireCloud.add({ "name": name });
  //   } on FirebaseException catch (e) {
  //     if (kDebugMode) {
  //       print("Failed with error '${e.code}': ${e.message}");
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

    Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categoryList = [];
    try {
      final categorySnapshot = await FirebaseFirestore.instance.collection("categories").get();
      for (var doc in categorySnapshot.docs) {
        print(CategoryModel.fromJson(doc.data()));
        categoryList.add(CategoryModel.fromJson(doc.data()));
      }

      return categoryList;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code} - ${e.message}");
      throw Exception("Error loading categories: ${e.code}");
    } catch (e) {
      print("General Exception: $e");
      throw Exception("Error loading categories");
    }
  }
}
