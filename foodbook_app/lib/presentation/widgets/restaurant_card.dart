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
          return Center(
            child: Container(
              width: double.infinity, // Ensure the container tries to expand to fill all available width.
              height: double.infinity, // Ensure the container tries to expand to fill all available height.
              decoration: BoxDecoration(
                // Define the border and border radius here
                border: Border.all(
                  color: Colors.white, // White border
                  width: 3, // Border width
                ),
                borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
              ),
              child: ClipRRect(
                // If you want rounded corners, otherwise just remove the ClipRRect
                borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                child: Image.asset(restaurant.imagePaths[0], fit: BoxFit.cover),
              ),
            ),
          );
        case 2:
          return Row(
            children: List.generate(
              imageCount,
              (index) => Expanded(
                child: Container(
                  width: double.infinity, // Ensure the container tries to expand to fill all available width.
                  height: double.infinity, // Ensure the container tries to expand to fill all available height.
                  decoration: BoxDecoration(
                    // Define the border and border radius here
                    border: Border.all(
                      color: Colors.white, // White border
                      width: 3, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                  ),
                  child: ClipRRect(
                    // If you want rounded corners, otherwise just remove the ClipRRect
                    borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                    child: Image.asset(restaurant.imagePaths[index], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          );
        case 3:
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity, // Ensure the container tries to expand to fill all available width.
                  height: double.infinity, // Ensure the container tries to expand to fill all available height.
                  decoration: BoxDecoration(
                    // Define the border and border radius here
                    border: Border.all(
                      color: Colors.white, // White border
                      width: 3, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                  ),
                  child: ClipRRect(
                    // If you want rounded corners, otherwise just remove the ClipRRect
                    borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                    child: Image.asset(restaurant.imagePaths[0], fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: List.generate(
                    imageCount - 1,
                    (index) => Expanded(
                      child: Container(
                        width: double.infinity, // Ensure the container tries to expand to fill all available width.
                        height: double.infinity, // Ensure the container tries to expand to fill all available height.
                        decoration: BoxDecoration(
                          // Define the border and border radius here
                          border: Border.all(
                            color: Colors.white, // White border
                            width: 3, // Border width
                          ),
                          borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                        ),
                        child: ClipRRect(
                          // If you want rounded corners, otherwise just remove the ClipRRect
                          borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                          child: Image.asset(restaurant.imagePaths[index+1], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        case 4:
          return Row(
            children: [
              // The first image takes up the full height on the left
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity, // Ensure the container tries to expand to fill all available width.
                  height: double.infinity, // Ensure the container tries to expand to fill all available height.
                  decoration: BoxDecoration(
                    // Define the border and border radius here
                    border: Border.all(
                      color: Colors.white, // White border
                      width: 3, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                  ),
                  child: ClipRRect(
                    // If you want rounded corners, otherwise just remove the ClipRRect
                    borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                    child: Image.asset(restaurant.imagePaths[0], fit: BoxFit.cover),
                  ),
                ),
              ),
              // The next three images are on the right
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // The second image takes up the top half of the right side
                    Expanded(
                      child: Container(
                        width: double.infinity, // Ensure the container tries to expand to fill all available width.
                        height: double.infinity, // Ensure the container tries to expand to fill all available height.
                        decoration: BoxDecoration(
                          // Define the border and border radius here
                          border: Border.all(
                            color: Colors.white, // White border
                            width: 3, // Border width
                          ),
                          borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                        ),
                        child: ClipRRect(
                          // If you want rounded corners, otherwise just remove the ClipRRect
                          borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                          child: Image.asset(restaurant.imagePaths[1], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    // The third and fourth images are side by side on the bottom half of the right side
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity, // Ensure the container tries to expand to fill all available width.
                              height: double.infinity, // Ensure the container tries to expand to fill all available height.
                              decoration: BoxDecoration(
                                // Define the border and border radius here
                                border: Border.all(
                                  color: Colors.white, // White border
                                  width: 3, // Border width
                                ),
                                borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                              ),
                              child: ClipRRect(
                                // If you want rounded corners, otherwise just remove the ClipRRect
                                borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                                child: Image.asset(restaurant.imagePaths[2], fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity, // Ensure the container tries to expand to fill all available width.
                              height: double.infinity, // Ensure the container tries to expand to fill all available height.
                              decoration: BoxDecoration(
                                // Define the border and border radius here
                                border: Border.all(
                                  color: Colors.white, // White border
                                  width: 3, // Border width
                                ),
                                borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                              ),
                              child: ClipRRect(
                                // If you want rounded corners, otherwise just remove the ClipRRect
                                borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                                child: Image.asset(restaurant.imagePaths[3], fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          case 5:
          default:
            return Row(
              children: [
                // The first image takes up the full height on the left
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity, // Ensure the container tries to expand to fill all available width.
                    height: double.infinity, // Ensure the container tries to expand to fill all available height.
                    decoration: BoxDecoration(
                      // Define the border and border radius here
                      border: Border.all(
                        color: Colors.white, // White border
                        width: 3, // Border width
                      ),
                      borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                    ),
                    child: ClipRRect(
                      // If you want rounded corners, otherwise just remove the ClipRRect
                      borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                      child: Image.asset(restaurant.imagePaths[0], fit: BoxFit.cover),
                    ),
                  ),
                ),
                // The next four images are in a 2x2 grid on the right
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity, // Ensure the container tries to expand to fill all available width.
                                height: double.infinity, // Ensure the container tries to expand to fill all available height.
                                decoration: BoxDecoration(
                                  // Define the border and border radius here
                                  border: Border.all(
                                    color: Colors.white, // White border
                                    width: 3, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                                ),
                                child: ClipRRect(
                                  // If you want rounded corners, otherwise just remove the ClipRRect
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                                  child: Image.asset(restaurant.imagePaths[1], fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity, // Ensure the container tries to expand to fill all available width.
                                height: double.infinity, // Ensure the container tries to expand to fill all available height.
                                decoration: BoxDecoration(
                                  // Define the border and border radius here
                                  border: Border.all(
                                    color: Colors.white, // White border
                                    width: 3, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                                ),
                                child: ClipRRect(
                                  // If you want rounded corners, otherwise just remove the ClipRRect
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                                  child: Image.asset(restaurant.imagePaths[2], fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity, // Ensure the container tries to expand to fill all available width.
                                height: double.infinity, // Ensure the container tries to expand to fill all available height.
                                decoration: BoxDecoration(
                                  // Define the border and border radius here
                                  border: Border.all(
                                    color: Colors.white, // White border
                                    width: 3, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                                ),
                                child: ClipRRect(
                                  // If you want rounded corners, otherwise just remove the ClipRRect
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                                  child: Image.asset(restaurant.imagePaths[3], fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity, // Ensure the container tries to expand to fill all available width.
                                height: double.infinity, // Ensure the container tries to expand to fill all available height.
                                decoration: BoxDecoration(
                                  // Define the border and border radius here
                                  border: Border.all(
                                    color: Colors.white, // White border
                                    width: 3, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(5), // Adjust the radius to your preference
                                ),
                                child: ClipRRect(
                                  // If you want rounded corners, otherwise just remove the ClipRRect
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius to your preference
                                  child: Image.asset(restaurant.imagePaths[4], fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
      }
    }

    return Card(
      color: Color.fromARGB(255, 255, 255, 255), // Card background color
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image layout based on the number of images
          SizedBox(
            height: 200,
            child: hasImages ? buildImages() : Container(color: Color.fromARGB(255, 255, 255, 255)),
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
                        label: Text(category,style: TextStyle(fontWeight: FontWeight.bold),),
                        backgroundColor: Color.fromARGB(255, 199, 199, 199), // Changed color to grey
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

