import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:playmyhit/data/models/settings_data_model.dart';
import 'package:playmyhit/data/repositories/authentication_repo.dart';
import 'package:playmyhit/data/repositories/settings_repo.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  final AuthenticationRepository authRepo;
  final SettingsRepository settingsRepository;
  
  SettingsBloc({required this.authRepo, required this.settingsRepository}) : super(SettingsBlocInitialState(settingsDataModel: null)) {
    on<SettingsBlocSaveEvent>((event, emit){
      // Grab the settings data from the event and save it to the repository
      settingsRepository.settingsDataModel = event.settingsData;

      // Do some checks on the data

      List<String> errors = [];

      //Make sure there's profile image
      if(event.settingsData.profileBannerImage == null){
        errors.add("");
      }

    });

    on<SettingsBlocInitialEvent>((event, emit) async {
      emit(SettingsBlocLoadingState());
      try {
        SettingsDataModel? settingsDataModel = await settingsRepository.getSettingsDataModel();
        print("Retrieved settings data model: ");
        print(settingsDataModel);
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No settings were found for this user."));
        }else{
          emit(SettingsBlocInitialState(settingsDataModel: settingsDataModel));
        }
      } catch (e) {
        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });
  }
}
