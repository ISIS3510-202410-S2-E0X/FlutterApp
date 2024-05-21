import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> categoriesList;
  final List<String> initialSelectedCategories;
  final Function(List<String>)? onSelectionChanged;
  final int? maxSelection;

  const MultiSelectChip(this.categoriesList, this.initialSelectedCategories, {super.key, this.onSelectionChanged, this.maxSelection});

  @override
  // ignore: library_private_types_in_public_api
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.initialSelectedCategories);
    print('Initial selected categories: $selectedCategories');
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.categoriesList.map((item) {
        bool isSelected = selectedCategories.contains(item);
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            setState(() async {
              if (selected) {
                var connectivityResult = await Connectivity().checkConnectivity();
                if (connectivityResult[0] == ConnectivityResult.none) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No internet connection. Try connceting to continue with the review!'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  if (!selectedCategories.contains(item)) {
                    selectedCategories.add(item);
                    BlocProvider.of<FoodCategoryBloc>(context).add(SelectCategoryEvent(item));
                  }
                }
              } else {
                selectedCategories.remove(item);
                BlocProvider.of<FoodCategoryBloc>(context).add(DeselectCategoryEvent(item));
              }
            });

            widget.onSelectionChanged?.call(selectedCategories);
          },
        );
      }).toList(),
    );
  }
}

