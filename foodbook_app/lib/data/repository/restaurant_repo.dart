// repository/restaurant_repo.dart
import '../models/restaurant.dart';

class RestaurantRepository {
  // This method simulates fetching restaurant data
  List<Restaurant> _restaurants = [
    // Ideally, this data would come from an API or a local database
      Restaurant(
        id: '1',
        name: 'Divino Pecado',
        priceRange: '\$\$',
        timeRange: '15-20 min',
        distance: 0.8,
        categories: ['Vegan', 'Sandwich', 'Bowl', 'Healthy', 'Salad', 'Juices'],
        imagePaths: [
          'lib/presentation/images/divino_pecado_1.jpeg',
          'lib/presentation/images/divino_pecado_2.jpg',
          'lib/presentation/images/divino_pecado_3.jpg',
          'lib/presentation/images/divino_pecado_1.jpeg',
        ],
        cleanliness_avg: 81,
        waiting_time_avg: 49,
        service_avg: 92,
        food_quality_avg: 94,
        bookmarked: true,
      ),
      Restaurant(
        id: '2',
        name: 'MiCaserito',
        priceRange: '\$',
        timeRange: '25-30 min',
        distance: 0.2,
        categories: ['Comfort Food', 'Homemade'],
        imagePaths: [
          'lib/presentation/images/divino_pecado_1.jpeg',
          'lib/presentation/images/divino_pecado_3.jpg',
          'lib/presentation/images/divino_pecado_2.jpg',
          'lib/presentation/images/divino_pecado_1.jpeg',
          'lib/presentation/images/divino_pecado_3.jpg',
        ],
        cleanliness_avg: 60,
        waiting_time_avg: 100,
        service_avg: 40,
        food_quality_avg: 85,
        bookmarked: false,
      ),
  ];

  List<Restaurant> fetchRestaurants() {
    return _restaurants;
  }
  


  Future<void> toggleBookmark(String restaurantId) async {
    // Encuentra el restaurante por ID y cambia su estado de `bookmarked`
    final index = _restaurants.indexWhere((r) => r.id == restaurantId); // Asegúrate de que tu modelo de restaurante tenga un campo `id`
    if (index != -1) {
      final restaurant = _restaurants[index];
      _restaurants[index] = Restaurant(
        id: restaurant.id,
        name: restaurant.name,
        priceRange: restaurant.priceRange,
        timeRange: restaurant.timeRange,
        distance: restaurant.distance,
        categories: restaurant.categories,
        imagePaths: restaurant.imagePaths,
        cleanliness_avg: restaurant.cleanliness_avg,
        waiting_time_avg: restaurant.waiting_time_avg,
        service_avg: restaurant.service_avg,
        food_quality_avg: restaurant.food_quality_avg,
        bookmarked: !restaurant.bookmarked,
      );
    }
  }

  
}


