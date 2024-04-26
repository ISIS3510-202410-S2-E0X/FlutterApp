import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodbook_app/data/dtos/restaurant_dto.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  late final String _bookmarksKey;
  SharedPreferences? _prefs;

  // Constructor that initializes the bookmarks key with the user's email
  BookmarkManager() {
    // Assuming the user is already logged in at this point
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      String sanitizedEmail = sanitizeEmail(user.email!);
      _bookmarksKey = 'bookmarks_$sanitizedEmail';
    } else {
      throw Exception('User is not logged in or email is null.');
    }
  }

  String sanitizeEmail(String email) {
    // More robust sanitization can be added here as needed
    return email.replaceAll('.', '_').replaceAll('@', '_');
  }

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
    // Serialize and store the restaurant details, it checks if the restaurant is already in prefs
    if (await getRestaurantDetails(restaurant.id) == null) 
      await prefs.setString(restaurant.id, serializeRestaurant(restaurant));
  }

  Future<void> unbookmarkRestaurant(String restaurantId) async {
    final prefs = await _getPrefs();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove(restaurantId);
    await prefs.setStringList(_bookmarksKey, bookmarks);
    // Remove the restaurant details from the cache, it checks if the restaurant is already in prefs
    if (await getRestaurantDetails(restaurantId) != null)
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

  Future<void> toggleBookmarkUsage() async {
    try {

      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        //Eliminates the @gmail.com
        throw Exception('User is not logged in or email is null.');
      }
      else {
        final correo = user.email!.replaceAll('@gmail.com', '');
        //Checks if user has bookmarks in prefs with getBookmarkedRestaurants
        List<String> bookmarks = await getBookmarkedRestaurants();

        // If user has bookmarks, it will add the user's email if it is not already in the collection bookmarksUsage
        // It adds the email as id of the collection and a variable called 'userId' with the user's email
        // It also adds a boolean variable called 'usage' with the value true even if it is already in the collection
        if (bookmarks.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('bookmarksUsage').doc(correo).get();
          if (!userSnapshot.exists) {
            await FirebaseFirestore.instance.collection('bookmarksUsage').doc(correo).set({
              'userId': correo,
              'usage': true
            });
          }
          else {
            await FirebaseFirestore.instance.collection('bookmarksUsage').doc(correo).update({
              'usage': true
            });
          }
        }
        // If user has no bookmarks, it will add the user's email if it is not already in the collection bookmarksUsage
        // It adds the email as id of the collection and a variable called 'userId' with the user's email
        // It also adds a boolean variable called 'usage' with the value false even if it is already in the collection
        else {
          DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('bookmarksUsage').doc(user.email).get();
          if (!userSnapshot.exists) {
            await FirebaseFirestore.instance.collection('bookmarksUsage').doc(correo).set({
              'userId': correo,
              'usage': false
            });
          }
          else {
            await FirebaseFirestore.instance.collection('bookmarksUsage').doc(correo).update({
              'usage': false
            });
          }
        } 
      }
    } catch (e) {
      print('Failed to toggle bookmark usage with error: $e');
      rethrow;
    }
  }

}

