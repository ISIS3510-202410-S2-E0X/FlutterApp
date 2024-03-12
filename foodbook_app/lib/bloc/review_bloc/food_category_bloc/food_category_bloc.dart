import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/models/category.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_event.dart';
import 'package:foodbook_app/bloc/review_bloc/food_category_bloc/food_category_state.dart';
import 'package:foodbook_app/data/repositories/category_repository.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  final int maxSelection;
  final CategoryRepository categoryRepository;
  List<CategoryModel> selectedCategories = [];

  FoodCategoryBloc({required this.categoryRepository, required this.maxSelection})
      : super(InitialState()) {
    on<SelectCategoryEvent>(_onSelectCategory);
    on<DeselectCategoryEvent>(_onDeselectCategory);
    on<LoadCategoriesEvent>(_onLoadCategories);

    // Agrega este evento para iniciar la carga de categorías al crear el bloc
    add(LoadCategoriesEvent());
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
      // Si se ha alcanzado el máximo de selecciones permitidas, se podría manejar este caso aquí.
      // Por ejemplo, podrías emitir un estado que indique que se alcanzó el máximo de selecciones,
      // aunque esto requeriría definir un nuevo estado o utilizar uno existente apropiado.
      return;
    }

    selectedCategories.firstWhere((category) => category.name == event.category);
    selectedCategories.add(CategoryModel(name: event.category));
    emit(FoodCategoryLoaded(selectedCategories));
  }

  void _onDeselectCategory(DeselectCategoryEvent event, Emitter<FoodCategoryState> emit) {
    final indexToRemove = selectedCategories.indexWhere((category) => category.name == event.category);
    if (indexToRemove != -1) {
      selectedCategories.removeAt(indexToRemove);
      emit(FoodCategoryLoaded(selectedCategories)); // Actualiza el estado con la lista modificada
    }
  }
}
