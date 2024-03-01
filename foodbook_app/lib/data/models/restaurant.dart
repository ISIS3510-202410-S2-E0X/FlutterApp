
class Restaurant {
  final String name;
  final String priceRange;
  final String timeRange;
  final double distance;
  final List<String> categories;
  final List<String> imagePaths;

  Restaurant({
    required this.name,
    required this.priceRange,
    required this.timeRange,
    required this.distance,
    required this.categories,
    required this.imagePaths,
  });

  // Method to create a Restaurant from a JSON object
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      priceRange: json['priceRange'],
      timeRange: json['timeRange'],
      distance: json['distance'],
      categories: List<String>.from(json['categories']),
      imagePaths: List<String>.from(json['imagePaths']),
    );
  }

  // Method to convert a Restaurant object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'priceRange': priceRange,
      'timeRange': timeRange,
      'distance': distance,
      'categories': categories,
      'imagePaths': imagePaths,
    };
  }
}