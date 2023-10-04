part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {
  final PostMode mode;
  PostInitial({required this.mode});
}

final class PostLoadingState extends PostState {
  final PostMode mode;
  PostLoadingState({required this.mode});
}

final class ExistingPostLoadedState extends PostState {
  final Post post;    
  ExistingPostLoadedState({required this.post});
}

final class NewPostState extends PostState {}



// Action States
abstract class PostActionState extends PostState {}

final class PostErrorState extends PostActionState {
  final String error;
  PostErrorState({required this.error});
}

final class PostSavedState extends PostActionState {}

<<<<<<< HEAD
final class PostShowImageUploadUIState extends PostState {
  final List<File>? postAttachments;
  PostShowImageUploadUIState({required this.postAttachments});
}
=======
final class PostShowImageUploadUIState extends PostState {}
>>>>>>> 8563dce45b28e2f02b79407790e3e04301851445

final class PostUpdatedContentTextState extends PostState {
  final String newPostContentText;
  PostUpdatedContentTextState({required this.newPostContentText});
}