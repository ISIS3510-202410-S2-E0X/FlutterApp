import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodbook_app/data/dtos/category_dto.dart';

@immutable
abstract class FoodCategoryState extends Equatable {}

class InitialState extends FoodCategoryState {
  @override
  List<Object?> get props => [];
}

class FoodCategoryLoading extends FoodCategoryState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class FoodCategoryLoaded extends FoodCategoryState {
  List<CategoryDTO> data;
  FoodCategoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class FoodCategorySelected extends FoodCategoryState {
  final List<CategoryDTO> allCategories;
  final List<CategoryDTO> selectedCategories;

  FoodCategorySelected(this.allCategories, this.selectedCategories);
  
  @override
  List<Object?> get props => [allCategories, selectedCategories];
}

class FoodCategoryMaxSelectionReached extends FoodCategoryState {
  final String message;

  FoodCategoryMaxSelectionReached({this.message = "Maximum category selections reached."});

  @override
  List<Object> get props => [message];
}

class FoodCategoryError extends FoodCategoryState {
  final String error;

  FoodCategoryError(this.error);
  
  @override
  List<Object?> get props => [error];
}
