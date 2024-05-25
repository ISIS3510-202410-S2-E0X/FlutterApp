

abstract class HotCategoriesState{}

class HotCategoriesInitial extends HotCategoriesState {}

class HotCategoriesLoaded extends HotCategoriesState {
  final List<String> hotCategories;
  HotCategoriesLoaded(this.hotCategories);
}

class HotCategoriesLoadInProgress extends HotCategoriesState {} 

class HotCategoriesLoadFailure extends HotCategoriesState {
  final String errorMessage;

  HotCategoriesLoadFailure({
    required this.errorMessage,
  });
}
