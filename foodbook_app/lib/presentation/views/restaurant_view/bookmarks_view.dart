import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_state.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/widgets/menu/navigation_bar.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  _BookmarksViewState createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkViewBloc>().add(LoadBookmarkedRestaurants());
    });
  }

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
              'Bookmarks',
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
          body: BlocBuilder<BookmarkViewBloc, BookmarkViewState>(
            builder: (context, state) {
              if (state is BookmarksLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BookmarkedRestaurantsLoaded) {
                if (state.bookmarkedRestaurants.isEmpty) {
                  return const Center(child: Text('No bookmarks found in cache.'));
                }
                return ListView.builder(
                  itemCount: state.bookmarkedRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = state.bookmarkedRestaurants[index];
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
              } else if (state is BookmarksLoadFailure) {
                return Center(child: Text('Failed to load restaurants'));
              }
              // If state is BookmarkViewInitial or any other unhandled state, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            },
          ),
          bottomNavigationBar: CustomNavigationBar(
            selectedIndex: 2,
            onItemTapped: (int index) {
              // Implement navigation logic here
            },
          ),
        )
      )
    );
  }
}


