import 'dart:io';

import 'package:playmyhit/data/enumerations/profile_visibility.dart';

class SettingsDataModel {
  final String username;
  File? profileBannerImage;
  File? profileImage;
  final ProfileVisibility profileVisibility;
  final String profileIntroduction;
  final bool allowFriendRequests;
  final bool allowCommentsGlobal;

  SettingsDataModel({
    required this.username, 
    required this.profileBannerImage, 
    required this.profileImage, 
    required this.profileVisibility, 
    required this.profileIntroduction,
    required this.allowFriendRequests,
    required this.allowCommentsGlobal
  });

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