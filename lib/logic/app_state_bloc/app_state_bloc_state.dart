part of 'app_state_bloc_bloc.dart';

@immutable
sealed class AppStateBlocState {}

final class AppStateBlocInitialState extends AppStateBlocState {}

abstract class AppStateBlocActionState extends AppStateBlocState {}
final class AppStateLoggedInState extends AppStateBlocActionState {
  final UserCredential loggedInUser;
  AppStateLoggedInState({required this.loggedInUser});
}

final class AppStateLoggedOutState extends AppStateBlocActionState{}


abstract class AppStateErrorState extends AppStateBlocActionState{
  final String error;
  AppStateErrorState({required this.error});
}

final class AppStateLoginErrorState extends AppStateErrorState{
  AppStateLoginErrorState({required super.error});
}

final class AppStateRegistrationErrorState extends AppStateErrorState{
  AppStateRegistrationErrorState({required super.error});
}

final class AppStateUsernameSelectionErrorState extends AppStateErrorState {
  AppStateUsernameSelectionErrorState({required super.error});
}

final class AppStateInitialState extends AppStateBlocState{}
final class AppStateBlocLoggedInEvent extends AppStateBlocState {}
final class AppStateRecoveryEmailRequestEmailSentState extends AppStateBlocActionState {}
final class AppStateBlocNavigateToUsernameSelectionScreenState extends AppStateBlocActionState {
  final String username;
  final bool available;
  AppStateBlocNavigateToUsernameSelectionScreenState({required this.username, required this.available});
}

final class AppStateBlocUpdateUsernameAvailabilityState extends AppStateBlocState {
  final String username;
  final bool available;
  AppStateBlocUpdateUsernameAvailabilityState({required this.username, required this.available});
}

// YALL GO CHECK OUT OGPINE on Facebook.  <<<<<-------- Ya heard right.

final class UsernameLoadingState extends AppStateBlocState {}

final class AppStateUsernameSelectionAvailabilityState extends AppStateBlocState {
  final bool available;
  AppStateUsernameSelectionAvailabilityState({required this.available});
}

final class AppStateNavigateToSettingsScreenState extends AppStateBlocActionState {}
