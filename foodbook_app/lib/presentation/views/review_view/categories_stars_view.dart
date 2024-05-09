import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_event.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_state.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_bloc.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_bloc.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/models/reviewdraft.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';

import 'package:foodbook_app/presentation/widgets/reviews_creation/multi_select_chip_widget.dart';
import 'package:foodbook_app/presentation/widgets/reviews_creation/review_category_widget.dart';

import 'package:foodbook_app/presentation/views/review_view/text_images_view.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';

class CategoriesAndStarsView extends StatefulWidget {
  final Restaurant restaurant;
  final ReviewDraft? initialReview;

  const CategoriesAndStarsView({
    super.key,
    required this.restaurant,
    this.initialReview,  
  });

  @override
  State<CategoriesAndStarsView> createState() => _CategoriesAndStarsViewState();
}

class _CategoriesAndStarsViewState extends State<CategoriesAndStarsView> {
  final TextEditingController _searchController = TextEditingController();
  String? reviewTitle;
  String? reviewContent;
  String? imageUrl;
  bool? wasLoaded;
  
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    BlocProvider.of<StarsBloc>(context).add(InitializeRatings({
      RatingsKeys.cleanliness: 0.0,
      RatingsKeys.waitingTime: 0.0,
      RatingsKeys.service: 0.0,
      RatingsKeys.foodQuality: 0.0,
    }));

    if (widget.initialReview != null) {
      reviewTitle = widget.initialReview!.title;
      reviewContent = widget.initialReview!.content;
      imageUrl = widget.initialReview!.image;
      print("ESTE ES EL PATH: $imageUrl");
      print('INITIAL REVIEW: ${widget.initialReview!.selectedCategories}');
      
      BlocProvider.of<FoodCategoryBloc>(context).add(SetInitialCategoriesEvent(widget.initialReview!.selectedCategories));
      
      // Reloads the widget so that the selected categories are displayed -> bug..?
      WidgetsBinding.instance.addPostFrameCallback((_) {   
        context.read<FoodCategoryBloc>().add(LoadSelectedCategoriesEvent());
      });

      if (widget.initialReview!.ratings.isNotEmpty) {
        BlocProvider.of<StarsBloc>(context).add(InitializeRatings(widget.initialReview!.ratings));
      }
    }
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

  void _openTextAndImagesView() async {
    final foodCategoryBloc = BlocProvider.of<FoodCategoryBloc>(context);
    final starsBloc = BlocProvider.of<StarsBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);

    final result = await Navigator.push(
      context,
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
          child: TextAndImagesView(
            restaurant: widget.restaurant,
            reviewTitle: reviewTitle,
            reviewContent: reviewContent,
            imageUrl: imageUrl,
            wasLoaded: widget.initialReview != null,
          ),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        reviewTitle = result['reviewTitle'];
        reviewContent = result['reviewContent'];
        imageUrl = result['imageUrl'];
        imagePath = result['imagePath'];
        wasLoaded = widget.initialReview != null;
      });
    }

    print('TITULO: $reviewTitle');
    print('CONTENIDO: $reviewContent');
    print('IMAGEN: $imagePath');
    print("WAS LOADED: $imageUrl");
  }

  ReviewDraft _getUpdatedValues() {
    final userBlocState = BlocProvider.of<UserBloc>(context).state;
    final foodCategoryBloc = BlocProvider.of<FoodCategoryBloc>(context);
    final starsBloc = BlocProvider.of<StarsBloc>(context);

    ReviewDraft draft = ReviewDraft(
      user: userBlocState.email,
      title: reviewTitle,
      content: reviewContent,
      image: imagePath,
      spot: widget.restaurant.name,
      uploaded: 0,
      ratings: {
        RatingsKeys.cleanliness: (starsBloc.newRatings[RatingsKeys.cleanliness] ?? 0.0),
        RatingsKeys.waitingTime: (starsBloc.newRatings[RatingsKeys.waitingTime] ?? 0.0),
        RatingsKeys.service: (starsBloc.newRatings[RatingsKeys.service] ?? 0.0),
        RatingsKeys.foodQuality: (starsBloc.newRatings[RatingsKeys.foodQuality] ?? 0.0),
      },
      selectedCategories: foodCategoryBloc.selectedCategories.map((category) => CategoryDTO(name: category.name)).toList(),
    );

    return draft;
  }

  void _onBackPressed() async {
    final shouldSaveDraft = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Would you like to save this review as a draft?'),
        content: const Text('This will overwrite your latest draft from this spot'),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop('Yes'),
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop('No'),
          ),
          TextButton(
            child: const Text('Continue Editing'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    if (shouldSaveDraft == 'Yes') {
      final draft = _getUpdatedValues();

      // if it is a loaded draft, update it. Otherwise, add a new one.
      if (widget.initialReview != null) {
        print('UPDATING DRAFT');
        BlocProvider.of<ReviewDraftBloc>(context).add(UpdateDraft(draft, widget.restaurant.name));
      } else {
        BlocProvider.of<ReviewDraftBloc>(context).add(AddDraft(draft));
        BlocProvider.of<ReviewDraftBloc>(context).add(LoadDrafts());
        await Future.delayed(const Duration(milliseconds: 300));
      }

      Navigator.of(context).pop();
    } else if (shouldSaveDraft == 'No') {
      BlocProvider.of<ReviewDraftBloc>(context).add(UpdateUnfinishedReviewsCount(widget.restaurant.name));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, 
      onPopInvoked: (didPop) async {
        if (!didPop) {
          _onBackPressed();
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
                    _openTextAndImagesView();
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
                          onSelectionChanged: (selectedCategories) {/* ... */},
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
                          onSelectionChanged: (selectedCategories) {/* ... */},
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
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: BlocBuilder<StarsBloc, ReviewState>(
                  builder: (context, state) {
                    return ListView(
                      children: [
                        const SizedBox(height: 40),
                        if (state is ReviewRatings) ...[
                          RatingCategory(category: 'Cleanliness', initialRating: state.ratings['cleanliness'] ?? 0.0),
                          const SizedBox(height: 1),
                          RatingCategory(category: 'Waiting Time', initialRating: state.ratings['waitTime'] ?? 0.0),
                          const SizedBox(height: 1),
                          RatingCategory(category: 'Service', initialRating: state.ratings['service'] ?? 0.0),
                          const SizedBox(height: 1),
                          RatingCategory(category: 'Food Quality', initialRating: state.ratings['foodQuality'] ?? 0.0),
                        ]
                      ],
                    );
                  },
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