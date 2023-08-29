import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRequestResponse {
  FirebaseAuthException? exception;
  UserCredential? credentials;

  AuthenticationRequestResponse({this.exception, this.credentials});
}