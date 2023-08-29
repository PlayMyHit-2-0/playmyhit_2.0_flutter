part of 'app_state_bloc_bloc.dart';

@immutable
sealed class AppStateBlocEvent {}

class NavigateToRegistrationScreenEvent extends AppStateBlocEvent {}

final class AttemptAuthenticationLoginEvent extends AppStateBlocEvent {
  final String username;
  final String password;
  AttemptAuthenticationLoginEvent({required this.username, required this.password});
}

final class AttemptAuthenticationLogoutEvent extends AppStateBlocEvent {}

final class AttemptAuthenticationRegisterEvent extends AppStateBlocEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool isCreator;
  final bool agreedToRecieveNewsletter;
  final bool agreedToTermsAndConditions;

  AttemptAuthenticationRegisterEvent({
    required this.firstName, 
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.isCreator,
    required this.agreedToRecieveNewsletter,
    required this.agreedToTermsAndConditions
  });
}

final class AppStateBlocInitialEvent extends AppStateBlocEvent {}

final class SendRecoveryEmailEvent extends AppStateBlocEvent{
  final String email;
  SendRecoveryEmailEvent({required this.email});
}

final class StoreRegistrationFormInRepositoryEvent extends AppStateBlocEvent {
  final RegistrationFormDataModel dataModel;
  StoreRegistrationFormInRepositoryEvent({required this.dataModel});
}

final class AppStateUpdateSelectedUsernameEvent extends AppStateBlocEvent{
  final String selectedUsername;
  AppStateUpdateSelectedUsernameEvent({required this.selectedUsername});
}

final class AppStateNavigateToSettingsScreenEvent extends AppStateBlocEvent {

}

final class AppStateAttemptSignOutEvent extends AppStateBlocEvent {}