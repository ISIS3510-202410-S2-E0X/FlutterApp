import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/bloc/search_bloc/search_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_event.dart';
import 'package:foodbook_app/bloc/search_bloc/search_state.dart';
import 'package:foodbook_app/data/repositories/shared_preferences_repository.dart';
// SearchPage2 Widget
class SearchPage2 extends StatefulWidget {
  final BrowseBloc browseBloc;
  const SearchPage2({Key? key, required this.browseBloc}) : super(key: key);

  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  late BrowseBloc browseBloc;

  @override
  void initState() {
    super.initState();
    browseBloc = BlocProvider.of<BrowseBloc>(context, listen: false);
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
              browseBloc.add(SearchButtonPressed2(query: ''));
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(browseBloc: browseBloc),
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
  final BrowseBloc browseBloc;
  final SharedPreferencesRepository repository = SharedPreferencesRepository();

  CustomSearchDelegate({required this.browseBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(browseBloc: browseBloc),
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
    return BlocBuilder<BrowseBloc, BrowseState>(
      bloc: browseBloc,
      builder: (context, state) {
        if (state is SearchLoading2) {
          print("Saving the query to search history: $query");
          browseBloc.add(SearchWord2(query: query));
          return const Center(child: CircularProgressIndicator());
        } 
        else if (state is Prefilter){
          return Center(
       child: Text('Search Results for: $query'),  );
        }
        else {
          return const Center(child: CircularProgressIndicator());
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
    return BlocBuilder<BrowseBloc, BrowseState>(
      bloc: browseBloc,
      builder: (context, state) {
        if (state is SearchLoading2) {
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
