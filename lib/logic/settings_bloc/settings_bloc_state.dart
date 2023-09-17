part of 'settings_bloc.dart';

@immutable
sealed class SettingsBlocState {}

final class SettingsBlocLoadedState extends SettingsBlocState{
  final UserProfileDataModel? settingsDataModel;
  SettingsBlocLoadedState({required this.settingsDataModel});
}


abstract class SettingsBlocActionState extends SettingsBlocState {}

final class SettingsBlocErrorState extends SettingsBlocActionState {
  final String error;
  SettingsBlocErrorState({required this.error});
}

final class SettingsBlocUploadingImageState extends SettingsBlocActionState {
  final double uploadPercentage;
  final ImageType imageType;
  SettingsBlocUploadingImageState({required this.uploadPercentage, required this.imageType});
}

final class SettingsBlocLoadingState extends SettingsBlocState {}
