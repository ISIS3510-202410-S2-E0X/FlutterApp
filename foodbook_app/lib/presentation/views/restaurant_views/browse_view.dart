import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repository/restaurant_repo.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card.dart';

class BrowseView extends StatelessWidget {
  BrowseView({Key? key}) : super(key: key);

  final RestaurantRepository repository = RestaurantRepository();

  @override
  Widget build(BuildContext context) {
    List<Restaurant> restaurants = repository.fetchRestaurants();

    return Scaffold(
      appBar: AppBar(
        title: Text('Browse', style: TextStyle(fontWeight: FontWeight.bold)), // Bold title
        actions: [
          IconButton(
            icon: Icon(Icons.tune), // Filter icon
            onPressed: () {
              // Handle filter action
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Set the background color to grey
        child: ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return RestaurantCard(restaurant: restaurants[index]);
          },
        ),
      ),
    );
  }
}
