import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
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
        backgroundColor: Colors.white, // Set AppBar background to white
        title: Text(
          'Browse',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Title color
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black), // Appbar icons color
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black), // Icon for filter
            onPressed: _showFilterDialog, // Show the filter dialog when the icon is pressed
          ),
        ],
        elevation: 0, // Remove shadow
      ),
      backgroundColor: Colors.grey[200], // Set the background color to grey
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 255, 255, 255), // White background color for search bar container
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Horizontal padding only
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 5), // Reduced vertical padding to make the search bar thinner
                filled: true,
                fillColor: const Color.fromARGB(255, 197, 197, 197), // Search bar fill color
              ),
            ),
          ),
          Container(
            color: Colors.white, // White background color for the SizedBox container
            child: SizedBox(height: 8), // White space below the search bar
          ),
          Divider(
            height: 1, // Height of the divider line
            color: Colors.grey[300], // Color of the divider line
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


  void _showFilterDialog() {
    String selectedPrice = '\$';
    double selectedDistance = 5.0;
    String selectedCategory = '';
    bool isPriceFilterEnabled = false;
    bool isDistanceFilterEnabled = false;
    bool isCategoryFilterEnabled = false;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text('Price Range'),
                    trailing: Switch(
                      value: isPriceFilterEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isPriceFilterEnabled = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        isPriceFilterEnabled = !isPriceFilterEnabled;
                      });
                    },
                  ),
                  isPriceFilterEnabled
                      ? DropdownButton<String>(
                          value: selectedPrice,
                          onChanged: (value) {
                            setState(() {
                              selectedPrice = value!;
                            });
                          },
                          items: ['\$', '\$\$', '\$\$\$', '\$\$\$\$']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      : Container(),
                  ListTile(
                    title: Text('Distance (km)'),
                    trailing: Switch(
                      value: isDistanceFilterEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isDistanceFilterEnabled = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        isDistanceFilterEnabled = !isDistanceFilterEnabled;
                      });
                    },
                  ),
                  isDistanceFilterEnabled
                      ? Slider(
                          min: 0.0,
                          max: 20.0,
                          divisions: 20,
                          label: '${selectedDistance.toStringAsFixed(1)} km',
                          value: selectedDistance,
                          onChanged: (value) {
                            setState(() {
                              selectedDistance = value;
                            });
                          },
                        )
                      : Container(),
                  ListTile(
                    title: Text('Category'),
                    trailing: Switch(
                      value: isCategoryFilterEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isCategoryFilterEnabled = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        isCategoryFilterEnabled = !isCategoryFilterEnabled;
                      });
                    },
                  ),
                  isCategoryFilterEnabled
                      ? TextField(
                          decoration: InputDecoration(
                            labelText: 'Category',
                            hintText: 'e.g., Italian, Vegan',
                          ),
                          onChanged: (value) {
                            selectedCategory = value;
                          },
                        )
                      : Container(),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BrowseBloc>().add(FilterRestaurants(
                        price: isPriceFilterEnabled ? selectedPrice : null,
                        distance: isDistanceFilterEnabled ? selectedDistance : null,
                        category: isCategoryFilterEnabled ? selectedCategory : null,
                      ));
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



}
