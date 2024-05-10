import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class ImagesDisplay extends StatelessWidget {
  final Restaurant restaurant;
  const ImagesDisplay({Key? key, required this.restaurant}) : super(key: key);

  // Helper method to decode a base64 string into bytes
  Uint8List _decodeImage(String base64String) {
    // Remove the metadata prefix from the data URL if present
    final String imageData = base64String.split(',').last;
    return base64Decode(imageData);
  }

  // Helper method to determine and return the appropriate image widget
Widget _getImageWidget(String imagePath) {
  if (imagePath.startsWith('data:image')) {
    // It's a base64 image
    return Image.memory(_decodeImage(imagePath), fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
      // If error occurs while decoding base64 image, return an empty container
      return Image.asset(
          'lib/presentation/images/review-detail-no-connection.jpeg', // Path to your placeholder image
          fit: BoxFit.cover,
        );
    });
  } else {
    // It's a network image
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // If error occurs while loading network image, return a placeholder image
        return Image.asset(
          'lib/presentation/images/review-detail-no-connection.jpeg', // Path to your placeholder image
          fit: BoxFit.cover,
        );
      },
    );
  }
}

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
              width: double.infinity,
              height: double.infinity, 
              decoration: BoxDecoration(
                // Define the border and border radius here
                border: Border.all(
                  color: Colors.white, // White border
                  width: 3, // Border width
                ),
                borderRadius: BorderRadius.circular(5), 
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), 
                child: _getImageWidget(restaurant.imagePaths[0]),
              ),
            ),
          );
        case 2:
          return Row(
            children: List.generate(
              imageCount,
              (index) => Expanded(
                child: Container(
                  width: double.infinity, 
                  height: double.infinity, 
                  decoration: BoxDecoration(
                    
                    border: Border.all(
                      color: Colors.white, // White border
                      width: 3, // Border width
                    ),
                    borderRadius: BorderRadius.circular(5), 
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), 
                    child: _getImageWidget(restaurant.imagePaths[index]),
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
                    child: _getImageWidget(restaurant.imagePaths[0]),
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
                        width: double.infinity, 
                        height: double.infinity, 
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
                          child: _getImageWidget(restaurant.imagePaths[index+1]),
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
                    child: _getImageWidget(restaurant.imagePaths[0]),
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
                          child: _getImageWidget(restaurant.imagePaths[1]),
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
                                child: _getImageWidget(restaurant.imagePaths[2]),
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
                                child: _getImageWidget(restaurant.imagePaths[3]),
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
                      child: _getImageWidget(restaurant.imagePaths[0]),
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
                                  child: _getImageWidget(restaurant.imagePaths[1]),
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
                                  child: _getImageWidget(restaurant.imagePaths[2]),
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
                                  child: _getImageWidget(restaurant.imagePaths[3]),
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
                                  child: _getImageWidget(restaurant.imagePaths[4]),
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

    return hasImages ? buildImages() : Container(color: Colors.grey, width: double.infinity, height: 200);
  }
}