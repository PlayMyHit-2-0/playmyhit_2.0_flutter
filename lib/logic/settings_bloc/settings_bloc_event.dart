part of 'settings_bloc.dart';

@immutable
sealed class SettingsBlocEvent {}

final class SettingsBlocSaveEvent extends SettingsBlocEvent {
  final UserProfileDataModel settingsData;
  SettingsBlocSaveEvent({required this.settingsData});
}

final class SettingsBlocInitialEvent extends SettingsBlocEvent {}

final class SettingsBlocUpdateProfileImageEvent extends SettingsBlocEvent {
  final File profileImageFile;
  final ImageType imageType;
  SettingsBlocUpdateProfileImageEvent({required this.profileImageFile, required this.imageType});
}