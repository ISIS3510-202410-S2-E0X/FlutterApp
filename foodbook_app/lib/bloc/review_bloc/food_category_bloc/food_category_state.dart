// class FoodCategoryState {
//   final List<String> selectedCategories;

//   FoodCategoryState(this.selectedCategories);
// }
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodbook_app/data/models/category.dart';

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
  List<CategoryModel> data;
  FoodCategoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class FoodCategoryError extends FoodCategoryState {
  final String error;

  FoodCategoryError(this.error);
  
  @override
  List<Object?> get props => [error];
}
