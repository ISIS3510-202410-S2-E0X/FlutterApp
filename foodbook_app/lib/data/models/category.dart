class CategoryModel {
  final String name;

  CategoryModel({required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['name'] == null) {
      throw Exception('El campo "name" es nulo o no está presente.');
    }
    return CategoryModel(
      name: json['name'] as String,
    );
  }
}
