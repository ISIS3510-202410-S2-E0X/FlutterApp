import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';

import 'package:foodbook_app/presentation/widgets/reviews_creation/multi_select_chip_widget.dart';
import 'package:foodbook_app/presentation/widgets/reviews_creation/review_category_widget.dart';

import 'package:foodbook_app/presentation/views/review_view/text_images_view.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';

class CategoriesAndStarsView extends StatelessWidget {
  final Restaurant restaurant;

  const CategoriesAndStarsView({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white, // Set AppBar background to white
        title: const Text(
          'What did you order?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Title color
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              final foodCategoryBloc = BlocProvider.of<FoodCategoryBloc>(context);
              final starsBloc = BlocProvider.of<StarsBloc>(context);
              final userBloc = BlocProvider.of<UserBloc>(context);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: foodCategoryBloc),
                      BlocProvider.value(value: starsBloc),
                      BlocProvider.value(value: userBloc),
                      BlocProvider(create: (context) => ImageUploadBloc(ReviewRepository())),
                    ],
                    child: TextAndImagesView(restaurant: restaurant),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(0, 122, 255 , 100),
              ),
            ),
          ),
        ],
        elevation: 0, // Remove shadow
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
            child: Text(
              'Select at least one and up to three categories',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          const PreferredSize(
            preferredSize: Size.fromHeight(56.0), // Altura estándar de una barra de búsqueda
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 1, 16.0, 8.0), // Aumenta los valores laterales para más espacio
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(192, 217, 219, 225),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
              builder: (context, state) {
                if (state is FoodCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FoodCategoryError) {
                  return const Center(child: Text('Failed to load categories'));
                } else if (state is FoodCategoryLoaded) {
                  return MasonryGridView.builder(
                    // padding: const EdgeInsets.all(10),
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final category = state.data[index];
                      return MultiSelectChip(
                        [category.name],
                        const [''],
                        onSelectionChanged: (selectedCategories) {
                          // TO-DO: actions when selected categories change
                        },
                        maxSelection: 3,
                      );
                    },
                  );
                } else if (state is FoodCategorySelected) {
                  return MasonryGridView.builder(
                    // padding: const EdgeInsets.all(10),
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: state.allCategories.length,
                    itemBuilder: (context, index) {
                      final category = state.allCategories[index];
                      final categoriesSelected = state.selectedCategories;
                      return MultiSelectChip(
                        [category.name],
                        categoriesSelected.map((e) => e.name).toList(),
                        onSelectionChanged: (selectedCategories) {
                          // TO-DO: actions when selected categories change
                        },
                        maxSelection: 3,
                      );
                    },
                  );
                } else if (state is FoodCategoryMaxSelectionReached) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    const snackBar = SnackBar(
                      content: Text('Max categories selected. Returning to selection...'),
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    
                    context.read<FoodCategoryBloc>().add(LoadSelectedCategoriesEvent());
                  });

                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: Text('Please wait...'));
                }
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: const <Widget>[
                  SizedBox(height: 9),
                  RatingCategory(category: 'Cleanliness', initialRating: 0),
                  SizedBox(height: 1),
                  RatingCategory(category: 'Waiting Time', initialRating: 0),
                  SizedBox(height: 1),
                  RatingCategory(category: 'Service', initialRating: 0),
                  SizedBox(height: 1),
                  RatingCategory(category: 'Food Quality', initialRating: 0),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
