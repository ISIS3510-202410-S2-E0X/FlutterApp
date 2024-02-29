import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/presentation/widgets/multi_select_chip_widget.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';

class FoodCategorySelectionView extends StatelessWidget {
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
  ];

  FoodCategorySelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FoodCategoryBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Categories'),
      ),
      body: BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
        builder: (context, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              childAspectRatio: (1 / 0.4),
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];

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
    );
  }
}
