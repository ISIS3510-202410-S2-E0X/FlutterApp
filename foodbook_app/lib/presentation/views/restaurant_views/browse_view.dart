import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repository/restaurant_repo.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card.dart';

// ... Other imports remain unchanged

class BrowseView extends StatefulWidget {
  BrowseView({Key? key}) : super(key: key);

  @override
  _BrowseViewState createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  final RestaurantRepository repository = RestaurantRepository();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Restaurant> restaurants = repository.fetchRestaurants();

    return Scaffold(
      appBar: AppBar(
        title: Text('Browse', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list), // Icon for filter
            onPressed: () {
              // Handle filter action
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200], // Set the background color to grey
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return RestaurantCard(restaurant: restaurants[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'For you',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmarks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Add navigation logic here if necessary
        },
      ),
    );
  }
}
