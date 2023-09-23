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