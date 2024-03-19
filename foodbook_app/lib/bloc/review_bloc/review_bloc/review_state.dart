import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ReviewState extends Equatable {}

class InitialState extends ReviewState {
  @override
  List<Object> get props => [];
}

class ReviewAdding extends ReviewState {
  @override
  List<Object> get props => [];
}

class ReviewAdded extends ReviewState {
  @override
  List<Object> get props => [];
}

class ReviewError extends ReviewState {
  final String error;

  ReviewError(this.error);
  @override
  List<Object?> get props => [error];
}
