part of 'settings_bloc.dart';

@immutable
sealed class SettingsBlocEvent {}

final class SettingsBlocSaveEvent extends SettingsBlocEvent {
  final UserProfileDataModel settingsData;
  SettingsBlocSaveEvent({required this.settingsData});
}

final class SettingsBlocInitialEvent extends SettingsBlocEvent {}

final class SettingsBlocUpdateImageEvent extends SettingsBlocEvent {
  final File profileImageFile;
  final ImageType imageType;
  SettingsBlocUpdateImageEvent({required this.profileImageFile, required this.imageType});
}

final class SettingsBlocUpdateProfileDescriptionEvent extends SettingsBlocEvent {
  final String newDescription;
  SettingsBlocUpdateProfileDescriptionEvent({required this.newDescription});
}

final class SettingsBlocUpdateProfileVisibilityEvent extends SettingsBlocEvent {
  final ProfileVisibility visibility;
  SettingsBlocUpdateProfileVisibilityEvent({required this.visibility});
}

final class SettingsBlocUpdateAllowFriendsRequestsEvent extends SettingsBlocEvent {
  final bool allowFriendRequests;
  SettingsBlocUpdateAllowFriendsRequestsEvent({required this.allowFriendRequests});
}

final class SettingsBlocUpdateAllowCommentsEvent extends SettingsBlocEvent {
  final bool allowComments;
  SettingsBlocUpdateAllowCommentsEvent({required this.allowComments});
}

final class SettingsBlocUpdateCountryEvent extends SettingsBlocEvent {
  final String newCountry;
  SettingsBlocUpdateCountryEvent({required this.newCountry});
}

final class SettingsBlocUpdateStateEvent extends SettingsBlocEvent {
  final String? newState;
  SettingsBlocUpdateStateEvent({required this.newState});
}

final class SettingsBlocUpdateCityEvent extends SettingsBlocEvent {
  final String? newCity;
  SettingsBlocUpdateCityEvent({required this.newCity});
}