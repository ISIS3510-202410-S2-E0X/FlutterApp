import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryDAO {
  static const _maxHistoryLength = 5;

  Future<void> saveSearchTerm(String term) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('searchHistory') ?? [];
    history.insert(0, term);
    // Ensure only the last 5 terms are saved
    if (history.length > _maxHistoryLength) {
      history.removeLast();
    }
    await prefs.setStringList('searchHistory', history);
  }

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('searchHistory') ?? [];
  }
}
