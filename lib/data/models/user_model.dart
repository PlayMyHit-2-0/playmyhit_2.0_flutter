import 'package:firebase_auth/firebase_auth.dart';
import 'package:playmyhit/data/enumerations/account_types.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String firstName;
  final String lastName;
  final String username;
  final bool isAccountDisabled;
  final AccountType accountType;
  final UserCredential? userCredential;

  // Constructor
  UserModel({required this.uid, required this.email, required this.isAccountDisabled, required this.accountType, required this.username, required this.lastName, required this.firstName, required this.userCredential});

  // Get some json from a UserModel
  Map<String,dynamic> toJson() => {
    "uid" : uid,
    "email" : email,
    "isAccountDisabled" : isAccountDisabled,
    "accountType" : accountType,
  };

  // Make a UserModel from some json
  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        email = json['email'],
        isAccountDisabled = json['isAccountDisabled'],
        accountType = json['accountType'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        username = json['username'],
        userCredential = null;
}