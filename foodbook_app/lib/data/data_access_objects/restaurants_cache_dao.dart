import 'dart:convert';

import 'package:foodbook_app/data/dtos/restaurant_dto.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantsCacheDAO {
  static const String _cachedKey = 'cachedRestaurants';
  static const String _cachedFyp = 'cachedFypRestaurants';

  Future<void> cacheRestaurant( Restaurant restaurant) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cache = prefs.getStringList(_cachedKey) ?? [];
    if (!cache.contains(restaurant.name)) {
      cache.add(restaurant.name);
      await prefs.setStringList(_cachedKey, cache);
    }
    await prefs.setString(restaurant.name, serializeRestaurant(restaurant));
  }
  Future<List<String>> getCachedRestaurant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('browseCache') ?? [];
  }

  Future<void> deleteBrowseCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('browseCache');
  }
  Future<Restaurant?> findRestaurantByName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(name);
    if (jsonString != null) {
      final restaurantDTO = RestaurantDTO.fromCache(json.decode(jsonString));
      return restaurantDTO.toModel();
    }
    return null;
  }
  String serializeRestaurant(Restaurant restaurant) {
    final restaurantDTO = RestaurantDTO.fromModel(restaurant);
    return json.encode(restaurantDTO.toJson());
  }
  Future<List<String>> getCachedRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_cachedKey) ?? [];
  }

  Future<void> cacheRestaurantFYP( Restaurant restaurant) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cache = prefs.getStringList(_cachedFyp) ?? [];
    if (!cache.contains(restaurant.name)) {
      cache.add(restaurant.name);
      await prefs.setStringList(_cachedFyp, cache);
    }
    await prefs.setString(restaurant.name, serializeRestaurant(restaurant));
  }
  Future<List<String>> getCachedRestaurantFYP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_cachedFyp) ?? [];
  }
}