part of 'post_bloc.dart';

@immutable
sealed class PostState {}

class PostInitial extends PostState {
  final PostMode mode;
  // final List<Attachment>? attachments;
  final List<Attachment>? imageAttachments;
  final List<Attachment>? videoAttachments;
  final List<Attachment>? audioAttachments;
  final List<Attachment>? pdfAttachments;
  final String? postContentText;
  PostInitial({required this.mode, required this.imageAttachments, required this.videoAttachments, required this.audioAttachments, required this.pdfAttachments, required this.postContentText});
}

class PostLoadingState extends PostState {
  final PostMode mode;
  PostLoadingState({required this.mode});
}

class ExistingPostLoadedState extends PostState {
  final Post post;    
  ExistingPostLoadedState({required this.post});
}

// Action States
abstract class PostActionState extends PostState {}

class PostErrorState extends PostActionState {
  final String error;
  PostErrorState({required this.error});
}

class PostSavedState extends PostActionState {}

class PostShowVideoPickerState extends PostActionState{}
class PostShowImagePickerState extends PostActionState{}

