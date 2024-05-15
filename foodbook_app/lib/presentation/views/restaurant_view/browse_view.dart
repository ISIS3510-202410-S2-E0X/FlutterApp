import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_event.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_state.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_event.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_event.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_state.dart';
import 'package:foodbook_app/bloc/search_bloc/search_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart';
import 'package:foodbook_app/data/dtos/review_dto.dart';
import 'package:foodbook_app/data/models/review.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';
import 'package:foodbook_app/notifications/background_task.dart';
import 'package:foodbook_app/presentation/views/profile_view/profile_view.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_detail_view.dart';
import 'package:foodbook_app/presentation/views/test_views/search_test.dart';
import 'package:foodbook_app/presentation/widgets/menu/navigation_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/filter_bar.dart';
import 'package:foodbook_app/presentation/widgets/menu/search_bar.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/restaurant_card.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BrowseView extends StatefulWidget {
  BrowseView({Key? key}) : super(key: key);

  @override
  State<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  int _times = 0;
  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get _connectivityStream => _connectivity.onConnectivityChanged;
  
  @override
  void initState() {
    super.initState();
    checkConnection();
    loadTimesFromPrefs();
    _checkConnectionPostReviews();
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
  void loadTimesFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _times = prefs.getInt('times') ?? 0;
    });
  }

  void saveTimesToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('times', _times);
  }

  List<Review> _getReviewsToUpload(BuildContext context) {
    final reviewDraftBloc = BlocProvider.of<ReviewDraftBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);
    final userState = userBloc.state;

    context.read<UserBloc>().add(GetCurrentUser());

    String? userDisplayName;
    String? userEmail;
    List<Review> reviewsToUpload = [];
    if (userState is AuthenticatedUserState) {
      userDisplayName = userState.displayName;
      userEmail = userState.email;
    }
    reviewDraftBloc.add(LoadDraftsToUpload());
    if (reviewDraftBloc.state is ReviewToUploadLoaded) {
      final draftToUpload = (reviewDraftBloc.state as ReviewToUploadLoaded).drafts;
        for (var draft in draftToUpload) {
          Review review = Review(
            user: {'id': userEmail ?? '', 'name': userDisplayName ?? ''},
            title: draft.title,
            content: draft.content,
            date: Timestamp.fromDate(DateTime.now()),
            imageUrl: draft.image, // TODO: Implement image upload (save image to storage and get URL)
            ratings: draft.ratings,
            selectedCategories: (draft.selectedCategories).map((e) => e.name).toList(),
            spot: draft.spot
          );
          reviewsToUpload.add(review);
      }
    }

    return reviewsToUpload;
  }

  Future<void> _checkConnectionPostReviews() async {
    print('REVISANDO CONEXIÓN - BrowseView');
    var connectivityResult = await Connectivity().checkConnectivity();
    print(connectivityResult);
    if (connectivityResult[0] != ConnectivityResult.none) {
      print('HAY INTERNET!');
      List<Review> reviewsToUpload = _getReviewsToUpload(context);
      print('SIZE REVIEWS TO UPLOAD: ${reviewsToUpload.length}');
      if (reviewsToUpload.isNotEmpty && _times == 0) {
        print('ENTRO ACÁ $_times');
        for (var eachReview in reviewsToUpload) {
          BlocProvider.of<ReviewBloc>(context).add(CreateReviewEvent(ReviewDTO.fromModel(eachReview), eachReview.spot!));
          context.read<ReviewDraftBloc>().add(DeleteDraft(eachReview.spot!));
          print('POSTING TO-UPLOAD REVIEWS!');
        }
        context.read<ReviewDraftBloc>().add(DeleteDraftToUpload());
        context.read<ReviewDraftBloc>().add(LoadDraftsToUpload());
        _times = 1;
        saveTimesToPrefs();
        draftsLoadNotification();
      }
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
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white, // Set AppBar background to white
                title: Row(
                  children: [
                    const Text(
                      'Browse',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Title color
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.58, // Adjust the width as needed
                      height: kToolbarHeight, // Constrain the height of the SearchPage2 widget
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SearchPage2(browseBloc: BlocProvider.of<BrowseBloc>(context)),
                      ),
                    ),
                  ],
                ),
                elevation: 0, // Remove shadow
                actions: [
                  IconButton(
                    icon: const Icon(Icons.account_circle, color:  Color.fromARGB(255, 0, 140, 255)), // Profile icon
                    onPressed: () {
                      //Navigate to the profile view
                      context.read<UserBloc>().add(GetCurrentUser());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileView()),
                      );
                    },
                  ),
                ],
              ),
              backgroundColor: Colors.grey[200], // Set the background color to grey
              body: BlocBuilder<BookmarkInternetViewBloc, BookmarkInternetViewState>(
                builder: (context, connectivityState) {
                  return Column(
                    children: [
                      if (isOffline|| connectivityState is BookmarksNoInternet && snapshot.connectionState == ConnectionState.waiting)
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
                        height: 1, // Height of the divider line
                        color: Colors.grey[300], // Color of the divider line
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
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider.value(
                                            value: BlocProvider.of<ReviewDraftBloc>(context),
                                            child: SpotDetail(restaurantId: state.restaurants[index].id),
                                          ),
                                        ),
                                      );
                                    },
                                    child: RestaurantCard(restaurant: state.restaurants[index]),
                                  );
                                },
                              );
                            } else if (state is RestaurantsLoadFailure) {
                              return const Center(
                                child: Center(
                                  child: Text('hmm something went wrong, please verify you’re connected to the internet',
                                  textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            // If the initial state is RestaurantsInitial or any other unexpected state
                            return const Center(child: Text('Start browsing by applying some filters!'));
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),  
              bottomNavigationBar: CustomNavigationBar(
                selectedIndex: 0, // Set the selected index to 1
                onItemTapped: (int index) {
                  // Handle navigation to different views
                  if (index == 1) {
                    Navigator.pushNamed(context, 'package:foodbook_app/presentation/views/restaurant_views/login_view.dart');
                  } else if (index == 2) {
                    Navigator.pushNamed(context, '/bookmarks');
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}



// class BrowseView extends StatelessWidget {
//   BrowseView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white, // Set AppBar background to white
//           title: const Text(
//             'Browse',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black, // Title color
//             ),
//           ),
//           // Add the FilterBar widget to the AppBar
//           actions: [
//             //FilterBar(),
//           ],
//           elevation: 0, // Remove shadow
//         ),
//         backgroundColor: Colors.grey[200], // Set the background color to grey
//         body: Column(
//           children: [
            
//             SearchPage2( browseBloc: BlocProvider.of<BrowseBloc>(context)),
//             Divider(
//               height: 1, // Height of the divider line
//               color: Colors.grey[300], // Color of the divider line
//             ),
//             Expanded(
//               child: BlocBuilder<BrowseBloc, BrowseState>(
//                 builder: (context, state) {
//                   if (state is RestaurantsLoadInProgress) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is RestaurantsLoadSuccess) {
//                     return ListView.builder(
//                       itemCount: state.restaurants.length,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             // Navigate to another view when the restaurant card is clicked
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SpotDetail(restaurant: state.restaurants[index]),
//                               ),
//                             );
//                           },
//                           child: RestaurantCard(restaurant: state.restaurants[index]),
//                         );
//                       }
//                     );
//                   } else if (state is RestaurantsLoadFailure) {
//                     return const Center(child: Text('Failed to load restaurants'));
//                   }
//                   // Si el estado inicial es RestaurantsInitial o cualquier otro estado no esperado
//                   return const Center(child: Text('Start browsing by applying some filters!'));
//                 },
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: CustomNavigationBar(
//           selectedIndex: 0, // Set the selected index to 1
//           onItemTapped: (int index) {
//             // Handle navigation to different views
//             if (index == 1) {
//               Navigator.pushNamed(context, 'package:foodbook_app/presentation/views/restaurant_views/login_view.dart');
//             } else if (index == 2) {
//               Navigator.pushNamed(context, '/bookmarks');
//             }
//           },
//         ),
//       )
//     );
//   }
// }