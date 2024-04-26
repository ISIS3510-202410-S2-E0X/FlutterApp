import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial2 extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess2 extends SearchState {
  late final List<dynamic> results;

  @override
  List<Object> get props => [results];

  @override
  String toString() => 'SearchSuccess { results: $results }';
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchFailure { error: $error }';
}

