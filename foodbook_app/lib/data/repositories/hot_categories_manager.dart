import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HotCategoriesManager {
  late final String _hotcategoriesKey;
  SharedPreferences? _prefs;

  // Constructor that initializes the bookmarks key with the user's email
  BookmarkManager() {
      _hotcategoriesKey = 'hotCategories';
  }

  

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<String>?> fetchAndSaveCategories() async {
    final response = await http.get(Uri.parse('https://foodbook-app-backend.vercel.app/hottest_categories'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<dynamic> categories = jsonResponse['categories'];
      List<String> categoryNames = categories.map((category) => category['name'].toString()).toList();
      
      if (categoryNames.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_hotcategoriesKey, categoryNames);
        return categoryNames;
      }
    }
    return null;
  }

  Future<List<String>?> getSavedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? categoryNames = prefs.getStringList(_hotcategoriesKey);
    return categoryNames;
  }

}

