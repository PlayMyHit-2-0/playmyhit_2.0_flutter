import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/enumerations/profile_visibility.dart';
import 'package:playmyhit/data/models/user_profile_data_model.dart';
import 'package:playmyhit/data/repositories/authentication_repo.dart';
import 'package:playmyhit/data/repositories/settings_repo.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  final AuthenticationRepository authRepo;
  final SettingsRepository settingsRepository;
  
  SettingsBloc({required this.authRepo, required this.settingsRepository}) : super(SettingsBlocLoadedState(settingsDataModel: null)) {
    on<SettingsBlocSaveEvent>((event, emit){
      // Grab the settings data from the event and save it to the repository
      settingsRepository.settingsDataModel = event.settingsData;

      // Do some checks on the data

      List<String> errors = [];

      //Make sure there's profile image
      if(event.settingsData.profileBannerImageUrl.isEmpty){
        errors.add("");
      }

    });

    on<SettingsBlocInitialEvent>((event, emit) async {
      emit(SettingsBlocLoadingState());
      try {
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved settings data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No settings were found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      } catch (e) {
        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });

    on<SettingsBlocUpdateImageEvent>((event, emit) async {
      ImageType imageType = event.imageType;

      try{
        // Create an upload task for uploading the profile image
        UploadTask? imageUploadTask = await settingsRepository.uploadImageFile(event.profileImageFile, event.imageType);

        // Listen for upload changes and update the UI to let the user know the status
        imageUploadTask?.snapshotEvents.listen((event) {
          double uploadPercentage = event.bytesTransferred / event.totalBytes;
          emit(SettingsBlocUploadingImageState(
            imageType: imageType,
            uploadPercentage: uploadPercentage,
          ));
        });

        // When the upload is complete notify the UI that the upload is completed.
        await imageUploadTask?.whenComplete(() async {
          // Grab the image URL from the upload
          String downloadUrl = await imageUploadTask.snapshot.ref.getDownloadURL();

          if(imageType == ImageType.profilePicture){
            // Update the profile image URL in firestore
            await settingsRepository.updateProfileImageUrl(downloadUrl);
          }else{
            await settingsRepository.updateProfileBannerUrl(downloadUrl);
          }

          if(kDebugMode){
            // print("Retrieving new user profile data model");
          }

          UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
          if(kDebugMode){
            // print("Retrieved new user profile data model: ");
            print(settingsDataModel);
          }
          if(settingsDataModel == null){
            // Return an error
            emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
          }else{
            emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
          }
        });
      }catch(e){
        if(kDebugMode){
          // print("Found an error while attempting to update the ${imageType.toString()} image from the Settings Bloc.");
          print(e.toString());
        }

        // Notify the UI that there was an error.
        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });

    on<SettingsBlocUpdateProfileDescriptionEvent>((event,emit) async {
      String newProfileDescription = event.newDescription;
      try{
        // Show a loading indicator in the UI
        emit(SettingsBlocLoadingState());

        // Update the description in the backend.
        await settingsRepository.updateProfileDescription(newProfileDescription);
        
        // Load the new state into the UI
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved new user profile data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      }catch(e){
        if(kDebugMode){
          print("Found an error while attempting to update the user profile description from the Settings Bloc.");
          print(e.toString());
        }

        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });

    on<SettingsBlocUpdateProfileVisibilityEvent>((event, emit) async{
      ProfileVisibility visibility = event.visibility;
      try{
        // Show a loading indicator in the UI
        emit(SettingsBlocLoadingState());

        await settingsRepository.updateProfileVisibility(visibility);

        // Load the new state into the UI
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved new user profile data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      }catch(e){
        if(kDebugMode){
          print("Found an error while attempting to update the user profile visibility from the Settings Bloc.");
          print(e.toString());
        }

        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });


    on<SettingsBlocUpdateAllowFriendsRequestsEvent>((event, emit) async {
      bool allowFriendRequests = event.allowFriendRequests;
      try{
        emit(SettingsBlocLoadingState());

        await settingsRepository.updateAllowFriendRequests(allowFriendRequests);

        // Load the new state into the UI
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved new user profile data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      }catch(e){
        if(kDebugMode) {
          print("Found an error while attempting to update the allowFriendRequests from the Settings Bloc.");
          print(e.toString());
        }

        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });

    on<SettingsBlocUpdateAllowCommentsEvent>((event, emit) async {
      bool allowComments = event.allowComments;
      try{
        // Show a loading indicator in the UI
        emit(SettingsBlocLoadingState());

        await settingsRepository.updateAllowComments(allowComments);

        // Load the new state into the UI
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved new user profile data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      }catch(e){
        if(kDebugMode){
          print("Found an error while attempting to update the allowComments from the Settings Bloc");
          print(e.toString());
        }

        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });

    on<SettingsBlocUpdateCountryEvent>((event, emit) async {
      String newCountry = event.newCountry;
      try{
        // Show a loading indicator in the UI
        emit(SettingsBlocLoadingState());

        await settingsRepository.updateCountry(newCountry);

        // Load the new state into the UI
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved new user profile data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      }catch(e){
        if(kDebugMode){
          print("Found an error while attempting to update the country from the Settings Bloc");
          print(e.toString());
        }

        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });


    on<SettingsBlocUpdateStateEvent>((event, emit) async {
      String? newState = event.newState;
      try{
        emit(SettingsBlocLoadingState());

        await settingsRepository.updateState(newState);

        // Load the new state into the UI
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved new user profile data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      }catch(e){
        if(kDebugMode){
          print("Found an error while attempting to update the user's geographic state from the Settings Bloc");
          print(e.toString());
        }

        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });

    on<SettingsBlocUpdateCityEvent>((event, emit) async {
      String newCity = event.newCity ?? "";
      try{
        emit(SettingsBlocLoadingState());

        await settingsRepository.updateCity(newCity);

        // Load the new state into the UI
        UserProfileDataModel? settingsDataModel = await settingsRepository.getUserProfileDataModel();
        if(kDebugMode){
          print("Retrieved new user profile data model: ");
          print(settingsDataModel);
        }
        if(settingsDataModel == null){
          // Return an error
          emit(SettingsBlocErrorState(error: "No user profile data model was found for this user."));
        }else{
          emit(SettingsBlocLoadedState(settingsDataModel: settingsDataModel));
        }
      }catch(e){
        if(kDebugMode){
          print("Found an error while attempting to update the city from the Settings Bloc");
          print(e.toString());
        }

        emit(SettingsBlocErrorState(error: e.toString()));
      }
    });
  }
}
