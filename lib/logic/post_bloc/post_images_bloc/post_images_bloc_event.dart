part of 'post_images_bloc.dart';

@immutable
sealed class PostImagesBlocEvent {}

class PostImagesBlocSelectImageEvent extends PostImagesBlocEvent{
  final File selectedImage;
  PostImagesBlocSelectImageEvent({required this.selectedImage});
}

class PostImagesBlocDeleteImageEvent extends PostImagesBlocEvent{
  final File selectedImage;
  PostImagesBlocDeleteImageEvent({required this.selectedImage});
}

class PostImagesBlocAttachToPostEvent extends PostImagesBlocEvent {}

class PostImagesBlocLoadEvent extends PostImagesBlocEvent{}
