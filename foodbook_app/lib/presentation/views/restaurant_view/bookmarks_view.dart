import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/widgets/menu/navigation_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/filter_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/search_bar.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';



class BookmarksView extends StatelessWidget {
  BookmarksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white, // Set AppBar background to white
            title: const Text(
              'Bookmarks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black, // Title color
              ),
            ),
            actions: [
              //FilterBar(),
            ],
            elevation: 0, // Remove shadow
          ),
          backgroundColor: Colors.grey[200], // Set the background color to grey
          body: Column(
            children: [
              RestaurantSearchBar(browseBloc: BlocProvider.of<BrowseBloc>(context)),
              Divider(
                height: 1, // Height of the divider line
                color: Colors.grey[300], // Color of the divider line
              ),
              Expanded(
                child: BlocBuilder<BrowseBloc, BrowseState>(
                  builder: (context, state) {
                    if (state is RestaurantsLoadInProgress) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is RestaurantsLoadSuccess) {
                      return ListView.builder(
                        itemCount: state.restaurants.where((restaurant) => restaurant.bookmarked).length,
                        itemBuilder: (context, index) {
                          final bookmarkedRestaurants = state.restaurants.where((restaurant) => restaurant.bookmarked).toList();
                          final restaurant = bookmarkedRestaurants[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to another view when the restaurant card is clicked
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpotDetail(restaurant: restaurant),
                                ),
                              );
                            },
                            child: RestaurantCard(restaurant: restaurant),
                          );
                        },
                      );
                    } else if (state is RestaurantsLoadFailure) {
                      return Center(child: Text('Failed to load restaurants'));
                    }
                    
                    return Center(child: Text('Start browsing by applying some filters!'));
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomNavigationBar(
            selectedIndex: 2, // Set the selected index to 1
            onItemTapped: (int index) {
              // Handle navigation to different views
              if (index == 0) {
                Navigator.pushNamed(context, '/browse');
              } else if (index == 1) {
                Navigator.pushNamed(context, '/for_you');
              }
            },
          ),
        )
    );
  }
}


