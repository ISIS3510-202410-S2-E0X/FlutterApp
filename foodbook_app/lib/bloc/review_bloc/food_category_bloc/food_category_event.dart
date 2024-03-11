abstract class FoodCategoryEvent {}

class LoadCategoriesEvent extends FoodCategoryEvent {}

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
