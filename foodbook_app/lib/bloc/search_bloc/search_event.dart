abstract class SearchEvent{}

class SearchWord extends SearchEvent{
  final String query;
  SearchWord({required this.query});
}