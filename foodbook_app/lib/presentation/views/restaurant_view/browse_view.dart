import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/widgets/menu/navigation_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/filter_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/search_bar.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';


class BrowseView extends StatelessWidget {
  BrowseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookmarkBloc>(
      create: (context) => BookmarkBloc(
        BookmarkManager(), 
      ),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: const Text(
              'Browse',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: const [
              // FilterBar(),
            ],
            elevation: 0,
          ),
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              RestaurantSearchBar(browseBloc: BlocProvider.of<BrowseBloc>(context)),
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              Expanded(
                child: BlocBuilder<BrowseBloc, BrowseState>(
                  builder: (context, state) {
                    if (state is RestaurantsLoadInProgress) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RestaurantsLoadSuccess) {
                      return ListView.builder(
                        itemCount: state.restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = state.restaurants[index];
                          return GestureDetector(
                            onTap: () {
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
                      return const Center(child: Text('Failed to load restaurants'));
                    }
                    return const Center(child: Text('Start browsing by applying some filters!'));
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomNavigationBar(
            selectedIndex: 0,
            onItemTapped: (index) {
              // Implement your navigation logic here
            },
          ),
        ),
      ),
    );
  }
}


