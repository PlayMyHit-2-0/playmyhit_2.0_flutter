import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playmyhit/data/models/authentication_request_response.dart';
import 'package:playmyhit/data/models/registration_form_data_model.dart';
import 'package:playmyhit/data/repositories/authentication_repo.dart';
import 'package:playmyhit/data/repositories/user_data_repo.dart';
part 'app_state_bloc_event.dart';
part 'app_state_bloc_state.dart';

class AppStateBlocBloc extends Bloc<AppStateBlocEvent, AppStateBlocState> {
  final AuthenticationRepository authRepo;
  final UserDataRepo userDataRepo;
  AppStateBlocBloc({required this.authRepo, required this.userDataRepo}) : super(AppStateBlocInitialState()) {
    on<AppStateBlocInitialEvent>((event,emit){
      emit(AppStateBlocInitialState());
    });

    on<SendRecoveryEmailEvent>((event,emit) async {
      String email = event.email;
      // print("Sending recovery email to " + email);
      try{
        Map<String,dynamic> resp = await authRepo.sendRecoveryEmail(email);
        print("Email Sent From The Bloc? : ${resp["success"]}");
        if(resp["success"]){
          emit(AppStateRecoveryEmailRequestEmailSentState());
        }else{
          print("Emitting error state from the bloc");
          // Handle errors and emit 
          emit(AppStateLoginErrorState(error:resp["error"]));
        }
      } on FirebaseAuthException catch(e){
        print("Error caught in the bloc");
        emit(AppStateLoginErrorState(error: e.toString()));
      }
    });

    on< AttemptAuthenticationLoginEvent>((event,emit) async {

      print("Recieved event for authentication login attempt in the bloc.");
      var username = event.username;
      var password = event.password;
      try {
        AuthenticationRequestResponse resp = await authRepo.attemptLogin(username, password);
        print("Response from the authentication login request to the repository from the bloc:");
        print(resp.credentials);
        print(resp.exception);
        if(resp.exception != null){
          emit(AppStateLoginErrorState(error: resp.exception!.code));
        }else if(resp.credentials != null){
          authRepo.currentUser = resp.credentials;
          print("User has logged in successfully. Sending a logged in event to the ui from the bloc.");
          emit(AppStateLoggedInState(loggedInUser: authRepo.currentUser!));
        }
      } on FirebaseAuthException catch(e){
        // Emit an error state here with the code of the error only
        emit(AppStateLoginErrorState(error: e.code));
      }catch(e){
        emit(AppStateLoginErrorState(error: e.toString()));
      }
    });

    on<AttemptAuthenticationLogoutEvent>((event, emit) async {
      try{
        Map<String,dynamic> signoutRequest = await authRepo.attemptLogout();
        print("Back to the bloc: Here's the response from the authentication repo:");
        print(signoutRequest);
        if(signoutRequest["success"] == true){
          emit(AppStateLoggedOutState());
        }else if(signoutRequest["error"] != null){
          emit(AppStateLoginErrorState(error: signoutRequest["error"]));
        }
      }catch(e){
        emit(AppStateLoginErrorState(error: e.toString()));
      }
    });

    on<AttemptAuthenticationRegisterEvent>((event, emit) async {
      try {
        await authRepo.attemptRegistration(event.email, event.password);
      }catch(e){
        emit(AppStateLoginErrorState(error: e.toString()));
      }
    });

    on<StoreRegistrationFormInRepositoryEvent>((event, emit) async {
      try {
        // Save the registration data into the repository
        authRepo.registrationFormData = event.dataModel;

        // Here we do some checks to make sure the data is legit
        

        // Empty list of strings to store the errors
        List<String> errors = [];

        // Check the first name
        if(event.dataModel.firstName!.isEmpty){
          errors.add("You must provide a first name.");
        }else if(event.dataModel.firstName!.length < 2){ // Names must be at least 2 characters
          errors.add("Your first name must be at least 2 characters in length.");
        }

        // Check the last name
        if(event.dataModel.lastName!.isEmpty){
          errors.add("You must provide a last name.");
        }else if(event.dataModel.lastName!.length < 2){
          errors.add("Your last name must be at least 2 characters in length.");
        }

        // Check the email address 
        //TODO:  Maybe we can use a package to help us here? do some research

        // For now let's just use a regex check to match.
        final bool emailValid = 
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(event.dataModel.email!);

        if(!emailValid){
          errors.add("The email you provided is not valid.");
        }

        // Check the passwords
        if(event.dataModel.password!.isEmpty || event.dataModel.passwordConfirmation!.isEmpty){
          errors.add("You must provide a password and password confirmation.");
        }else if(event.dataModel.password! != event.dataModel.passwordConfirmation){
          errors.add("Your password and password confirmation do not match.");
        }else{
          // Check for valid passwords using regex for now. 
          // TODO: Do some research to see if there's a plug to help us with password confirmations.
          RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          if(!regex.hasMatch(event.dataModel.password!)){
            errors.add("Your password must contain at least 1 special character, 1 numeric character, 1 uppercase character, 1 lowercase character and be at least 8 character in length.");
          }
        }

        // Check that they agreed to the terms and conditions, the other switches are optional
        if(!event.dataModel.agreedToTermsAndConditions!){
          errors.add("In order to create an account for PlayMyHit 2.0 you must first agree to our terms and conditions. Please read them carefully before creating a new account.");
        }

        // Final check is to make sure that the email address is not already registered. If it is, then we'll throw an error here.
        bool emailAvailable = await userDataRepo.checkEmailExists(event.dataModel.email!);
        if(!emailAvailable){
          errors.add("The email address you provided is taken.");
        }

        print("Registration Checks:");
        print("Email available: $emailAvailable");

        if(errors.isEmpty){
          // Send then to the username selection screen
          emit(AppStateBlocNavigateToUsernameSelectionScreenState(
            username: authRepo.registrationFormData?.userName ?? "",
            available: authRepo.registrationFormData?.userName != null ? 
              await userDataRepo.checkUsernameAvailable(authRepo.registrationFormData!.userName!) : 
              false
          ));
        }else{
          // If there are errors we need to aggregate the errors into a single message and return it as a snackbar
          String errorMessage = "1 - ${errors.reduce((value, element) =>  "$value\n${errors.indexOf(element) + 1} - $element")}";
          emit(AppStateRegistrationErrorState(error: errorMessage));
        }

      }catch(e){
        emit(AppStateLoginErrorState(error: e.toString()));
      }
    });

    on<AppStateUpdateSelectedUsernameEvent>((event, emit) async {
      try {
        
        bool usernameAvailable = await userDataRepo.checkUsernameAvailable(event.selectedUsername);

        // if the username is available, update the user data model in the repository
        // We can use the ! operator since we know for sure we have the data at this point.
        authRepo.registrationFormData?.userName = event.selectedUsername;

        emit(AppStateBlocUpdateUsernameAvailabilityState(username: event.selectedUsername, available: usernameAvailable));
      }catch(e){
        emit(AppStateUsernameSelectionErrorState(error: e.toString()));
      }
    });

    on<AppStateAttemptSignOutEvent>((event, emit) async {
      try {
        await authRepo.attemptLogout();
        emit(AppStateLoggedOutState());
      }catch(e){
        emit(AppStateLoginErrorState(error: e.toString()));
      }
    });

    // on<AppStateNavigateToSettingsScreenEvent>((event, emit){
    //   emit(AppStateNavigateToSettingsScreenState());
    // });
  }
}
