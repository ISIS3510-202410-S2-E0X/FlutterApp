import 'package:foodbook_app/data/models/reviewdraft.dart';

abstract class ReviewDraftEvent {}

class LoadDrafts extends ReviewDraftEvent {}

class LoadDraftById extends ReviewDraftEvent {
  final int id;
  LoadDraftById(this.id);
}

class LoadDraftsBySpot extends ReviewDraftEvent {
  final String spot;
  LoadDraftsBySpot(this.spot);
}

class AddDraft extends ReviewDraftEvent {
  final ReviewDraft draft;
  AddDraft(this.draft);
}

class AddDraftToUpload extends ReviewDraftEvent {
  final ReviewDraft draft;
  AddDraftToUpload(this.draft);
}

class LoadDraftsToUpload extends ReviewDraftEvent {}

class UpdateDraft extends ReviewDraftEvent {
  final ReviewDraft draft;
  final String spot;
  UpdateDraft(this.draft, this.spot);
}

class DeleteDraft extends ReviewDraftEvent {
  final int id;
  DeleteDraft(this.id);
}

class CheckUnfinishedDraft extends ReviewDraftEvent {
  final String restaurant;
  CheckUnfinishedDraft(this.restaurant);
}