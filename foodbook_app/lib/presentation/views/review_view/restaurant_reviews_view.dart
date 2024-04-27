import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_reviews/review_item.dart';

class ReviewListView extends StatefulWidget {
  final Restaurant restaurant;

  const ReviewListView({super.key, required this.restaurant});

  @override
  State<ReviewListView> createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  final Connectivity _connectivity = Connectivity();
  Stream<List<ConnectivityResult>> get _connectivityStream => _connectivity.onConnectivityChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: _connectivityStream.asyncExpand((results) => Stream.fromIterable(results)),
      builder: (context, snapshot) {
        bool isOffline = snapshot.data == ConnectivityResult.none || snapshot.connectionState == ConnectionState.none;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.restaurant.name),
          ),
          body: Column(
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
              Divider(
                height: 1, // Height of the divider line
                color: Colors.grey[300], // Color of the divider line
              ),
              Expanded(
                child: widget.restaurant.reviews.isNotEmpty ?
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.restaurant.reviews.map((review) => ReviewItem(review: review, isOffline: isOffline)),
                      ],
                    ),
                  ),
                )
                : const Center(
                  child: Text('No reviews, yet...'),
                )
              ),
            ],
          )
        );
      },
    );
  }
}
