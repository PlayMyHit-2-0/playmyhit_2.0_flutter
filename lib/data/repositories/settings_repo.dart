import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/enumerations/profile_visibility.dart';
import 'package:playmyhit/data/models/user_profile_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

enum ImageType {
  profilePicture,
  profileBanner
}

class SettingsRepository{
  UserProfileDataModel settingsDataModel;
  FirebaseStorage storage;
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  SettingsRepository({required this.settingsDataModel, required this.storage, required this.auth, required this.firestore}); 

  Future<UploadTask?> uploadImageFile(File file, ImageType imageType) async{
    if(auth.currentUser != null){
      if(imageType == ImageType.profilePicture){
        return storage.ref("${auth.currentUser?.uid}/profile_image/profile_image.jpeg").putFile(file);
      }else {
        return storage.ref("${auth.currentUser?.uid}/profile_banner/profile_banner.jpeg").putFile(file);
      }
      
    }else{
      return null;
    }
  }

  /*
    Retrieves a byte array of the image file
    Generates a temporary directory depending on the ImageType
    and then stores the byte array as a File in the temporary directory
    Returns an instance of File with the image loaded into it.
  */
  Future<File?> getImageFileFromPath(String path,ImageType type) async {
    if(path.isNotEmpty){
      final http.Response responseData = await http.get(Uri.parse(path));
      var uint8list = responseData.bodyBytes;
      var buffer = uint8list.buffer;
      ByteData byteData = ByteData.view(buffer);
      var tempDir = await getTemporaryDirectory();

      switch(type){
        case ImageType.profileBanner:
      
          File file = await File('${tempDir.path}/profileBanner').writeAsBytes(
              buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          return file;
        case ImageType.profilePicture:
          File file = await File('${tempDir.path}/profilePic').writeAsBytes(
              buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          return file;
        default:
          File file = await File('${tempDir.path}/random_tmp_image').writeAsBytes(
              buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          return file;
      }
    }else{
      return null;
    }
  }

  /*
    Retrieves the settings data model for the currently logged in user.
    Uses the FirebaseAuth.instance to determine the currently logged in user.
  */
  Future<UserProfileDataModel?> getUserProfileDataModel() async{
    const String defaultProfileImageUrl = "https://firebasestorage.googleapis.com/v0/b/playmyhitdev.appspot.com/o/assets%2Fdefault_profile_image.jpg?alt=media&token=9f8c85d4-7f44-47e5-b03d-0ad00e11e31a";
    const String defaultProfileBannerImageUrl = "https://firebasestorage.googleapis.com/v0/b/playmyhitdev.appspot.com/o/assets%2Fdefault_profile_banner.png?alt=media&token=8327ac66-978a-42c8-a228-e51e26c46155";
    try {

      if(kDebugMode){
        print("Getting settings data model from firestore..");
        print("User Id: ${auth.currentUser!.uid}");
      }

      // return await firestore.runTransaction((transaction) async {
        DocumentReference ref = firestore.doc("/users/${auth.currentUser!.uid}");
        // DocumentSnapshot snapshot = await transaction.get(ref);
        DocumentSnapshot snapshot = await ref.get();
        
        Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;

        if(kDebugMode){
          print("Retrieved the followng profile data model from firestore.");
          print(data);
        }

        UserProfileDataModel dataModel = UserProfileDataModel(
          username: data["username"], 
          profileBannerImageUrl: data["settings"]["profileBannerUrl"] ?? defaultProfileBannerImageUrl, 
          profileImageUrl: data["settings"]["profileImageUrl"] ?? defaultProfileImageUrl,
          profileVisibility: data["settings"]["profileIsPrivate"] ? ProfileVisibility.private : ProfileVisibility.public, 
          profileIntroduction: data["settings"]["profileDescription"] ?? "", 
          allowFriendRequests: data["settings"]["allowFriendRequests"] ?? true, 
          allowCommentsGlobal: data["settings"]["allowComments"] ?? false,
          country: data["settings"]["country"],
          state: data["settings"]["state"],
          city: data["settings"]["city"]
        );

        // Update the local version of the settings data model
        settingsDataModel = dataModel;

        return dataModel;
      // });
    }catch(e){
      if (kDebugMode) {
        print("Found error while attempting to retrieve the user settings from firestore.");
        print(e.toString());
      }
      rethrow;
    }
  }
  
  /*
    Update the profile image url in firestore user profile
  */
  Future<bool> updateProfileImageUrl(String newProfileImageUrl) async {
    
    try{
      // auth.currentUser?.updatePhotoURL(newProfileImageUrl);
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update(
          {
            "settings" : {
              "profileImageUrl" : newProfileImageUrl,
              "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
              "allowComments" : settingsDataModel.allowCommentsGlobal,
              "allowFriendRequests" : settingsDataModel.allowFriendRequests,
              "profileDescription" : settingsDataModel.profileIntroduction,
              "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
              "country" : settingsDataModel.country,
              "state" : settingsDataModel.state,
              "city" : settingsDataModel.city
            }
          }
        );
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating the profile image url for the user profile data in firestore at the settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }

  /*
    Update the profile banner url in firestore user profile
  */
  Future<bool> updateProfileBannerUrl(String newProfileBannerUrl) async {
    try {
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update(
          {
            "settings" : {
              "profileImageUrl" : settingsDataModel.profileImageUrl,
              "profileBannerUrl" : newProfileBannerUrl,
              "allowComments" : settingsDataModel.allowCommentsGlobal,
              "allowFriendRequests" : settingsDataModel.allowFriendRequests,
              "profileDescription" : settingsDataModel.profileIntroduction,
              "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
              "country" : settingsDataModel.country,
              "state" : settingsDataModel.state,
              "city" : settingsDataModel.city
            }
          }
        );
        return true;
      }); 
    }catch(e){
      if(kDebugMode){
        print("There was an error while udpdting the profile banner image url for the user profile data in firestore at the settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }


  /*
    Update the profile description in firestore user profile
  */
  Future<bool> updateProfileDescription(String newDescription) async {
    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
            "allowComments" : settingsDataModel.allowCommentsGlobal,
            "allowFriendRequests" : settingsDataModel.allowFriendRequests,
            "profileDescription" : newDescription,
            "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
            "country" : settingsDataModel.country,
            "state" : settingsDataModel.state,
            "city" : settingsDataModel.city
          }
        });
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating the profile description for the user profile data in firestore at the settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }

  /*
    Update the profile visibility in firestore user profile
  */
  Future<bool> updateProfileVisibility(ProfileVisibility newVisibility) async {
    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
            "allowComments" : settingsDataModel.allowCommentsGlobal,
            "allowFriendRequests" : settingsDataModel.allowFriendRequests,
            "profileDescription" : settingsDataModel.profileIntroduction,
            "profileIsPrivate" : newVisibility == ProfileVisibility.private ? true : false,
            "country" : settingsDataModel.country,
            "state" : settingsDataModel.state,
            "city" : settingsDataModel.city
          }
        });
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating profile visibility in firestore user profile");
        print(e.toString());
      }
      rethrow;
    }
  }

  /*
    Update the profile allow friend requests flag in firestore user profile
  */
  Future<bool> updateAllowFriendRequests(bool allowFriendRequests) async {
    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
            "allowComments" : settingsDataModel.allowCommentsGlobal,
            "allowFriendRequests" : allowFriendRequests,
            "profileDescription" : settingsDataModel.profileIntroduction,
            "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
            "country" : settingsDataModel.country,
            "state" : settingsDataModel.state,
            "city" : settingsDataModel.city
          }
        });
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating the profile allow friend requests frlag in firestore user profile from settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }

  /*
    Update the profile allow comments flag in firestore user profile
  */
  Future<bool> updateAllowComments(bool allowComments) async {
    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
            "allowComments" : allowComments,
            "allowFriendRequests" : settingsDataModel.allowFriendRequests,
            "profileDescription" : settingsDataModel.profileIntroduction,
            "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
            "country" : settingsDataModel.country,
            "state" : settingsDataModel.state,
            "city" : settingsDataModel.city
          }
        });
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating the profile allow comments frlag in firestore user profile from settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }

  /*
    Update the profile country value in firestore
  */
  Future<bool> updateCountry(String country) async{
    
    if(kDebugMode){
      print("Updating the country value in firestore from the settings repository with the value $country");
    }

    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
            "allowComments" : settingsDataModel.allowCommentsGlobal,
            "allowFriendRequests" : settingsDataModel.allowFriendRequests,
            "profileDescription" : settingsDataModel.profileIntroduction,
            "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
            "country" : country.isEmpty ? null : country,
            "state" : null,
            "city" : null,
          }
        });
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating the country value in firestore from the settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }

  /*
    Update the profile state value in firestore
  */
  Future<bool> updateState(String? state) async{
    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
            "allowComments" : settingsDataModel.allowCommentsGlobal,
            "allowFriendRequests" : settingsDataModel.allowFriendRequests,
            "profileDescription" : settingsDataModel.profileIntroduction,
            "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
            "country" : settingsDataModel.country,
            "state" : state,
            "city" : null,
          }
        });
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating the state value in firestore from the settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }


  /*
    Update the profile city value in firestore
  */
  Future<bool> updateCity(String city) async{
    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "profileBannerUrl" : settingsDataModel.profileBannerImageUrl,
            "allowComments" : settingsDataModel.allowCommentsGlobal,
            "allowFriendRequests" : settingsDataModel.allowFriendRequests,
            "profileDescription" : settingsDataModel.profileIntroduction,
            "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false,
            "country" : settingsDataModel.country,
            "state" : settingsDataModel.state,
            "city" : city
          }
        });
        return true;
      });
    }catch(e){
      if(kDebugMode){
        print("There was an error while updating the city value in firestore from the settings repository.");
        print(e.toString());
      }
      rethrow;
    }
  }
} 