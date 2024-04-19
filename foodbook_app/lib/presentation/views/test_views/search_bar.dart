import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_event.dart';
import 'package:foodbook_app/bloc/search_bloc/search_state.dart';
import 'package:foodbook_app/data/data_access_objects/shared_preferences_dao.dart';
import 'package:foodbook_app/data/repositories/shared_preferences_repository.dart';
import 'package:foodbook_app/data/repositories/shared_preferences_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchBloc searchBloc = BlocProvider.of<SearchBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
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
    return Center(
      child: Text('Search Results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: repository.getSearchHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<String> suggestions = snapshot.data ?? [];
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
  }
}
