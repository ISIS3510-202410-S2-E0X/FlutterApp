import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_state.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_event.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_state.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_event.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_state.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/models/reviewdraft.dart';
import 'package:foodbook_app/data/repositories/category_repository.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';
import 'package:foodbook_app/presentation/views/review_view/categories_stars_view.dart';
import 'package:foodbook_app/presentation/views/review_view/restaurant_reviews_view.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_map.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class SpotDetail extends StatefulWidget {
  final String restaurantId;

  const SpotDetail({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _SpotDetailState createState() => _SpotDetailState();
}

class _SpotDetailState extends State<SpotDetail> {
  // ignore: unused_field
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

   @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

   @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final hasConnection = results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi);

    // Check if the state is SpotDetailLoadFailure and there is an internet connection
    if (hasConnection) {
      // If there is an internet connection, try to fetch the restaurant details again
      context.read<BookmarkInternetViewBloc>().add(BookmarksAccessInternet());

      // Access the current state of SpotDetailBloc
      final currentState = context.read<SpotDetailBloc>().state;

      // Check if the state is SpotDetailLoadFailure and there is an internet connection
      if (currentState is SpotDetailLoadFailure) {
        // If there is an internet connection, try to fetch the restaurant details again
        context.read<SpotDetailBloc>().add(FetchRestaurantDetail(currentState.restaurantId)); }
    } else {
      // If there is no internet connection, inform the relevant bloc
      context.read<BookmarkInternetViewBloc>().add(BookmarksAccessNoInternet());
    } 
  }
  


  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpotDetailBloc>(
      create: (context) => SpotDetailBloc(
        RepositoryProvider.of<RestaurantRepository>(context),
      )..add(FetchRestaurantDetail(widget.restaurantId)),
      child: BlocBuilder<SpotDetailBloc, SpotDetailState>(
        builder: (context, state) {
          if (state is SpotDetailLoadInProgress) {
            return Scaffold(
              body: Container(
                color: Colors.white, // Set the Container color to white
                width: double.infinity, // Fill the screen width
                height: double.infinity, // Fill the screen height
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (state is SpotDetailLoadSuccess) {
            return SpotDetailView(restaurant: state.restaurant);
          }  else if (state is SpotDetailLoadFailure) {
            return SpotDetailViewFailure(message: 'Connect again to see the spot detail.');
          } else {
            return const Center(child: Text('Unknown error.'));
          }
        },
      ),
    );
  }
}

class SpotDetailView extends StatelessWidget {
  final Restaurant restaurant;

  const SpotDetailView({super.key, required this.restaurant});

  void _navigateToReviewPage(BuildContext context, { bool continueDraft = false }) {
    ReviewDraftBloc reviewDraftBloc = BlocProvider.of<ReviewDraftBloc>(context);

    if (continueDraft) {
      print('Continuing draft');
      reviewDraftBloc.add(LoadDraftsBySpot(restaurant.name));

      reviewDraftBloc.stream.firstWhere((state) => state is ReviewLoaded).then((state) {
        if (state is ReviewLoaded && state.drafts.isNotEmpty) {
          print('Draft found, navigating with draft');
          _pushCategoriesAndStarsView(context, state.drafts.first);
        } else {
          print('No draft found, navigating to new review page');
          _pushCategoriesAndStarsView(context);
        }
      }).catchError((error) {
        // Manejar cualquier error que pueda ocurrir durante el proceso
        print('Error: $error');
        _pushCategoriesAndStarsView(context); // Navegar sin borrador si hay un error
      });
    } else {
      print('Starting new draft');
      _pushCategoriesAndStarsView(context);
    }
  }

  void _pushCategoriesAndStarsView(BuildContext context, [ReviewDraft? draft]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ReviewDraftBloc>(
                create: (context) => ReviewDraftBloc(
                  ReviewDraftRepository(DatabaseProvider())
                ),
              ),
              BlocProvider<FoodCategoryBloc>(
                create: (context) => FoodCategoryBloc(
                  categoryRepository: CategoryRepository(),
                  maxSelection: 3,
                  minSelection: 1,
                ),
              ),
              BlocProvider<StarsBloc>(
                create: (context) => StarsBloc(),
              ),
            ],
            child: CategoriesAndStarsView(restaurant: restaurant, initialReview: draft),
          );
        },
      ),
    );
  }

  void _checkForUnfinishedReview(BuildContext context) {
    final reviewDraftBloc = BlocProvider.of<ReviewDraftBloc>(context);
    reviewDraftBloc.add(CheckUnfinishedDraft(restaurant.name));
    
    reviewDraftBloc.stream.firstWhere((state) => state is UnfinishedDraftExists || state is NoUnifishedReviews).then((state) {
      if (state is UnfinishedDraftExists) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unfinished Review'),
            content: const Text('You have an unfinished draft. Would you like to continue?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToReviewPage(context, continueDraft: true);
                },
                child: const Text('Continue Draft'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToReviewPage(context, continueDraft: false);
                },
                child: const Text('Start New'),
              ),
            ],
          ),
        );
      } else {
        // No hay borrador inacabado, procede con un nuevo borrador
        _navigateToReviewPage(context, continueDraft: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOffline = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<BookmarkInternetViewBloc, BookmarkInternetViewState>(
            builder: (context, connectivityState) {
              isOffline = connectivityState is BookmarksNoInternet;
              //context.read<BookmarkInternetViewBloc>().add(BookmarksAccessInternet());
              return Column(
                children: [
                  if (isOffline) // This line shows or hides the offline message
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
                  child: SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey[200], 
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ), 
                              height: 200, 
                              width: double.infinity,
                              child: SpotMap(restaurant: restaurant),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    // Add your categories here
                                    for (final category in restaurant.categories)
                                      Container(
                                        margin: const EdgeInsets.all(8.0),
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Set the background color to white
                                          border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          category.replaceAll('.', ' '),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold, // Set the text to bold
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Reviews',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ReviewListView(restaurant: restaurant)),
                                      );
                                    },
                                    child: Text('See more (${restaurant.reviews.length})', style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // Set the background color to white
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Column(
                                children: [
                                  _buildReviewCriteria('Cleanliness', restaurant.cleanliness_avg, context),
                                  _buildReviewCriteria('Waiting Time', restaurant.waiting_time_avg, context),
                                  _buildReviewCriteria('Service', restaurant.service_avg, context),
                                  _buildReviewCriteria('Food Quality', restaurant.food_quality_avg, context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      // ...
      bottomNavigationBar: Container(
      color: Color.fromARGB(255, 252, 252, 252), // Grey background for the bottom bar
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Button color
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          if (isOffline) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Try connecting online to leave a review'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            _checkForUnfinishedReview(context);
          }
        },
        child: const Text('Leave a review', style: TextStyle(color: Colors.white)),
      ),
    ),

// ...

    );
  }

  Widget _buildReviewCriteria(String criteria, int score, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(criteria, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    score >= 50 ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                score >= 50 ? Icons.thumb_up : Icons.thumb_down,
                color: score >= 50 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text('$score%', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// If the SpotDetailLoadFailure state is emitted, the SpotDetailView widget will show the back button in the app bar and a failure message in the center of the screen.
class SpotDetailViewFailure extends StatelessWidget {
  final String message;

  const SpotDetailViewFailure({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 64.0), // Adjust the padding as needed
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use min to take up less space
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.signal_wifi_off, color: Colors.grey),
                SizedBox(width: 8),
                Text('Offline', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20), // Space between the offline icon and the message
            Text(message),
          ],
        ),
      ),
    );
  }
}
