part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileLoadedState extends ProfileState {
  final List<Post> posts;
  ProfileLoadedState({required this.posts});
}

abstract class ProfileActionState extends ProfileState {}

final class ProfileErrorState extends ProfileActionState {
  final String error;
  ProfileErrorState({required this.error});
}

final class ProfileScrollToTopState extends ProfileActionState {}