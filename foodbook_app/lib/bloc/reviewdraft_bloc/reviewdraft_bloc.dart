
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
    on<CheckUnfinishedDraft>(_onCheckUnfinishedDraft);
    on<AddDraftToUpload>(_onAddDraftToUpload);
    on<LoadDraftsToUpload>(_onLoadDraftsToUpload);
    on<DeleteDraftToUpload>(_onDeleteDraftsToUpload);
    on<UpdateUnfinishedReviewsCount>(_onUpdateUnfishedReviewsCount);
  }

  Future<void> _onLoadDrafts(LoadDrafts event, Emitter<ReviewDraftState> emit) async {
    emit(ReviewLoading());
    try {
      final drafts = await reviewDraftRepository.getAllDrafts();
      print(drafts);
      emit(ReviewLoaded(drafts));
    } catch (e) {
      emit(ReviewError());
    }
  }

  Future<void> _onLoadDraftsBySpot(LoadDraftsBySpot event, Emitter<ReviewDraftState> emit) async {
    emit(ReviewLoading());
    try {
      // await reviewDraftRepository.killDatabase();
      final drafts = await reviewDraftRepository.getDraftsBySpot(event.spot);
      emit(ReviewLoaded(drafts));
    } catch (e) {
      emit(ReviewError());
    }
  }

  Future<void> _onAddDraft(AddDraft event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.insertDraft(event.draft);
    print("Adding draft");
    //add(LoadDrafts());
  }

  Future<void> _onUpdateDraft(UpdateDraft event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.updateDraft(event.draft, event.spot);
    add(LoadDrafts());
  }

  Future<void> _onDeleteDraft(DeleteDraft event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.deleteDraft(event.spot);
    add(LoadDrafts());
  }

  Future<void> _onUpdateUnfishedReviewsCount(UpdateUnfinishedReviewsCount event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.updateUnifinishedDraftCount(event.spot, true);
  }

  Future<void> _onCheckUnfinishedDraft(CheckUnfinishedDraft event, Emitter<ReviewDraftState> emit) async {
    try {
      final drafts = await reviewDraftRepository.getDraftsBySpot(event.restaurant);
      if (drafts.isNotEmpty) {
        emit(UnfinishedDraftExists(drafts.isNotEmpty));
      } else {
        emit(NoUnifishedReviews());
      }
    } catch (e) {
      emit(ReviewError());
    }
  }

  Future<void> _onAddDraftToUpload(AddDraftToUpload event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.insertDraftsToUpload(event.draft);
    add(LoadDrafts());
  }

  Future<void> _onDeleteDraftsToUpload(DeleteDraftToUpload event, Emitter<ReviewDraftState> emit) async {
    await reviewDraftRepository.deleteDraftsToUpload();
    add(LoadDrafts());
  }

  Future<void> _onLoadDraftsToUpload(LoadDraftsToUpload event, Emitter<ReviewDraftState> emit) async {
    emit(ReviewLoading());
    try {
      final drafts = await reviewDraftRepository.getAllDraftsToUpload();
      for (var draft in drafts) {
        print('DRAFTS: ${draft.spot}');
      }
      emit(ReviewToUploadLoaded(drafts));
    } catch (e) {
      emit(ReviewError());
    }
  }
  
}
