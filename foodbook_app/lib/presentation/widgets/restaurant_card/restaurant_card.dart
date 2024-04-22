import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_bloc.dart'; // Importa tu Bloc aquí
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart'; // Importa los eventos de tu Bloc aquí
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/category_section.dart';

import 'package:foodbook_app/presentation/widgets/restaurant_card/images_display.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/title_section.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/subtitle_section.dart';
import 'package:foodbook_app/presentation/widgets/restaurant_card/bookmark_icon.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasImages = restaurant.imagePaths.isNotEmpty;

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
            child: hasImages ? ImagesDisplay(restaurant: restaurant) : Container(color: Color.fromARGB(255, 255, 255, 255)),
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
                    TitleSection(restaurant: restaurant),
                    BlocProvider<BookmarkBloc>(
                      create: (context) => BookmarkBloc(BookmarkManager()),
                      child: BookmarkIcon(restaurant: restaurant),
                    ),
                  ],
                ),
                SizedBox(height: 4), // Add a little space between title and icons
                // Time and distance with icons
                Row(
                  children: [
                    SubtitleSection(restaurant: restaurant)
                  ],
                ),
                SizedBox(height: 8),
                // Category chips
                CategorySection(restaurant: restaurant)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

