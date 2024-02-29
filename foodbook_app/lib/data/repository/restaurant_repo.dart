// Define the Restaurant model in restaurant.dart
class Restaurant {
  final String name;
  final String priceRange;
  final String timeRange;
  final double distance;
  final List<String> categories;
  final List<String> images;

  Restaurant({
    required this.name,
    required this.priceRange,
    required this.timeRange,
    required this.distance,
    required this.categories,
    required this.images,
  });

  // Add fromJson, toJson if needed
}

// In restaurant_repo.dart, create a mock repository
class RestaurantRepository {
  List<Restaurant> getRestaurants() {
    return [
      Restaurant(
        name: 'Divino Pecado',
        priceRange: 'B',
        timeRange: '15-20 min',
        distance: 0.8,
        categories: ['Vegan', 'Sandwich', 'Bowl', 'Healthy'],
        images: [
          'assets/images/divino_pecado_1.jpg',
          'assets/images/divino_pecado_2.jpg',
          // Add more images as needed
        ],
      ),
      Restaurant(
        name: 'MiCaserito',
        priceRange: 'B',
        timeRange: '25-30 min',
        distance: 0.2,
        categories: ['Comfort Food', 'Quick Bites'],
        images: [
          'assets/images/micaserito_1.jpg',
          'assets/images/micaserito_2.jpg',
          // Add more images as needed
        ],
      ),
    ];
  }
}
