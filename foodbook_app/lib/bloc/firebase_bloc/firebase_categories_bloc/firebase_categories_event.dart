import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetData extends CategoryEvent {
  GetData();
}

class SelectCategoryEvent extends CategoryEvent {
  final String category;

  SelectCategoryEvent(this.category);
}

class DeselectCategoryEvent extends CategoryEvent {
  final String category;

  DeselectCategoryEvent(this.category);
}

class MaxSelectionReachedEvent extends CategoryEvent {
  final List<String> selectedCategories;

  MaxSelectionReachedEvent(this.selectedCategories);
}
