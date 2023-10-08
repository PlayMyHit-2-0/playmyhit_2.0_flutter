part of 'post_bloc.dart';

@immutable
sealed class PostState {}

class PostInitial extends PostState {
  final PostMode mode;
  PostInitial({required this.mode});
}

class PostLoadingState extends PostState {
  final PostMode mode;
  PostLoadingState({required this.mode});
}

class ExistingPostLoadedState extends PostState {
  final Post post;    
  ExistingPostLoadedState({required this.post});
}

class NewPostState extends PostState {}

// Action States
abstract class PostActionState extends PostState {}

class PostErrorState extends PostActionState {
  final String error;
  PostErrorState({required this.error});
}

class PostSavedState extends PostActionState {}

class PostShowImageUploadUIState extends PostState {
  final List<File>? postAttachments;
  PostShowImageUploadUIState({required this.postAttachments});
}

class PostShowVideoUploadUIState extends PostState {
  final List<File>? postAttachments;
  PostShowVideoUploadUIState({required this.postAttachments});
}

class PostUpdatedContentTextState extends PostState {
  final String newPostContentText;
  PostUpdatedContentTextState({required this.newPostContentText});
}
