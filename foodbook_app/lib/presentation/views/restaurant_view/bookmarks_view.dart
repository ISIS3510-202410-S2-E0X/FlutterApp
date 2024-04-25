import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_state.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_event.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';
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
                  return const Center(child: Text('No bookmarked restaurants.'));
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
                                  builder: (context) => SpotDetail(restaurantId: state.bookmarkedRestaurants[index].id),
                                ),
                              );
                            },
                      child: RestaurantCard(restaurant: restaurant),
                    );
                  },
                );
              } else if (state is BookmarksLoadFailure) {
                //The message changes if there is 1 or more than 1 restaurant that couldn't be loaded
                final failureMessage = state.failedToLoadNames.length == 1
                    ? "The bookmarked restaurant: ${state.failedToLoadNames.first} is not in cache and couldn't be accessed through network. Try again with an internet connection."
                    : "The bookmarked restaurants: ${state.failedToLoadNames.join(', ')} are not in cache and couldn't be accessed through network. Try again with an internet connection.";
                return Column(
                  children: [
                    if (state.successfullyLoaded.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.successfullyLoaded.length,
                          itemBuilder: (context, index) {
                            final restaurant = state.successfullyLoaded[index];
                              return GestureDetector(
                                onTap: ()async {
                                  final restaurantId = restaurant.id;

                                  // Use a RestaurantBloc event to fetch the restaurant details
                                  context.read<SpotDetailBloc>().add(FetchRestaurantDetail(restaurantId));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider<ReviewDraftBloc>(
                                            create: (context) => ReviewDraftBloc(
                                              RepositoryProvider.of<ReviewDraftRepository>(context)
                                            ),
                                          ),
                                        ],
                                        child: SpotDetail(restaurantId: restaurantId),
                                      ),
                                    ),
                                  );
                                },
                                child: RestaurantCard(restaurant: restaurant),
                              );
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(failureMessage, textAlign: TextAlign.center),
                    ),
                  ],
                );
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


