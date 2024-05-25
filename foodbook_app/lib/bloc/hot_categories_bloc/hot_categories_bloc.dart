import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/hot_categories_bloc/hot_categories_event.dart';
import 'package:foodbook_app/bloc/hot_categories_bloc/hot_categories_state.dart';
import 'package:foodbook_app/data/repositories/hot_categories_manager.dart';

class HotCategoriesBloc extends Bloc<HotCategoriesEvent, HotCategoriesState> {
  final HotCategoriesManager hotCategoriesManager;

  HotCategoriesBloc({
    required this.hotCategoriesManager,
  }) : super(HotCategoriesInitial()) {
    on<LoadHotCategories>(_onLoadHotCategories);
  }

  Future<void> _onLoadHotCategories(
    LoadHotCategories event, 
    Emitter<HotCategoriesState> emit
  ) async {
    emit(HotCategoriesLoadInProgress());
    try {
      List<String>? categories = await hotCategoriesManager.fetchAndSaveCategories();
      if (categories == null || categories.isEmpty) {
        // Try to get from cache
        categories = await hotCategoriesManager.getSavedCategories();
      }
      
      if (categories == null || categories.isEmpty) {
        emit(HotCategoriesLoadFailure(errorMessage: "Failed to load hot categories."));
      } else {
        emit(HotCategoriesLoaded(categories));
      }
    } catch (error) {
      emit(HotCategoriesLoadFailure(errorMessage: error.toString()));
    }
  }
}