import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';

import 'package:foodbook_app/presentation/widgets/reviews_creation/multi_select_chip_widget.dart';
import 'package:foodbook_app/presentation/widgets/reviews_creation/review_category_widget.dart';

import 'package:foodbook_app/presentation/views/review_view/text_images_view.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';

class CategoriesAndStarsView extends StatefulWidget {
  final Restaurant restaurant;

  const CategoriesAndStarsView({super.key, required this.restaurant});

  @override
  State<CategoriesAndStarsView> createState() => _CategoriesAndStarsViewState();
}

class _CategoriesAndStarsViewState extends State<CategoriesAndStarsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Dispara el evento de búsqueda.
    BlocProvider.of<FoodCategoryBloc>(context).add(SearchCategoriesEvent(_searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Asumiendo que esto controla si se permite el retroceso
      onPopInvoked: (didPop) async {
        if (!didPop) {
          // Lógica para manejar cuando el usuario intenta salir
          Object shouldSaveDraft = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text('Do you want to save the review as a draft?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.of(context).pop('Yes'), // llamar función para salir y guardar
                ),
                TextButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop('No'), // llamar función para salir y no guardar
                ),
                TextButton(
                  child: const Text('Continue Editing'),
                  onPressed: () => Navigator.of(context).pop('Continue'),
                ),
              ],
            ),
          ) ?? false;

          if (shouldSaveDraft != 'Continue') {
            if (shouldSaveDraft == 'Yes') {
              // Lógica para guardar el borrador
            }
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
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
                if (foodCategoryBloc.selectedCategories.isEmpty) {
                  const snackBar = SnackBar(
                    content: Text('Please select at least one category!'),
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  final starsBloc = BlocProvider.of<StarsBloc>(context);
                  if (starsBloc.newRatings.isEmpty || starsBloc.newRatings.values.contains(0.0) || starsBloc.newRatings.length != 4) {
                    const snackBar = SnackBar(
                      content: Text('Please rate all stats!'),
                      duration: Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  } else {
                    final userBloc = BlocProvider.of<UserBloc>(context);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: foodCategoryBloc),
                            BlocProvider.value(value: starsBloc),
                            BlocProvider.value(value: userBloc),
                            BlocProvider(create: (context) => ImageUploadBloc(ReviewRepository())),
                            BlocProvider(create: (context) => ReviewBloc(
                                reviewRepository: ReviewRepository(),
                                restaurantRepository: RestaurantRepository()
                              )
                            ),
                          ],
                          child: TextAndImagesView(restaurant: widget.restaurant),
                        ),
                      ),
                    );
                  }
                }
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
            PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 1, 16.0, 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
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
      ),
    );
  }

  void disposeCategoriesStarsView() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
