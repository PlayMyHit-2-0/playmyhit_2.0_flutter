import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/enumerations/profile_visibility.dart';
import 'package:playmyhit/data/models/settings_data_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

enum ImageType {
  profilePicture,
  profileBanner
}

class SettingsRepository{
  SettingsDataModel settingsDataModel;
  FirebaseStorage storage;
  FirebaseAuth auth;
  FirebaseFirestore firestore;
  SettingsRepository({required this.settingsDataModel, required this.storage, required this.auth, required this.firestore}); 

  Future<UploadTask?> uploadImageFile(File file) async{
    if(auth.currentUser != null){
      return storage.ref(auth.currentUser?.uid).putFile(file);
    }else{
      return null;
    }
  }


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

  Future<SettingsDataModel?> getSettingsDataModel() async{
    const String defaultProfileImageUrl = "https://firebasestorage.googleapis.com/v0/b/playmyhitdev.appspot.com/o/assets%2Fdefault_profile_image.jpg?alt=media&token=9f8c85d4-7f44-47e5-b03d-0ad00e11e31a";
    const String defaultProfileBannerImageUrl = "https://firebasestorage.googleapis.com/v0/b/playmyhitdev.appspot.com/o/assets%2Fdefault_profile_banner.png?alt=media&token=8327ac66-978a-42c8-a228-e51e26c46155";
    try {
      print("Getting settings data model from firestore..");
      print("User Id: ${auth.currentUser!.uid}");
      return await firestore.runTransaction((transaction) async {
        DocumentReference ref = firestore.doc("/users/${auth.currentUser!.uid}");
        DocumentSnapshot snapshot = await transaction.get(ref);
        
        Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;
      
        SettingsDataModel dataModel = SettingsDataModel(
          username: data["username"], 
          profileBannerImage: await getImageFileFromPath(data["settings"]["profileBannerUrl"] ?? defaultProfileBannerImageUrl, ImageType.profileBanner), 
          profileImage: await getImageFileFromPath(auth.currentUser?.photoURL ?? defaultProfileImageUrl, ImageType.profilePicture),
          profileVisibility: data["settings"]["profileIsPrivate"] ? ProfileVisibility.private : ProfileVisibility.public, 
          profileIntroduction: data["settings"]["profileDescription"], 
          allowFriendRequests: data["settings"]["allowFriendRequests"], 
          allowCommentsGlobal: data["settings"]["allowComments"]
        );

        return dataModel;
      });
    }catch(e){
      print("Found error while attempting to retrieve the user settings from firestore.");
      print(e.toString());
      rethrow;
    }
    return null;
  }
}