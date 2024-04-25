import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';
import 'package:foodbook_app/data/repositories/category_repository.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  final CategoryRepository categoryRepository;
  final int maxSelection;
  final int minSelection;
  List<CategoryDTO> selectedCategories = [];

  FoodCategoryBloc({required this.categoryRepository, required this.maxSelection, required this.minSelection})
      : super(InitialState()) {
    on<SelectCategoryEvent>(_onSelectCategory);
    on<DeselectCategoryEvent>(_onDeselectCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadSelectedCategoriesEvent>(_onLoadSelectedCategories);
    on<SearchCategoriesEvent>(_onSearchCategories);
    on<SetInitialCategoriesEvent>(_onSetInitialCategories);
    
    add(LoadCategoriesEvent());
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<FoodCategoryState> emit) async {
    emit(FoodCategoryLoading());
    try {
      final categories = await categoryRepository.getAllCategories(); 
      emit(FoodCategoryLoaded(categories)); 
    } catch (e) {
      emit(FoodCategoryError(e.toString())); 
    }
  }

  Future<void> _onLoadSelectedCategories(LoadSelectedCategoriesEvent event, Emitter<FoodCategoryState> emit) async {
    emit(FoodCategoryLoading());
    try {
      final categories = await categoryRepository.getAllCategories();
      emit(FoodCategorySelected(categories, selectedCategories)); 
    } catch (e) {
      emit(FoodCategoryError(e.toString())); 
    }
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<FoodCategoryState> emit) async {
    if (selectedCategories.length < maxSelection) {
      selectedCategories.add(CategoryDTO(name: event.category));
      final categories = await categoryRepository.getAllCategories();
      emit(FoodCategorySelected(categories, selectedCategories));
    } else if (selectedCategories.length >= maxSelection) {
      emit(FoodCategoryMaxSelectionReached());
    } else {
      emit(FoodCategoryError('An error occurred while selecting category.'));
    }
  }

  void _onDeselectCategory(DeselectCategoryEvent event, Emitter<FoodCategoryState> emit) async {
    final indexToRemove = selectedCategories.indexWhere((category) => category.name == event.category);
    if (indexToRemove != -1) {
      selectedCategories.removeAt(indexToRemove);
      final categories = await categoryRepository.getAllCategories();
      emit(FoodCategorySelected(categories, selectedCategories));
    }
  }

  Future<void> _onSearchCategories(SearchCategoriesEvent event, Emitter<FoodCategoryState> emit) async {
    emit(FoodCategoryLoading());
    try {
      final categories = await categoryRepository.getAllCategories();
      final filteredCategories = categories.where((category) => 
        category.name.toLowerCase().contains(event.searchTerm.toLowerCase())
      ).toList();
      emit(FoodCategoryLoaded(filteredCategories)); 
    } catch (e) {
      emit(FoodCategoryError(e.toString())); 
    }
  }

  Future<void> _onSetInitialCategories(SetInitialCategoriesEvent event, Emitter<FoodCategoryState> emit) async {
    final categories = await categoryRepository.getAllCategories();
    selectedCategories = event.initialCategories;
    emit(FoodCategorySelected(categories, selectedCategories));
  }
}
