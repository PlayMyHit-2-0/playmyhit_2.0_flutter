import 'package:playmyhit/data/enumerations/profile_visibility.dart';

class UserProfileDataModel {
  final String username;
  final String profileBannerImageUrl;
  final String profileImageUrl;
  final ProfileVisibility profileVisibility;
  final String profileIntroduction;
  final bool allowFriendRequests;
  final bool allowCommentsGlobal;
  final String? country;
  final String? state;
  final String? city;

  UserProfileDataModel({
    required this.username, 
    required this.profileBannerImageUrl, 
    required this.profileImageUrl, 
    required this.profileVisibility, 
    required this.profileIntroduction,
    required this.allowFriendRequests,
    required this.allowCommentsGlobal,
    required this.country,
    required this.state,
    required this.city
  });

  UserProfileDataModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        profileBannerImageUrl = json['settings']['profileBannerUrl'],
        profileImageUrl = json['settings']['profileImageUrl'],
        profileVisibility = json['settings']['profileIsPrivate'] == false ? ProfileVisibility.public : ProfileVisibility.private,
        profileIntroduction = json['settings']['profileDescription'],
        allowFriendRequests = json['settings']['allowFriendRequests'],
        allowCommentsGlobal = json['settings']['allowComments'],
        country = json['settings']['country'],
        state = json['settings']['state'],
        city = json['settings']['city'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'settings' : {
          'profileBannerUrl': profileBannerImageUrl,
          'profileImageUrl' : profileImageUrl,
          'profileIsPrivate' :  profileVisibility == ProfileVisibility.public ? false : true,
          'profileDescription' : profileIntroduction,
          'allowFriendRequests' : allowFriendRequests,
          'allowComments' : allowCommentsGlobal,
          'country' : country,
          'state' : state,
          'city' : city
        },
  };

  @override
  String toString() {
    return """
        Username: $username, 
        profileBannerImage: $profileBannerImageUrl,
        profileImage: $profileImageUrl,
        profileVisibility: $profileVisibility,
        profileIntroduction: $profileIntroduction,
        allowFriendRequests: $allowFriendRequests,
        allowCommentsGlobal: $allowCommentsGlobal,
        country: $country,
        state: $state,
        city: $city
    """;
  }
}