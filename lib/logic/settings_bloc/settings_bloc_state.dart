part of 'settings_bloc.dart';

@immutable
sealed class SettingsBlocState {}

final class SettingsBlocInitialState extends SettingsBlocState{
  final SettingsDataModel? settingsDataModel;
  SettingsBlocInitialState({required this.settingsDataModel});
}


abstract class SettingsBlocActionState extends SettingsBlocState {}

final class SettingsBlocErrorState extends SettingsBlocActionState {
  final String error;
  SettingsBlocErrorState({required this.error});
}

final class SettingsBlocLoadingState extends SettingsBlocState {}