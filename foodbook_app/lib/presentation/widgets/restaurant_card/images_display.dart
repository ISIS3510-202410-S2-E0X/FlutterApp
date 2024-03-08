import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class ImagesDisplay extends StatelessWidget {
  final Restaurant restaurant;
  const ImagesDisplay({Key? key, required this.restaurant}) : super(key: key);

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

    return hasImages ? buildImages() : Container(color: Colors.grey, width: double.infinity, height: 200);
  }
}