import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_event.dart';
import 'package:foodbook_app/bloc/review_bloc/image_upload_bloc/image_upload_state.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';

class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
  final ReviewRepository reviewRepository;

  ImageUploadBloc(this.reviewRepository) : super(ImageUploadInitial()) {
    on<ImageUploadRequested>(_onImageUploadRequested);
    on<ImageRequested>(_onImageRequested);
  }

  FutureOr<void> _onImageUploadRequested(ImageUploadRequested event, Emitter<ImageUploadState> emit) async {
    try {
      emit(ImageUploadInProgress());
      final imageUrl = await reviewRepository.saveImage(event.image);
      emit(ImageUploadSuccess(imageUrl));
    } catch (error) {
      emit(ImageUploadFailure(error.toString()));
    }
  }

  FutureOr<void> _onImageRequested(ImageRequested event, Emitter<ImageUploadState> emit) async {
    try {
      emit(ImageUploadInProgress());
      final imageUrl = await reviewRepository.getImage(event.imagePath);
      emit(ImageRetrievalSuccess(imageUrl as String));
    } catch (error) {
      emit(ImageUploadFailure(error.toString()));
    }
  }
}
