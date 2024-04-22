import 'package:foodbook_app/data/models/restaurant.dart';

class RestaurantDTO {
  final String name;
  final List<String> categories;
  final List<String> imageLinks;
  final List<double> location;
  final Map<String, dynamic> waitTime;
  final String price;
  final Map<String, num> stats;
  final List<String> userReviews;

  RestaurantDTO({
    required this.name,
    required this.categories,
    required this.imageLinks,
    required this.location,
    required this.waitTime,
    required this.price,
    required this.stats,
    required this.userReviews,
  });

  Restaurant toModel() {
    return Restaurant(
      name: name,
      categories: categories,
      imagePaths: imageLinks,
      latitude: location[0],
      longitude: location[1],
      // reviews: userReviews.map((review) => ReviewDTO.fromJson(review).toModel()).toList(),
      reviews: [],
      cleanliness_avg: (stats['cleanliness']! * 20).toInt(),
      waiting_time_avg: (stats['waitTime']! * 20).toInt(),
      service_avg: (stats['service']! * 20).toInt(),
      food_quality_avg: (stats['foodQuality']! * 20).toInt(),
      waitTimeMin: waitTime['min'],
      waitTimeMax: waitTime['max'],
      priceRange: price,
    );
  }

  static RestaurantDTO fromJson(Map<String, dynamic> json) {
    
    // Assuming 'json' is your JSON object that contains the categories list.
    var categories = (json['categories'] as List).map((item) => item['name'] as String).toList();
    var imageLinks = List<String>.from(json['imageLinks'] ?? []);
    var location = List<double>.from(json['location-arr'] ?? []);

    var waitTime = Map<String, dynamic>.from(json['waitTime'] ?? {});

    var reviewData = json['reviewData'] as Map<String, dynamic>? ?? {};
    var stats = Map<String, num>.from(reviewData['stats'] as Map<String, dynamic>? ?? {});

    
    // Para userReviews, extraemos las referencias como List<String>
    // Asumiendo que son referencias de Firestore en formato de String
    //var userReviews = List<String>.from((reviewData['userReviews'] as List<dynamic>? ?? [])
    //    .map((review) => review.toString()));

    return RestaurantDTO(
        name: json['name'] as String? ?? 'Unknown',
        categories: categories,
        imageLinks: imageLinks,
        location: location,
        waitTime: waitTime,
        price: json['price'] as String? ?? '-',
        stats: stats,
        userReviews: [],
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categories': categories,
      'imageLinks': imageLinks,
      'location': location,
      'waitTime': waitTime,
      'price': price,
      'stats': stats,
      'userReviews': userReviews,
    };
  }
  
  // Create a RestaurantDTO from a Restaurant model.
  static RestaurantDTO fromModel(Restaurant restaurant) {
    return RestaurantDTO(
      name: restaurant.name,
      categories: restaurant.categories,
      imageLinks: restaurant.imagePaths,
      location: [restaurant.latitude, restaurant.longitude],
      waitTime: {'min': restaurant.waitTimeMin, 'max': restaurant.waitTimeMax},
      price: restaurant.priceRange,
      stats: {
        'cleanliness': restaurant.cleanliness_avg,
        'waitTime': restaurant.waiting_time_avg,
        'service': restaurant.service_avg,
        'foodQuality': restaurant.food_quality_avg,
      },
      userReviews: [], // You'll need to handle the conversion from reviews to the DTO format if needed.
    );
  }
}
