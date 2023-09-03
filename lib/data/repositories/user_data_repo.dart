import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/models/user_model.dart';

class UserDataRepo {
  final FirebaseFirestore firestore;
  UserDataRepo({required this.firestore});

  Future<bool> checkUsernameAvailable(String username) async {
    try{
      // Prevent empty usernames
      if(username.isEmpty){
        return false;
      }

      // Prevent usernames less that 6 characters long
      if(username.length < 6){
        return false;
      }

      // Allow usernames with only alphanumeric characters
      var validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
      if(!validCharacters.hasMatch(username)){
        throw Exception("The username must be alphanumeric. No special characters other than letters and numbers are allowed.");
      }




      // if(username.contains())

      // Generate an aggregated query to count the number of users with the username matching the one passed in.
      AggregateQuerySnapshot countSnapshot = await firestore.collection("users").where('username', isEqualTo: username).count().get();
      if(kDebugMode){
        print("Ran query to check how many accounts have the username $username");
        print("Number of accounts matching that username: ${countSnapshot.count}");
      }
      // If the count is greater than 0
      if(countSnapshot.count > 0){
        return false; // Then the username is not available.
      }else{
        return true; // Otherwise it's available.
      }
    }catch(e){
      if(kDebugMode){
        print("Error found while attempting to check if a username is available in the user data repo.");
        print(e);
      }
      return Future.value(false);
    }
  }

  Future<bool> addUser(UserModel userModel) async {
    try {
      CollectionReference users = firestore.collection('users');
      await users.add(userModel.toJson());
      return Future.value(true);
    }catch (e){
      if(kDebugMode){
        print("Error found while attempting to add a user to firestore: ${e}");
      }
      return Future.value(false);
    }
  }

  Future<bool> updateUser(UserModel userModel) async {
    try {
      CollectionReference users = firestore.collection('users');
      await users.doc(userModel.uid).update(userModel.toJson());
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try{
      AggregateQuerySnapshot countSnapshot = await firestore.collection("users").where('email', isEqualTo: email).count().get();

      if(countSnapshot.count > 0){ // There is at least one email address in the database that matches this one.
      // Therefore the account is not available.
        return Future.value(false);
      }else{ // The email address is available.
        return Future.value(true); 
      }
    }catch(e){ // if we catch an exception 
      if(kDebugMode){
        print("Error from the user_data_repo.dart file: \n$e");
      }
      // Return false.
      return Future.value(false);
    }
  }
}

