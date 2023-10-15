part of 'profile_bloc.dart';

sealed class ProfileEvent {}

final class ProfileInitialEvent extends ProfileEvent {}

final class LoadPeerProfileEvent extends ProfileEvent {
  final String uid;
  LoadPeerProfileEvent({required this.uid});
}

final class ScrollToTopEvent extends ProfileEvent {}