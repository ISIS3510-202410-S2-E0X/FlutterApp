import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodbook_app/data/dtos/restaurant_dto.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class RestaurantRepository {

  Future<List<Restaurant>> fetchRestaurants() async {

    List<Restaurant> restaurants = [];

    try {

      final pro = await FirebaseFirestore.instance.collection('spots').get();

      pro.docs.forEach((element) {
        restaurants.add(RestaurantDTO.fromJson(element.data()).toModel());
      });

      return restaurants;

    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed to fetch restaurants with error '${e.code}': ${e.message}");
      }
      return restaurants;
    }
  }

  Future<void> addReviewToRestaurant(String restaurantId, String reviewId) async {
    try {
      print('RESTAURANT ID: $restaurantId');
      DocumentReference restaurantRef = FirebaseFirestore.instance.collection('spots').doc(restaurantId);
      
      DocumentReference reviewRef = FirebaseFirestore.instance.collection('reviews').doc(reviewId);
      
      await restaurantRef.update({
        'reviewData.userReviews': FieldValue.arrayUnion([reviewRef])
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed to add review to restaurant: $e");
      }
      rethrow;
    }
  }

  Future<String?> findRestaurantIdByName(String name) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('spots')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error al buscar el restaurante: $e");
      return null;
    }
  }

}



// // repository/restaurant_repo.dart
// import 'package:foodbook_app/data/models/category.dart';
// import 'package:foodbook_app/data/models/review.dart';

// import '../models/restaurant.dart';

// class RestaurantRepository {
//   // This method simulates fetching restaurant data
//   final List<Restaurant> _restaurants = [
//     // Ideally, this data would come from an API or a local database
//       Restaurant(
//         id: '1',
//         name: 'Divino Pecado',
//         priceRange: '\$\$',
//         timeRange: '15-20 min',
//         distance: 0.8,
//         categories: ['Vegan', 'Sandwich', 'Bowl', 'Healthy', 'Salad', 'Juices'],
//         imagePaths: [
//           'lib/presentation/images/divino_pecado_1.jpeg',
//           'lib/presentation/images/divino_pecado_2.jpg',
//           'lib/presentation/images/divino_pecado_3.jpg',
//           'lib/presentation/images/divino_pecado_1.jpeg',
//         ],
//         reviews: [
//           Review(
//             user: 'Alice Smith',
//             title: 'Delicious Homemade Meals',
//             content: 'The meals had a home-cooked feel that I absolutely loved! The ambiance was cozy and welcoming.',
//             date: '20-01-2024', // DateTime(2024, 1, 20),
//             imageUrl: null, // 'file:///foodbook_app/lib/presentation/images/divino_pecado_1.jpeg',
//             ratings: {
//               RatingsKeys.cleanliness: 5,
//               RatingsKeys.waitingTime: 4,
//               RatingsKeys.service: 5,
//               RatingsKeys.foodQuality: 5,
//             },
//             selectedCategories: ['homemade'],
//           ),
//           Review(
//             user: 'Bob Johnson',
//             title: 'Slow Service',
//             content: 'The food was quite good, but the waiting time was longer than expected.',
//             date: '20-01-2024', // DateTime(2024, 1, 22),
//             imageUrl: null, // no image provided for this review
//             ratings: {
//               RatingsKeys.cleanliness: 4,
//               RatingsKeys.waitingTime: 2,
//               RatingsKeys.service: 3,
//               RatingsKeys.foodQuality: 4,
//             },
//             selectedCategories: [
//               'vegan',
//               'healthy',
//               'salad',
//               'juices',
//             ],
//           ),
//         ],
//         cleanliness_avg: 81,
//         waiting_time_avg: 89,
//         service_avg: 45,
//         food_quality_avg: 94,
//         latitude: 37.7749,
//         longitude: -122.4194,
//         bookmarked: true,
//       ),
//       Restaurant(
//         id: '2',
//         name: 'MiCaserito',
//         priceRange: '\$',
//         timeRange: '25-30 min',
//         distance: 0.2,
//         categories: ['Comfort Food', 'Homemade'],
//         imagePaths: [
//           'lib/presentation/images/divino_pecado_1.jpeg',
//           'lib/presentation/images/divino_pecado_3.jpg',
//           'lib/presentation/images/divino_pecado_2.jpg',
//           'lib/presentation/images/divino_pecado_1.jpeg',
//           'lib/presentation/images/divino_pecado_3.jpg',
//         ],
//         reviews: [
//           Review(
//             user: 'Carol Williams',
//             title: 'Exceptional Desserts',
//             content: 'Their desserts are out of this world! The perfect ending to our meal.',
//             date: '20-01-2024', //  DateTime(2024, 1, 25),
//             imageUrl: null, // 'lib/presentation/images/divino_pecado_2.jpeg',
//             ratings: {
//               RatingsKeys.cleanliness: 5,
//               RatingsKeys.waitingTime: 5,
//               RatingsKeys.service: 5,
//               RatingsKeys.foodQuality: 5,
//             },
//             selectedCategories: ['italian'],
//           ),
//         ],
//         cleanliness_avg: 81,
//         waiting_time_avg: 89,
//         service_avg: 92,
//         food_quality_avg: 94,
//         latitude: 37.7749,
//         longitude: -122.4194,
//         bookmarked: false,
//       ),
//   ];

//   List<Restaurant> fetchRestaurants() {
//     return _restaurants;
//   }
  
//   Future<void> toggleBookmark(String restaurantId) async {
//     // Encuentra el restaurante por ID y cambia su estado de `bookmarked`
//     final index = _restaurants.indexWhere((r) => r.id == restaurantId); // Asegúrate de que tu modelo de restaurante tenga un campo `id`
//     if (index != -1) {
//       final restaurant = _restaurants[index];
//       _restaurants[index] = Restaurant(
//         id: restaurant.id,
//         name: restaurant.name,
//         priceRange: restaurant.priceRange,
//         timeRange: restaurant.timeRange,
//         distance: restaurant.distance,
//         categories: restaurant.categories,
//         imagePaths: restaurant.imagePaths,
//         reviews: restaurant.reviews,
//         cleanliness_avg: restaurant.cleanliness_avg,
//         waiting_time_avg: restaurant.waiting_time_avg,
//         service_avg: restaurant.service_avg,
//         food_quality_avg: restaurant.food_quality_avg,
//         latitude: restaurant.latitude,
//         longitude: restaurant.longitude,
//         bookmarked: !restaurant.bookmarked,
//       );
//     }
//   }
// }
