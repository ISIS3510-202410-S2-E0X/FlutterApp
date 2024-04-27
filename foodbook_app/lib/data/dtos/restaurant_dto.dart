import 'package:foodbook_app/data/models/restaurant.dart';

class RestaurantDTO {
  final String id;
  final String name;
  final List<String> categories;
  final List<String> imageLinks;
  final List<double> location;
  final Map<String, dynamic> waitTime;
  final String price;
  final Map<String, num> stats;
  final List<String> userReviews;

  RestaurantDTO({
    required this.id,
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
      id: id,
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

  static RestaurantDTO fromJson(String restaurantId, Map<String, dynamic> json) {
    
    var categoriesJson = json['categories'] as List;
    var categories = categoriesJson.map((item) => {
      'name': item['name'] as String,
      'count': item['count'] as int // Ensure 'count' is treated as an integer
    }).toList();

    // Sort the categories by count in descending order
    categories.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int)); // Cast to int explicitly here

    // Format the categories into 'name(count)' format and keep it as a list
    var formattedCategories = categories.map((item) => '${item['name']}.(${item['count']})').toList();

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
        id: restaurantId,
        name: json['name'] as String? ?? 'Unknown',
        categories: formattedCategories,
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
      'id': id,
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
      id: restaurant.id,
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
      userReviews: [], // We dont save user reviews in cache due to memory constraints
    );
  }

  // Create a RestaurantDTO from a Restaurant in cache.
  static RestaurantDTO fromCache(Map<String, dynamic> json) {
    return RestaurantDTO(
      id: json['id'] as String? ?? 'Unknown',
      name: json['name'] as String? ?? 'Unknown',
      categories: List<String>.from(json['categories'] ?? []),
      imageLinks: List<String>.from(json['imageLinks'] ?? []),
      location: List<double>.from(json['location'] ?? []),
      waitTime: Map<String, dynamic>.from(json['waitTime'] ?? {}),
      price: json['price'] as String? ?? '-',
      stats: Map<String, num>.from(json['stats'] ?? {}).map((key, value) => MapEntry(key, value / 20)),
      userReviews: List<String>.from(json['userReviews'] ?? []),
    );
  }
}
