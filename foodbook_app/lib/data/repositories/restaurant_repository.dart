// repository/restaurant_repo.dart
import 'package:foodbook_app/data/models/category.dart';
import 'package:foodbook_app/data/models/review.dart';

import '../models/restaurant.dart';

class RestaurantRepository {
  // This method simulates fetching restaurant data
  final List<Restaurant> _restaurants = [
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
        reviews: [
          Review(
            user: 'Alice Smith',
            title: 'Delicious Homemade Meals',
            content: 'The meals had a home-cooked feel that I absolutely loved! The ambiance was cozy and welcoming.',
            date: '20-01-2024', // DateTime(2024, 1, 20),
            imageUrl: null, // 'file:///foodbook_app/lib/presentation/images/divino_pecado_1.jpeg',
            ratings: {
              RatingsKeys.cleanliness: 5,
              RatingsKeys.waitingTime: 4,
              RatingsKeys.service: 5,
              RatingsKeys.foodQuality: 5,
            },
            selectedCategories: [CategoryModel(name: 'homemade')],
          ),
          Review(
            user: 'Bob Johnson',
            title: 'Slow Service',
            content: 'The food was quite good, but the waiting time was longer than expected.',
            date: '20-01-2024', // DateTime(2024, 1, 22),
            imageUrl: null, // no image provided for this review
            ratings: {
              RatingsKeys.cleanliness: 4,
              RatingsKeys.waitingTime: 2,
              RatingsKeys.service: 3,
              RatingsKeys.foodQuality: 4,
            },
            selectedCategories: [
              CategoryModel(name: 'vegan'),
              CategoryModel(name: 'healthy'),
              CategoryModel(name: 'salad'),
              CategoryModel(name: 'juices'),
            ],
          ),
        ],
        cleanliness_avg: 81,
        waiting_time_avg: 89,
        service_avg: 45,
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
        reviews: [
          Review(
            user: 'Carol Williams',
            title: 'Exceptional Desserts',
            content: 'Their desserts are out of this world! The perfect ending to our meal.',
            date: '20-01-2024', //  DateTime(2024, 1, 25),
            imageUrl: null, // 'lib/presentation/images/divino_pecado_2.jpeg',
            ratings: {
              RatingsKeys.cleanliness: 5,
              RatingsKeys.waitingTime: 5,
              RatingsKeys.service: 5,
              RatingsKeys.foodQuality: 5,
            },
            selectedCategories: [CategoryModel(name: 'italian')],
          ),
        ],
        cleanliness_avg: 81,
        waiting_time_avg: 89,
        service_avg: 92,
        food_quality_avg: 94,
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
        reviews: restaurant.reviews,
        cleanliness_avg: restaurant.cleanliness_avg,
        waiting_time_avg: restaurant.waiting_time_avg,
        service_avg: restaurant.service_avg,
        food_quality_avg: restaurant.food_quality_avg,
        bookmarked: !restaurant.bookmarked,
      );
    }
  }
}
