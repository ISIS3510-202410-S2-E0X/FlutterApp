import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbook_app/data/models/category.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart'; // Asegúrate de importar el DTO aquí.

class CategoryRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("categories");

  Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categoryList = [];
    try {
      final categorySnapshot = await _fireCloud.get();
      for (var doc in categorySnapshot.docs) {
        var dto = CategoryDTO.fromJson(doc.data());
        categoryList.add(dto.toModel());
      }

      return categoryList;
    } on FirebaseException catch (e) {
      throw Exception("Error loading categories: ${e.code}");
    } catch (e) {
      throw Exception("Error loading categories");
    }
  }
}
