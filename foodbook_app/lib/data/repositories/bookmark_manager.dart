import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static const String _bookmarksKey = 'bookmarks';

  Future<void> bookmarkRestaurant(String restaurantName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    if (!bookmarks.contains(restaurantName)) {
      bookmarks.add(restaurantName);
      await prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  Future<void> unbookmarkRestaurant(String restaurantName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList(_bookmarksKey) ?? [];
    bookmarks.remove(restaurantName);
    await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  Future<List<String>> getBookmarkedRestaurants() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarksKey) ?? [];
  }

  Future<bool> isBookmarked(String restaurantName) async {
    final List<String> bookmarks = await getBookmarkedRestaurants();
    bool isBookmarked = bookmarks.contains(restaurantName);
    return isBookmarked;
  }
}
