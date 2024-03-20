import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart';

class CategoryRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("categories");

  Future<List<CategoryDTO>> getAllCategories() async {
    List<CategoryDTO> categoryList = [];
    try {
      final categorySnapshot = await _fireCloud.get();
      for (var doc in categorySnapshot.docs) {
        var dto = CategoryDTO.fromJson(doc.data());
        categoryList.add(dto);
      }

      return categoryList;
    } on FirebaseException catch (e) {
      throw Exception("Error loading categories: ${e.code}");
    } catch (e) {
      throw Exception("Error loading categories");
    }
  }
}
