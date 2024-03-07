import 'package:flutter_bloc/flutter_bloc.dart';
import 'food_category_event.dart';
import 'food_category_state.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  final int maxSelection;

  FoodCategoryBloc(this.maxSelection) : super(FoodCategoryState([]));

  @override
  Stream<FoodCategoryState> mapEventToState(FoodCategoryEvent event) async* {
    if (event is SelectCategoryEvent) {
      if (state.selectedCategories.length < maxSelection ||
          maxSelection == -1) {
        yield FoodCategoryState([...state.selectedCategories, event.category]);
      }
    } else if (event is DeselectCategoryEvent) {
      yield FoodCategoryState(
        state.selectedCategories.where((c) => c != event.category).toList(),
      );
    } else if (event is MaxSelectionReachedEvent) {
      // TO-DO: Handle when user reaches max selection.
    }
  }
}
