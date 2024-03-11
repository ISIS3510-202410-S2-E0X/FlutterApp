import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodbook_app/data/models/category.dart';

@immutable
abstract class CategoryState extends Equatable {}

class InitialState extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryLoading extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryLoaded extends CategoryState {
  List<CategoryModel> data;
  CategoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CategoryError extends CategoryState {
  final String error;

  CategoryError(this.error);
  
  @override
  List<Object?> get props => [error];
}