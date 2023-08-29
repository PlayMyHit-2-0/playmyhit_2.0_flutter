import 'package:firebase_auth/firebase_auth.dart';
import 'package:playmyhit/data/enumerations/account_types.dart';
import 'package:playmyhit/data/models/authentication_request_response.dart';
import 'package:playmyhit/data/models/user_model.dart';
import 'package:playmyhit/data/repositories/authentication_repo.dart';
import 'package:playmyhit/data/services/user_data_service.dart';

class AuthenticationService {
  final AuthenticationRepository authRepo;
  final UserDataService userService;
  AuthenticationService({required this.authRepo, required this.userService});

  Future<Map<String,dynamic>> attemptLogin(String username, String password) async {
    AuthenticationRequestResponse loginRequestResponse = await authRepo.attemptLogin(username, password);
    
    // Return a map with the data from the request.
    return {
      "exception" : loginRequestResponse.exception,
      "credentials" : loginRequestResponse.credentials
    };
  }

  Future<UserModel?> attemptRegistration(String email, String username, String password, String firstName, String lastName) async {
    try {
      AuthenticationRequestResponse authRequestResponse = await authRepo.attemptRegistration(email, password);

      if(authRequestResponse.credentials != null){
        UserModel userModel = UserModel(
          uid : authRequestResponse.credentials?.user?.uid,
          email : authRequestResponse.credentials?.user?.email,
          isAccountDisabled: true,
          username: username,
          lastName: lastName,
          firstName: firstName,
          accountType: AccountType.user,
          userCredential: authRequestResponse.credentials
        );

        await userService.saveUserData(userModel);

        return userModel;
      }else{
        // Handle the errors we know we have now
        FirebaseAuthException exception = authRequestResponse.exception!;
        print(exception.message);
        return null;
      }
    } catch (e){
      return null;
    }
  }

  Future<bool> sendRecoveryEmail(String email) async {
    try {
      await authRepo.auth.sendPasswordResetEmail(email: email);
      return true;
    }on FirebaseAuthException catch (e){
      print("Error found while sending recovery email: ${e.code} - ${e.message}");
      return false;
    }
  }

  void dispose() {
    
  }
}