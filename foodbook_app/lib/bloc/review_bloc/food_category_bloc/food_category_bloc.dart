import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/models/category.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';
import 'package:foodbook_app/data/repositories/category_repository.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  final int maxSelection;
  final CategoryRepository categoryRepository;
  List<CategoryModel> selectedCategories = [];

  FoodCategoryBloc(this.categoryRepository, {required this.maxSelection}) : super(InitialState()) {
    on<SelectCategoryEvent>(_onSelectCategory);
    on<DeselectCategoryEvent>(_onDeselectCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<FoodCategoryState> emit) async {
    emit(FoodCategoryLoading()); // Muestra un estado de carga
    try {
      final categories = await categoryRepository.getAllCategories(); // Carga las categorías
      emit(FoodCategoryLoaded(categories)); // Muestra las categorías cargadas
    } catch (e) {
    emit(FoodCategoryError(e.toString())); // Maneja cualquier error que pueda ocurrir
    }
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<FoodCategoryState> emit) {
    if (selectedCategories.length >= maxSelection && maxSelection != -1) {
      // Si se ha alcanzado el máximo de selecciones y se desea manejar este caso,
      // se podría emitir un estado específico o manejar de alguna otra manera.
      return;
    }

    final categoryToAdd = CategoryModel(name: event.category); // Adaptar según la creación real de CategoryModel
    if (!selectedCategories.any((category) => category.name == event.category)) {
      selectedCategories.add(categoryToAdd);
      emit(FoodCategoryLoaded(selectedCategories));
    }
  }

  void _onDeselectCategory(DeselectCategoryEvent event, Emitter<FoodCategoryState> emit) {
    selectedCategories.removeWhere((category) => category.name == event.category);
    emit(FoodCategoryLoaded(selectedCategories));
  }
}
