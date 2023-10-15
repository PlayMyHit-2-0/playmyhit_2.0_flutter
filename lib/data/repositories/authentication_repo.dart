import 'package:firebase_auth/firebase_auth.dart';
import 'package:playmyhit/data/models/authentication_request_response.dart';
import 'package:playmyhit/data/models/registration_form_data_model.dart';

class AuthenticationRepository {
    final FirebaseAuth auth;
    AuthenticationRepository({required this.auth});
    
    UserCredential? currentUser;
    RegistrationFormDataModel? registrationFormData;
    
    

    Future<AuthenticationRequestResponse> attemptLogin(String email, String password) async {
      // print("Recieved login authentication request in the authentication repository.");
      try {
        AuthenticationRequestResponse loginRequest = AuthenticationRequestResponse(
          exception: null,
          credentials: await auth.signInWithEmailAndPassword(email: email, password: password)
        );
        // print("Processed login request returning login rquest to the bloc");

        return Future.value(loginRequest);
      }on FirebaseAuthException catch  (e) {
        // print("Recieved an error while attempting to login from the authentication repository.");
        print(e.code);
        AuthenticationRequestResponse loginRequest = AuthenticationRequestResponse(
          exception: e,
          credentials: null
        );
        return Future.value(loginRequest);
      } catch (e){
        // print("Recieved unknown error while attempting to login from the authentication repository.");
        AuthenticationRequestResponse loginRequest = AuthenticationRequestResponse(
          exception: FirebaseAuthException(message: e.toString(), code: 'unknown-error-found'),
          credentials: null
        );
        return Future.value(loginRequest);
      }
    }

    Future<AuthenticationRequestResponse> attemptRegistration(String email, String password) async {
      try {
        AuthenticationRequestResponse registrationRequest = AuthenticationRequestResponse(
          exception: null,
          credentials: await auth.createUserWithEmailAndPassword(email: email, password: password)
        );

        return Future.value(registrationRequest);
      }on FirebaseAuthException catch (e) {
        AuthenticationRequestResponse registrationRequest = AuthenticationRequestResponse(
          exception: e,
          credentials: null
        );

        return Future.value(registrationRequest);
      }
    }

    Future<Map<String, dynamic>> sendRecoveryEmail(String email) async {
      // print("Sending recovery email from the authentication repo.");
      try {
        await auth.sendPasswordResetEmail(email: email);
        // print("Authentication recovery email sent from the authentication repo.");
        return {
          "success" : true,
          "error" : null
        };
      } on FirebaseAuthException catch (e){ 
        // print("Error found while attempting to send recovery email through the authentication repo.");
        print(e.code);
        // throw Exception(e.toString());
        return {
          "success" : false,
          "error" : e.code 
        };
      }
    }

    Future<Map<String,dynamic>> attemptLogout() async {
      print("Recieved a logout request in the authentication repo from the bloc.");
      try{
        await auth.signOut();
        currentUser = null; // Clear out the current user.
        print("Successfully logged out the user from the authentication repo. Returning success back to the bloc.");
        return {
          "success" : true,
          "error" : null
        };
      }on FirebaseAuthException catch (e){
        return {
          "success" : false,
          "error" : e.code
        };
      } catch (e){
        return {
          "success" : false,
          "error" :  e.toString()
        };
      }
    }

    void dispose() {
    
    }
}