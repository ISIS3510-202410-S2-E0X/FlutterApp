import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasImages = restaurant.imagePaths.isNotEmpty;
    int imageCount = restaurant.imagePaths.length;

    // Helper method to build the image layout
    Widget buildImages() {
      switch (imageCount) {
        case 1:
          return Image.asset(restaurant.imagePaths[0], fit: BoxFit.cover);
        case 2:
          return Row(
            children: List.generate(
              imageCount,
              (index) => Expanded(
                child: Image.asset(restaurant.imagePaths[index], fit: BoxFit.cover),
              ),
            ),
          );
        case 3:
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(restaurant.imagePaths[0], fit: BoxFit.cover),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: List.generate(
                    imageCount - 1,
                    (index) => Expanded(
                      child: Image.asset(restaurant.imagePaths[index + 1], fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ],
          );
        case 4:
        default: // Handle 4 or more images
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(restaurant.imagePaths[0], fit: BoxFit.cover),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(child: Image.asset(restaurant.imagePaths[1], fit: BoxFit.cover)),
                    Expanded(child: Image.asset(restaurant.imagePaths[2], fit: BoxFit.cover)),
                    if (imageCount > 3)
                      Expanded(child: Image.asset(restaurant.imagePaths[3], fit: BoxFit.cover)),
                  ],
                ),
              ),
            ],
          );
      }
    }

    return Card(
      color: Color.fromARGB(255, 255, 254, 254), // Card background color
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image layout based on the number of images
          SizedBox(
            height: 200,
            child: hasImages ? buildImages() : Container(color: Colors.grey),
          ),
          // Restaurant details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant name, price range, and bookmark icon on the same line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18, // Increased font size
                            color: Colors.black, // Default color for all spans
                          ),
                          children: [
                            TextSpan(
                              text: restaurant.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' · '), // Dot separator
                            TextSpan(
                              text: restaurant.priceRange,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.bookmark_border,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
                SizedBox(height: 4), // Add a little space between title and icons
                // Time and distance with icons
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: const Color.fromARGB(255, 0, 0, 0)),
                    SizedBox(width: 4),
                    Text(
                      '${restaurant.timeRange} · ',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 53, 53, 53),
                      ),
                    ),
                    Icon(Icons.location_on, size: 16, color: const Color.fromARGB(255, 0, 0, 0)),
                    SizedBox(width: 4),
                    Text(
                      '${restaurant.distance.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 53, 53, 53),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: restaurant.categories.map((category) => Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(category),
                        backgroundColor: const Color.fromARGB(255, 202, 202, 202), // Changed color to grey
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

