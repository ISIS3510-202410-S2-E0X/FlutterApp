import 'package:foodbook_app/data/models/reviewdraft.dart';

abstract class ReviewDraftState {}

class ReviewInitial extends ReviewDraftState {}

class ReviewLoading extends ReviewDraftState {}

class ReviewLoaded extends ReviewDraftState {
  final List<ReviewDraft> drafts;
  ReviewLoaded(this.drafts);
}

class ReviewDraftLoaded extends ReviewDraftState {
  final ReviewDraft draft;
  ReviewDraftLoaded(this.draft);
}

class ReviewError extends ReviewDraftState {}