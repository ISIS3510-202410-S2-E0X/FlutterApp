import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_event.dart';
import 'package:foodbook_app/bloc/search_bloc/search_state.dart';
import 'package:foodbook_app/data/repositories/shared_preferences_repository.dart';
// SearchPage2 Widget
class SearchPage2 extends StatefulWidget {
  const SearchPage2({Key? key});

  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Dispatch an event to fetch search history when the search button is pressed
              searchBloc.add(SearchButtonPressed(query: ''));
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(searchBloc: searchBloc),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Search Content Goes Here'),
      ),
    );
  }
}

// CustomSearchDelegate Widget
class CustomSearchDelegate extends SearchDelegate<String> {
  final SearchBloc searchBloc;
  final SharedPreferencesRepository repository = SharedPreferencesRepository();

  CustomSearchDelegate({required this.searchBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(searchBloc: searchBloc),
          );
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          searchBloc.add(SearchWord(query: query));
          return Center(
       child: Text('Search Results for: $query'),  );
        } else {
          return Center(
       child: Text('Search Results for: $query'),  
          );
        }
      },
    );
  }

  // @override
  // Widget buildResults(BuildContext context) {
  //   return Center(
  //     child: Text('Search Results for: $query'),
  //   );
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return FutureBuilder<List<String>>(
            future: repository.getSearchHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final suggestions = snapshot.data!;
                return ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        query = suggestion; // Set the suggestion as the initial query
                        showResults(context); // Show the search results immediately
                      },
                    );
                  },
                );
              }
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
