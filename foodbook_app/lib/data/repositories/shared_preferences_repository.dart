import 'package:foodbook_app/data/data_access_objects/shared_preferences_dao.dart';
import 'package:foodbook_app/data/data_sources/service_adapter_searchwords.dart';

class SharedPreferencesRepository {
  final SearchHistoryDAO _searchHistoryDAO = SearchHistoryDAO();
  final ServiceAdapterSearchWords _saSearchWords = ServiceAdapterSearchWords();

  Future<void> saveSearchTerm(String term) async {
    if (term.isNotEmpty) {
      List<String> searchHistory = await _searchHistoryDAO.getSearchHistory();
      if (searchHistory.length == 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, term);
      await _searchHistoryDAO.saveSearchTerm(searchHistory);
      _saSearchWords.postDataToFirestore(term);
    }
  }

  Future<List<String>> getSearchHistory() async {
    return await _searchHistoryDAO.getSearchHistory();
  }

  // Add a method to fetch suggestions
  Future<List<String>> getSuggestions() async {
    // Call a method from DAO or perform any other logic to fetch suggestions
    return ["corral", "wok", "divino", "Merci", "gratto"];
  }
}
