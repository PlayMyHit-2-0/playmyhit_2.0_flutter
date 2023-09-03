import 'dart:io';

import 'package:playmyhit/data/enumerations/profile_visibility.dart';

class UserProfileDataModel {
  final String username;
  File? profileBannerImage;
  File? profileImage;
  final ProfileVisibility profileVisibility;
  final String profileIntroduction;
  final bool allowFriendRequests;
  final bool allowCommentsGlobal;

  UserProfileDataModel({
    required this.username, 
    required this.profileBannerImage, 
    required this.profileImage, 
    required this.profileVisibility, 
    required this.profileIntroduction,
    required this.allowFriendRequests,
    required this.allowCommentsGlobal
  });

  UserProfileDataModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        profileBannerImage = json['settings']['profileBannerUrl'],
        profileImage = json['settings']['profileImageUrl'],
        profileVisibility = json['settings']['profileIsPrivate'] == false ? ProfileVisibility.public : ProfileVisibility.private,
        profileIntroduction = json['settings']['profileDescription'],
        allowFriendRequests = json['settings']['allowFriendRequests'],
        allowCommentsGlobal = json['settings']['allowComments'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'settings' : {
          'profileBannerUrl': profileBannerImage,
          'profileImageUrl' : profileImage,
          'profileIsPrivate' :  profileVisibility == ProfileVisibility.public ? false : true,
          'profileDescription' : profileIntroduction,
          'allowFriendRequests' : allowFriendRequests,
          'allowComments' : allowCommentsGlobal,
        },
  };

  @override
  String toString() {
    return """
        Username: $username, 
        profileBannerImage: $profileBannerImage,
        profileImage: $profileImage,
        profileVisibility: $profileVisibility,
        profileIntroduction: $profileIntroduction,
        allowFriendRequests: $allowFriendRequests,
        allowCommentsGlobal: $allowCommentsGlobal
    """;
  }
}