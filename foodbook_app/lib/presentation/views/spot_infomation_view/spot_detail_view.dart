import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/models/reviewdraft.dart';
import 'package:foodbook_app/data/repositories/category_repository.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';
import 'package:foodbook_app/presentation/views/review_view/categories_stars_view.dart';
import 'package:foodbook_app/presentation/views/review_view/restaurant_reviews_view.dart';
import 'package:foodbook_app/presentation/views/spot_infomation_view/spot_map.dart';


class SpotDetail extends StatelessWidget {
  final Restaurant restaurant;
  final ReviewDraftRepository reviewDraftRepository;

  const SpotDetail({
    super.key,
    required this.restaurant,
    required this.reviewDraftRepository
  });

  void _navigateToReviewPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<ReviewDraftRepository>(
                create: (context) => ReviewDraftRepository(DatabaseProvider()),
              ),
            ],                  
            child: MultiBlocProvider(
              providers: [
                BlocProvider<FoodCategoryBloc>(
                  create: (context) => FoodCategoryBloc(
                    categoryRepository: CategoryRepository(),
                    maxSelection: 3,
                    minSelection: 1,
                  ),
                ),
                BlocProvider<StarsBloc>(
                  create: (context) => StarsBloc(),
                ),
                BlocProvider<ReviewDraftBloc>(
                  create: (context) => ReviewDraftBloc(ReviewDraftRepository(DatabaseProvider())),
                )
              ],
              child: CategoriesAndStarsView(restaurant: restaurant),
            ),
          );
        },
      ),
    );
  }

  Future<bool> hasUnfinishedReview(String restaurant) async {
    List<ReviewDraft> reviewDraft = await reviewDraftRepository.getDraftsBySpot(restaurant);
    if (reviewDraft.isNotEmpty) {
      return true;
    }
    
    return Future.delayed(const Duration(milliseconds: 500), () => false); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 238, 238, 238),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey[200], 
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ), 
                          height: 200, 
                          width: double.infinity,
                          child: SpotMap(restaurant: restaurant),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Reviews',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                ),
                              ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            children: [
                              _buildReviewCriteria('Cleanliness', restaurant.cleanliness_avg, context),
                              _buildReviewCriteria('Waiting Time', restaurant.waiting_time_avg, context),
                              _buildReviewCriteria('Service', restaurant.service_avg, context),
                              _buildReviewCriteria('Food Quality', restaurant.food_quality_avg, context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200], // Grey background for the bottom bar
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Button color
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () async {
            bool hasDraft = await hasUnfinishedReview(restaurant.name);
            if (hasDraft) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Unfinished Review'),
                    content: const Text('You have an unfinished review for this restaurant. Do you want to continue with that or start a new one?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          
                        },
                        child: const Text('Continue'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _navigateToReviewPage(context);
                        },
                        child: const Text('New'),
                      ),
                    ],
                  );
                },
              );
            } else {
              _navigateToReviewPage(context);
            }
          }, child: const Text('Leave a review', style:TextStyle(color:Colors.white)),
        )
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