import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> categoriesList;
  final Function(List<String>)? onSelectionChanged;
  final Function(List<String>)? onMaxSelected;
  final int? maxSelection;

  const MultiSelectChip(this.categoriesList, {super.key, this.onSelectionChanged, this.onMaxSelected, this.maxSelection});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  _buildChoiceList() {
    return widget.categoriesList.map((item) {
      return BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
        builder: (context, state) {
          final isSelected = state.selectedCategories.contains(item);

          return ChoiceChip(
            label: Text(item),
            selected: isSelected,
            onSelected: (selected) {
              if (isSelected) {
                BlocProvider.of<FoodCategoryBloc>(context).add(DeselectCategoryEvent(item));
              } else {
                BlocProvider.of<FoodCategoryBloc>(context).add(SelectCategoryEvent(item));
              }
            },
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
