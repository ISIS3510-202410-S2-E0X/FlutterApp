import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/category_repository.dart';
import 'package:foodbook_app/presentation/views/review_view/categories_stars_view.dart';
import 'package:foodbook_app/presentation/views/review_view/restaurant_reviews_view.dart';

class SpotDetail extends StatelessWidget {
  final Restaurant restaurant;

  const SpotDetail({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1),
            Container(
              color: Colors.grey[200], // Set the background color to grey for the section below the divider
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.asset(
                      'lib/presentation/images/google_maps.jpeg',
                      fit: BoxFit.cover,
                      height: 200, // Set the desired height
                      width: double.infinity, // Set the width to stretch horizontally
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Add your categories here
                        for (final category in restaurant.categories)
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white, // Set the background color to white
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, // Set the text to bold
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)), // Increase the font size
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ReviewListView(restaurant: restaurant)),
                            );
                          },
                          child: const Text('See more', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Set the background color to white
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        _buildReviewCriteria('Cleanliness', restaurant.cleanliness_avg, context),
                        _buildReviewCriteria('Waiting Time', restaurant.waiting_time_avg, context),
                        _buildReviewCriteria('Service', restaurant.service_avg, context),
                        _buildReviewCriteria('Food Quality', restaurant.food_quality_avg, context),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider<FoodCategoryBloc>(
                                    create: (context) => FoodCategoryBloc(
                                      categoryRepository: CategoryRepository(),
                                      maxSelection: 3
                                    ),
                                  ),
                                  BlocProvider<StarsBloc>(
                                    create: (context) => StarsBloc(),
                                  ),
                                ],
                                child: CategoriesAndStarsView(restaurant: restaurant),
                              );
                            },
                          ),
                        );
                      },
                      child: const Text('Leave a review', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCriteria(String criteria, int score, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(criteria, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    score >= 50 ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                score >= 50 ? Icons.thumb_up : Icons.thumb_down,
                color: score >= 50 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text('$score%', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}