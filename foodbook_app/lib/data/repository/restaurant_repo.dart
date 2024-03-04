// repository/restaurant_repo.dart
import '../models/restaurant.dart';

class RestaurantRepository {
  // This method simulates fetching restaurant data
  List<Restaurant> fetchRestaurants() {
    // Ideally, this data would come from an API or a local database
    return [
      Restaurant(
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
        waiting_time_avg: 89,
        service_avg: 92,
        food_quality_avg: 94,
      ),
      Restaurant(
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
        cleanliness_avg: 81,
        waiting_time_avg: 89,
        service_avg: 92,
        food_quality_avg: 94,
      ),
    ];
  }
}


