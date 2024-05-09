import 'package:foodbook_app/data/models/reviewdraft.dart';

abstract class ReviewDraftState {}

class ReviewInitial extends ReviewDraftState {}

class ReviewLoading extends ReviewDraftState {}

class ReviewLoaded extends ReviewDraftState {
  final List<ReviewDraft> drafts;
  ReviewLoaded(this.drafts);
}

class ReviewToUploadLoaded extends ReviewDraftState {
  final List<ReviewDraft> drafts;
  ReviewToUploadLoaded(this.drafts);
}

class ReviewDraftLoaded extends ReviewDraftState {
  final ReviewDraft draft;
  ReviewDraftLoaded(this.draft);
}

class UnfinishedDraftExists extends ReviewDraftState {
  final bool exists;
  UnfinishedDraftExists(this.exists);
}

class NoUnifishedReviews extends ReviewDraftState {}

class ReviewError extends ReviewDraftState {}