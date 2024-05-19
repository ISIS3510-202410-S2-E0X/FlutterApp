import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_state.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_state.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_reviews/review_item.dart';

class UserReviews extends StatefulWidget {

  const UserReviews({Key? key}) : super(key: key);

  @override
  State<UserReviews> createState() => _UserReviews();

}

class _UserReviews extends State<UserReviews> {
  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get _connectivityStream => _connectivity.onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    checkConnection();
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
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream.asyncExpand((results) => Stream.fromIterable(results)),
      builder: (context, snapshot) {
        bool isOffline = snapshot.data == ConnectivityResult.none || snapshot.connectionState == ConnectionState.none;
        return Scaffold(
          appBar: AppBar(
                title: const Text('My reviews'),
              ),
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
                        child: BlocBuilder<ReviewBloc, ReviewState>(
                          builder: (context, state) {
                            if (state is ReviewLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ReviewFetchUserReviewsSuccess) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...state.userReviews.map((review) => ReviewItem(review: review, isOffline: isOffline)),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('No reviews, yet...'),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
            ),
          );
      },
    );
  }
}