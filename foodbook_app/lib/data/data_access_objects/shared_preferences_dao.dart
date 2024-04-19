import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryDAO {

  Future<void> saveSearchTerm( List<String> history) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', history);
  }

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('searchHistory') ?? [];
  }
}
