part of 'settings_bloc.dart';

@immutable
sealed class SettingsBlocEvent {}

final class SettingsBlocSaveEvent extends SettingsBlocEvent {
  final UserProfileDataModel settingsData;
  SettingsBlocSaveEvent({required this.settingsData});
}

final class SettingsBlocInitialEvent extends SettingsBlocEvent {}
