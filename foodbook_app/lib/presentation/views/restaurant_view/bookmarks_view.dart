import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_state.dart';
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
import 'package:connectivity_plus/connectivity_plus.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  _BookmarksViewState createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  // Create a StreamSubscription object to listen to the connectivity stream
  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get _connectivityStream => _connectivity.onConnectivityChanged;
  
  @override
  void initState() {
    super.initState();
    checkConnection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkViewBloc>().add(LoadBookmarkedRestaurants());
    });
  }

  Future<void> checkConnection() async {
    // Get the current connectivity status
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult[0] == ConnectivityResult.none) {
      context.read<BookmarkInternetViewBloc>().add(BookmarksAccessNoInternet());
    } else {
      context.read<BookmarkInternetViewBloc>().add(BookmarksAccessInternet());
    }
  }

  
@override
Widget build(BuildContext context) {
  return BlocProvider<BookmarkBloc>(
    create: (context) => BookmarkBloc(
      BookmarkManager(),
    ),
    child: StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream.asyncExpand((results) => Stream.fromIterable(results)),
      builder: (context, snapshot) {
        return PopScope(
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
            body: BlocBuilder<BookmarkInternetViewBloc, BookmarkInternetViewState>(
              builder: (context, connectivityState) {
                bool isOffline = (snapshot.connectionState == ConnectionState.waiting && connectivityState is BookmarksNoInternet) || snapshot.data == ConnectivityResult.none || snapshot.connectionState == ConnectionState.none;
                return Column(
                  children: [
                    if (isOffline)
                      const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.signal_wifi_off, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Offline', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    Expanded(
                      child: BlocBuilder<BookmarkViewBloc, BookmarkViewState>(
                        builder: (context, state) {
                          if (state is BookmarksLoadInProgress) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is BookmarkLoadCompletelyFailed) {
                            return const Center(
                              child: Text(
                                "Hmm, you've saved bookmarks but there's nothing here. Please verify you are connected to the internet.",
                                textAlign: TextAlign.center,
                              ),
                            );
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
                                        builder: (context) => SpotDetail(restaurantId: restaurant.id),
                                      ),
                                    );
                                  },
                                  child: RestaurantCard(restaurant: restaurant),
                                );
                              },
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: 2,
              onItemTapped: (int index) {
                // Implement navigation logic here
              },
            ),
          ),
        );
      },
    ),
  );
}

