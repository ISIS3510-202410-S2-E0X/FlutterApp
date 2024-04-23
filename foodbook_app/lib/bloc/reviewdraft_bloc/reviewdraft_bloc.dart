import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_event.dart';
import 'package:foodbook_app/bloc/reviewdraft_bloc/reviewdraft_state.dart';
import 'package:foodbook_app/data/repositories/reviewdraft_repository.dart';

class ReviewDraftBloc extends Bloc<ReviewDraftEvent, ReviewDraftState> {
  final ReviewDraftRepository reviewDraftRepository;

  ReviewDraftBloc(this.reviewDraftRepository) : super(ReviewInitial()) {
    on<LoadDrafts>(_onLoadDrafts);
    on<LoadDraftsBySpot>(_onLoadDraftsBySpot);
    on<AddDraft>(_onAddDraft);
    on<UpdateDraft>(_onUpdateDraft);
    on<DeleteDraft>(_onDeleteDraft);
  }

  Future<void> _onLoadDrafts(LoadDrafts event, Emitter<ReviewDraftState> emit) async {
    emit(ReviewLoading());
    try {
      final drafts = await reviewDraftRepository.getAllDrafts();
      emit(ReviewLoaded(drafts));
    } catch (e) {
      emit(ReviewError());
    }
  }

  Future<void> _onLoadDraftsBySpot(LoadDraftsBySpot event, Emitter<ReviewDraftState> emit) async {
    emit(ReviewLoading());
    try {
      final drafts = await reviewDraftRepository.getDraftsBySpot(event.spot);
      emit(ReviewLoaded(drafts));
    } catch (e) {
      emit(ReviewError());
    }
  }

  Future<void> _onAddDraft(AddDraft event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.insertDraft(event.draft);
    add(LoadDrafts());
  }

  Future<void> _onUpdateDraft(UpdateDraft event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.updateDraft(event.draft);
    add(LoadDrafts());
  }

  Future<void> _onDeleteDraft(DeleteDraft event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.deleteDraft(event.id);
    add(LoadDrafts());
  }
}
