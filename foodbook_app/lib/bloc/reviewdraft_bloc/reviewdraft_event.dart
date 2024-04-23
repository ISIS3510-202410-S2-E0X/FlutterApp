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

class UpdateDraft extends ReviewDraftEvent {
  final ReviewDraft draft;
  UpdateDraft(this.draft);
}

class DeleteDraft extends ReviewDraftEvent {
  final int id;
  DeleteDraft(this.id);
}