
import 'package:foodbook_app/data/dtos/category_dto.dart';

abstract class FoodCategoryEvent {}

class LoadCategoriesEvent extends FoodCategoryEvent {}

class LoadSelectedCategoriesEvent extends FoodCategoryEvent {}

class SelectCategoryEvent extends FoodCategoryEvent {
  final String category;

  SelectCategoryEvent(this.category);
}

class DeselectCategoryEvent extends FoodCategoryEvent {
  final String category;

  DeselectCategoryEvent(this.category);
}

class MaxSelectionReachedEvent extends FoodCategoryEvent {
  final List<String> selectedCategories;

  MaxSelectionReachedEvent(this.selectedCategories);
}

class SearchCategoriesEvent extends FoodCategoryEvent {
  final String searchTerm;

  SearchCategoriesEvent(this.searchTerm);

  List<Object> get props => [searchTerm];
}

class SetInitialCategoriesEvent extends FoodCategoryEvent {
  final List<CategoryDTO> initialCategories;
  SetInitialCategoriesEvent(this.initialCategories);
}
