part of 'post_bloc.dart';

sealed class PostEvent {}

final class PostInitialEvent extends PostEvent {}

final class LoadPostEvent extends PostEvent{
  final String postId;
  final String uid;
  LoadPostEvent({required this.postId, required this.uid});
}

final class SavePostEvent extends PostEvent {
  final Post post;
  SavePostEvent({required this.post});
}

final class NewPostEvent extends PostEvent {}

<<<<<<< HEAD
final class PostAddImageAttachmentEvent extends PostEvent {

}

final class SetPostImageAttachmentEvent extends PostEvent{
  
}
=======
final class PostAddImageAttachmentEvent extends PostEvent {}
>>>>>>> 8563dce45b28e2f02b79407790e3e04301851445

final class PostUpdatePostContentText extends PostEvent {
  final String postContentText;
  PostUpdatePostContentText({required this.postContentText});
}