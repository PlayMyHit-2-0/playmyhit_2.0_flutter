part of 'post_images_bloc.dart';

@immutable
sealed class PostImagesBlocState {}

final class PostImagesBlocInitial extends PostImagesBlocState {
  final List<File>? selectedImages;
  PostImagesBlocInitial({required this.selectedImages});
}

abstract class PostImagesBlocActionState extends PostImagesBlocState{}

final class PostImagesBlocSelectedImageState extends PostImagesBlocState {
  final List<File>? selectedImages;
  PostImagesBlocSelectedImageState({required this.selectedImages});
}

class PostImagesBlocImageAlreadyAddedState extends PostImagesBlocActionState{}

class PostAddImageLoadingState extends PostImagesBlocState{}

class PostDeletedImageState extends PostImagesBlocState{
  final List<File>? selectedImages;
  PostDeletedImageState({required this.selectedImages});
}

class PostImagesBlocErrorState extends PostImagesBlocActionState {
  final String error;
  PostImagesBlocErrorState({required this.error});
}

class PostImagesBlocAttachToPostState extends PostImagesBlocActionState{}