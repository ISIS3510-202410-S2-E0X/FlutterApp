import 'package:foodbook_app/data/dtos/review_dto.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class RestaurantDTO {
  final String id;
  final String name;
  final List<String> categories;
  final List<String> imageLinks;
  final Map<String, dynamic> location;
  final Map<String, dynamic> reviewMeta;
  final double price;
  final List<Map<String, dynamic>> userReviews;
  final Map<String, dynamic> waitTime;

  RestaurantDTO({
    required this.id,
    required this.name,
    required this.categories,
    required this.imageLinks,
    required this.location,
    required this.reviewMeta,
    required this.price,
    required this.userReviews,
    required this.waitTime
  });

  factory RestaurantDTO.fromModel(Restaurant restaurant) {
    return RestaurantDTO(
      id: restaurant.id,
      name: restaurant.name,
      categories: restaurant.categories,
      imageLinks: restaurant.imagePaths,
      location: {
        'latitude': restaurant.latitude,
        'longitude': restaurant.longitude,
      },
      reviewMeta: {
        'cleanliness': restaurant.cleanliness_avg,
        'waitingTime': restaurant.waiting_time_avg,
        'service': restaurant.service_avg,
        'foodQuality': restaurant.food_quality_avg,
      },
      price: double.tryParse(restaurant.priceRange.replaceAll(r'$', '')) ?? 0,
      userReviews: restaurant.reviews.map((review) => ReviewDTO.fromModel(review).toJson()).toList(),
      waitTime: {
        'min': restaurant.waitTimeMin,
        'max': restaurant.waitTimeMax
      }
    );
  }

  Restaurant toModel() {
    return Restaurant(
      id: id,
      name: name,
      priceRange: '\$' * price.toInt(),
      categories: categories,
      imagePaths: imageLinks,
      reviews: userReviews.map((review) => ReviewDTO.fromJson(review).toModel()).toList(),
      cleanliness_avg: reviewMeta['cleanliness'],
      waiting_time_avg: reviewMeta['waitingTime'],
      service_avg: reviewMeta['service'],
      food_quality_avg: reviewMeta['foodQuality'],
      latitude: location['latitude'],
      longitude: location['longitude'],
      waitTimeMin: waitTime['min'],
      waitTimeMax: waitTime['max'],
      bookmarked: false, // This field is not present in the JSON, adjust as necessary.
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categories': categories,
      'imageLinks': imageLinks,
      'location': {
        'latitude': location['latitude'],
        'longitude': location['longitude'],
      },
      'reviewMeta': {
        'cleanliness': reviewMeta['cleanliness'],
        'waitingTime': reviewMeta['waitingTime'],
        'service': reviewMeta['service'],
        'foodQuality': reviewMeta['foodQuality'],
      },
      'price': price,
      'userReviews': userReviews,
      'waitTime': {
        'min': waitTime['min'],
        'max': waitTime['max']}
    };
  }

  static RestaurantDTO fromJson(Map<String, dynamic> json) {
    var categoriesJson = json['categories'] as List<dynamic>;
    var imageLinksJson = json['imageLinks'] as List<dynamic>;
    var userReviewsJson = json['userReviews'] as List<dynamic>;
    return RestaurantDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      categories: categoriesJson.cast<String>(),
      imageLinks: imageLinksJson.cast<String>(),
      location: Map<String, dynamic>.from(json['location']),
      reviewMeta: Map<String, dynamic>.from(json['reviewMeta']),
      price: json['price'] as double,
      userReviews: userReviewsJson.cast<Map<String, dynamic>>(),
      waitTime: Map<String, dynamic>.from(json['waitTime'])
    );
  }
}
