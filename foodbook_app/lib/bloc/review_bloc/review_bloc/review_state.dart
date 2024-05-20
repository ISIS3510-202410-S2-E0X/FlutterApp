import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodbook_app/data/models/review.dart';

@immutable
abstract class ReviewState extends Equatable {}

class InitialState extends ReviewState {
  @override
  List<Object> get props => [];
}

class ReviewLoading extends ReviewState {
  @override
  List<Object> get props => [];
}

class ReviewCreateSuccess extends ReviewState {
  final String reviewId;

  ReviewCreateSuccess(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}

class ReviewError extends ReviewState {
  final String error;

  ReviewError(this.error);
  @override
  List<Object?> get props => [error];
}

class ReviewFetchUserReviewsSuccess extends ReviewState {
  final List<Review> userReviews;

  ReviewFetchUserReviewsSuccess(this.userReviews);

  @override
  List<Object> get props => [userReviews];
}