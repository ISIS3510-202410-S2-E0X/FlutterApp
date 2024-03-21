import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ImageUploadEvent extends Equatable {
  const ImageUploadEvent();

  @override
  List<Object> get props => [];
}

class ImageUploadRequested extends ImageUploadEvent {
  final File image;

  const ImageUploadRequested(this.image);

  @override
  List<Object> get props => [image];
}

class ImageRequested extends ImageUploadEvent {
  final String imagePath;

  const ImageRequested(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}
