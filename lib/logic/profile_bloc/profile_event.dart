part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileInitialEvent extends ProfileEvent {
  List<Post> posts;
  ProfileInitialEvent({required this.posts});
}

final class LoadPeerProfileEvent extends ProfileEvent {
  final String uid;
  LoadPeerProfileEvent({required this.uid});
}

final class ScrollToTopEvent extends ProfileEvent {}

final class NavigateToMusicPageEvent extends ProfileEvent{}

final class NavigateToVideosPageEvent extends ProfileEvent{}

final class NavigateToPicturesPageEvent extends ProfileEvent {}
