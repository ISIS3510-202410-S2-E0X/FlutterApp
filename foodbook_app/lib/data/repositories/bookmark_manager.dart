import 'dart:convert';

import 'package:foodbook_app/data/dtos/restaurant_dto.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _bookmarksKey = 'bookmarks';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> bookmarkRestaurant(Restaurant restaurant) async {
    final prefs = await _getPrefs();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    if (!bookmarks.contains(restaurant.id)) {
      bookmarks.add(restaurant.id);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
    // Serialize and store the restaurant details
    await prefs.setString(restaurant.id, serializeRestaurant(restaurant));
  }

  Future<void> unbookmarkRestaurant(String restaurantId) async {
    final prefs = await _getPrefs();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove(restaurantId);
    await prefs.setStringList(_bookmarksKey, bookmarks);
    // Remove the restaurant details from the cache
    await prefs.remove(restaurantId);
  }

  Future<bool> isBookmarked(String restaurantId) async {
    final prefs = await _getPrefs();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    return bookmarks.contains(restaurantId);
  }

  String serializeRestaurant(Restaurant restaurant) {
    final restaurantDTO = RestaurantDTO.fromModel(restaurant);
    return json.encode(restaurantDTO.toJson());
  }

  // Helper method to deserialize a JSON string to a Restaurant object
  Future<Restaurant?> getRestaurantDetails(String restaurantId) async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(restaurantId);
    if (jsonString != null) {
      final restaurantDTO = RestaurantDTO.fromCache(json.decode(jsonString));
      return restaurantDTO.toModel();
    }
    return null;
  }

  Future<List<String>> getBookmarkedRestaurants() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

}

