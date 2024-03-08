import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:foodbook_app/presentation/widgets/reviews_creation/multi_select_chip_widget.dart';
import 'package:foodbook_app/presentation/widgets/reviews_creation/review_category_widget.dart';

import 'package:foodbook_app/presentation/views/review_view/text_images_view.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';

class CategoriesAndStarsView extends StatelessWidget {
  // TO-DO: Change this to a list of categories from Firebase
  final List<String> _categories = [
    'Vegan',
    'Italian',
    'Fast',
    'Healthy',
    'Homemade',
    'Poultry',
    'Meat',
    'Dessert',
    'Vegetarian',
    'Gluten-free',
    'Low-Carb',
    'Salad',
    'Fruit',
    'Organic',
    'Coffee',
    'Dairy-free',
    'Thailandese',
    'Asian',
    'Colombian',
    'Kosher',
    'Chocolate',
    'Spicy',
    'Traditional',
    'Beef',
    'Group-portion',
    'Japanese',
    'Sushi',
    'Poke',
    'Chinese',
    'Rice',
    'Noodles',
    'Burger',
    'Fries',
    'Sandwich',
    'Bowl',
    'Candy',
    'Pizza',
  ];

  CategoriesAndStarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 6),
            child: Text(
              'What did you order?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
            child: Text(
              'Select all that apply. Only the first three choices will be displayed in your review.',
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
                return MasonryGridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    // Añade tus valores de espaciado aquí si es necesario
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];

                    // El widget MultiSelectChip no debería ser const si su estado puede cambiar
                    return MultiSelectChip(
                      [category],
                      onSelectionChanged: (selectedCategories) {
                        if (selectedCategories.contains(category)) {
                          BlocProvider.of<FoodCategoryBloc>(context).add(SelectCategoryEvent(category));
                        } else {
                          BlocProvider.of<FoodCategoryBloc>(context).add(DeselectCategoryEvent(category));
                        }
                      },
                      maxSelection: 3,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 9),
                  const RatingCategory(category: 'Cleanliness', initialRating: 0),
                  const SizedBox(height: 1),
                  const RatingCategory(category: 'Waiting Time', initialRating: 0),
                  const SizedBox(height: 1),
                  const RatingCategory(category: 'Service', initialRating: 0),
                  const SizedBox(height: 1),
                  const RatingCategory(category: 'Food Quality', initialRating: 0),
                  const SizedBox(height: 5),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TextAndImagesView()),
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
