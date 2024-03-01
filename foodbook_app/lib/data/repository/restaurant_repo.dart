// repository/restaurant_repo.dart
import '../models/restaurant.dart';

class RestaurantRepository {
  // This method simulates fetching restaurant data
  List<Restaurant> fetchRestaurants() {
    // Ideally, this data would come from an API or a local database
    return [
      Restaurant(
        name: 'Divino Pecado',
        priceRange: 'M',
        timeRange: '15-20 min',
        distance: 0.8,
        categories: ['Vegan', 'Sandwich', 'Bowl', 'Healthy'],
        imagePaths: [
          'assets/images/divino_pecado_1.jpg',
          'assets/images/divino_pecado_2.jpg',
        ],
      ),
      Restaurant(
        name: 'MiCaserito',
        priceRange: 'B',
        timeRange: '25-30 min',
        distance: 0.2,
        categories: ['Comfort Food', 'Quick Bites'],
        imagePaths: [
          'assets/images/micaserito_1.jpg',
          'assets/images/micaserito_2.jpg',
        ],
      ),
    ];
  }
}


