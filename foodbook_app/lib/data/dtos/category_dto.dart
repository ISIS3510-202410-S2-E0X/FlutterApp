import 'package:foodbook_app/data/models/category.dart';

class CategoryDTO {
  final String name;

  CategoryDTO({required this.name});

  factory CategoryDTO.fromModel(CategoryModel model) {
    return CategoryDTO(name: model.name);
  }

  CategoryModel toModel() {
    return CategoryModel(name: name);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  static CategoryDTO fromJson(Map<String, dynamic> json) {
    if (json['name'] == null) {
      throw Exception('El campo "name" es nulo o no está presente.');
    }
    return CategoryDTO(
      name: json['name'] as String,
    );
  }
}
