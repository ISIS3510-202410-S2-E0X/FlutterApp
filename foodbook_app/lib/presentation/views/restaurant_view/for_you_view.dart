import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_state.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/widgets/menu/navigation_bar.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';

class ForYouView extends StatefulWidget {
  ForYouView({super.key});
  
  @override
  State<ForYouView> createState() => _ForYouViewState();
}

class _ForYouViewState extends State<ForYouView> {
  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get _connectivityStream => _connectivity.onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    checkConnection();
    // Solicita el usuario actual tan pronto como el widget se inicialice.
    BlocProvider.of<UserBloc>(context, listen: false).add(GetCurrentUser());
    
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
          bool isOffline = snapshot.data == ConnectivityResult.none || snapshot.connectionState == ConnectionState.none;

          return PopScope(
            canPop: false,
            child: MultiBlocListener(
              listeners: [
                BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is AuthenticatedUserState) {
                      BlocProvider.of<BrowseBloc>(context).add(FetchRecommendedRestaurants(state.email.replaceFirst("@gmail.com", "")));
                    }
                  },
                ),
              ],
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: const Text(
                    'For You',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  elevation: 10,
                ),
                backgroundColor: Colors.grey[200],
                body:
                        BlocBuilder<BookmarkInternetViewBloc, BookmarkInternetViewState>(
                          builder: (context, connectivityState) {
                            return Column(
                              children: [
                                if (isOffline || connectivityState is BookmarksNoInternet && snapshot.connectionState == ConnectionState.waiting )
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
                                Divider(
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                                Expanded(
                                  child: BlocBuilder<BrowseBloc, BrowseState>(
                                    builder: (context, state) {
                                      if (state is RestaurantsLoadInProgress) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (state is RestaurantsRecommendationLoadSuccess) {
                                        if (state.recommendedRestaurants.isEmpty) {
                                          return const Center(child: Text('No restaurants to show'));
                                        }
                                        return ListView.builder(
                                          itemCount: state.recommendedRestaurants.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
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
                                                      child: SpotDetail(restaurantId: state.recommendedRestaurants[index].id),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: RestaurantCard(restaurant: state.recommendedRestaurants[index]),
                                            );
                                          },
                                        );
                                      } else if (state is RestaurantsLoadFailure) {
                                        return const Center(
                                          child: Text(
                                            "hmm something went wrong, please verify you’re connected to the internet",
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                      return const Center(child: Text('No restaurants to show'));
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        bottomNavigationBar: CustomNavigationBar(
                          selectedIndex: 1,
                          onItemTapped: (int index) {
                            if (index == 0) {
                              Navigator.pushNamed(context, '/browse');
                            } else if (index == 2) {
                              Navigator.pushNamed(context, '/bookmarks');
                            }
                          },
                        ),
                      ),
                    ),
                  );
        },
      ),
    );
  }
}
