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
          profileIntroduction: data["settings"]["profileDescription"], 
          allowFriendRequests: data["settings"]["allowFriendRequests"], 
          allowCommentsGlobal: data["settings"]["allowComments"]
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
              "allowComments" : settingsDataModel.allowCommentsGlobal,
              "allowFriendRequests" : settingsDataModel.allowFriendRequests,
              "profileDescription" : settingsDataModel.profileIntroduction,
              "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false
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
    Update the profile description in firestore user profile
  */
  Future<bool> updateProfileDescription(String newDescription) async {
    try{
      return await firestore.runTransaction((transaction) async {
        await firestore.doc("users/${auth.currentUser?.uid}").update({
          "settings" : {
            "profileImageUrl" : settingsDataModel.profileImageUrl,
            "allowComments" : settingsDataModel.allowCommentsGlobal,
            "allowFriendRequests" : settingsDataModel.allowFriendRequests,
            "profileDescription" : newDescription,
            "profileIsPrivate" : settingsDataModel.profileVisibility == ProfileVisibility.private ? true : false
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
}