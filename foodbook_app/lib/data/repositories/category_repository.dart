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
      final category = await FirebaseFirestore.instance.collection("categories").get();
      print(category);
      category.docs.forEach((element) {
        return categoryList.add(CategoryModel.fromJson(element.data()));
      });

      return categoryList;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }

      return categoryList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
