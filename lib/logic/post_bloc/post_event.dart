part of 'post_bloc.dart';

sealed class PostEvent {}

class PostInitialEvent extends PostEvent {
  final PostMode postMode;
  PostInitialEvent({required this.postMode});
}

class LoadPostEvent extends PostEvent{
  final String postId;
  final String uid;
  LoadPostEvent({required this.postId, required this.uid});
}

class SavePostEvent extends PostEvent {
  final Post post;
  SavePostEvent({required this.post});
}

class PostAddImageAttachmentEvent extends PostEvent {}

class PostAddVideoAttachmentEvent extends PostEvent {}

class PostUpdatePostContentText extends PostEvent {
  final String postContentText;
  PostUpdatePostContentText({required this.postContentText});
}

class PostDeleteAttachmentEvent extends PostEvent {
  final File? selectedAttachmentFile;
  PostDeleteAttachmentEvent({required this.selectedAttachmentFile});
}

class PostAttachmentsSelectedEvent extends PostEvent {
  final List<File> selectedAttachments;
  final AttachmentType type;
  PostAttachmentsSelectedEvent({required this.selectedAttachments, required this.type});
}

class PostVideoLoadingEvent extends PostEvent {
  final String status;
  PostVideoLoadingEvent({required this.status});
}


