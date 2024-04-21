import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/bloc/search_bloc/search_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_event.dart';
import 'package:foodbook_app/bloc/search_bloc/search_state.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/data/repositories/shared_preferences_repository.dart';
import 'package:foodbook_app/presentation/views/restaurant_view/browse_view.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';
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
        backgroundColor: Colors.white,
        actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6, // 40% of screen width
              child: ElevatedButton(
              onPressed: () {
              // Dispatch an event to fetch search history when the search button is pressed
              browseBloc.add(SearchButtonPressed2(query: ''));
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(browseBloc: browseBloc),
              );
              },
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Adjust the value as needed
              ), backgroundColor: Colors.grey[200], // Set the button color to light grey
              ),
              child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search, color: Colors.grey), // Set the icon color to light grey
                SizedBox(width: 10), // Adjust spacing between icon and text
                Text("Search", style: TextStyle(color:  Colors.grey)), // Set the text color to light grey
              ],
              ),
              ),
            )
        ]
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
          browseBloc.add(FilterRestaurants(name: query));
          return const Center(child: CircularProgressIndicator());
          // return BlocProvider<BrowseBloc>(
          //       create: (context) => BrowseBloc(restaurantRepository: RestaurantRepository(), reviewRepository: ReviewRepository())..add(FilterRestaurants(name: query)),
          //       child: BrowseView(),
          //     );
        } 
        if (state is RestaurantsLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RestaurantsLoadSuccess) {
            return ListView.builder(
              itemCount: state.restaurants.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                  // Navigate to another view when the restaurant card is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpotDetail(restaurant: state.restaurants[index]),
                      ),
                    );
                  },
                  child: RestaurantCard(restaurant: state.restaurants[index]),
                );
              }
            );
          } else if (state is RestaurantsLoadFailure) {
              return Center(child: Text("No results found for: $query"));
            }
        else {
          return Center(child: Text("No results found for: $query"));
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


// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Colors.white,
//       title: const Text('Search Page'),
//     ),
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // Trigger your search functionality here
//               // For example, dispatch an event if using bloc
//               // browseBloc.add(SearchButtonPressed2(query: ''));
//               showSearch(
//                 context: context,
//                 delegate: CustomSearchDelegate(), // Custom search delegate
//               );
//             },
//           ),
//           const SizedBox(height: 20), // Adjust as needed
//           const Text('Search Content Goes Here'),
//         ],
//       ),
//     ),
//   );
// }
