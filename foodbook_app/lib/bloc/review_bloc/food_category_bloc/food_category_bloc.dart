import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';
import 'package:foodbook_app/data/repositories/category_repository.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  final CategoryRepository categoryRepository;
  final int maxSelection;
  List<CategoryDTO> selectedCategories = [];

  FoodCategoryBloc({required this.categoryRepository, required this.maxSelection})
      : super(InitialState()) {
    on<SelectCategoryEvent>(_onSelectCategory);
    on<DeselectCategoryEvent>(_onDeselectCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadSelectedCategoriesEvent>(_onLoadSelectedCategories);
    
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
    } else {
      emit(FoodCategoryMaxSelectionReached());
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
}
