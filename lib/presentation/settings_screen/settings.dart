import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playmyhit/data/enumerations/profile_visibility.dart';
import 'package:playmyhit/data/models/user_profile_data_model.dart';
import 'package:playmyhit/data/repositories/settings_repo.dart';
import 'package:playmyhit/logic/settings_bloc/settings_bloc.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
  
}

class SettingsState extends State<SettingsScreen> {
  
  // String? profileImageUrl;
  // String? profileDescription;
  bool editingDescription = false;
  late TextEditingController descriptionController;
  // bool makeProfilePrivate = false;
  // bool allowFriendsRequest = false;
  // bool allowComments = false;
  // String? profileBannerUrl;


  @override
  void initState() {
    // profileImageUrl = "";
    // editingDescription = false;
    // profileDescription = "";
    descriptionController = TextEditingController();
    BlocProvider.of<SettingsBloc>(context).add(SettingsBlocInitialEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    SingleChildScrollView loadedView(UserProfileDataModel? model){
      
      descriptionController.text = model?.profileIntroduction ?? "";
      
      if(model != null){
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Column(
                    children: [
                      const Text("Profile Image"),
                      model.profileImageUrl.isEmpty ? 
                        const Icon(Icons.image, size: 200) : 
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: Image.network(model.profileImageUrl).image,
                        )
                    ],
                  ),
                  InkWell(
                    child: const Column(
                      children: [
                        Text("Change"),
                        Icon(Icons.upload)
                      ]
                    ),
                    onTap: () async {
                      try{
                        XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                        if(mounted && image != null){
                          BlocProvider.of<SettingsBloc>(context).add(
                            SettingsBlocUpdateImageEvent(
                              profileImageFile: File(image.path),
                              imageType: ImageType.profilePicture
                            )
                          );
                        }
                      }catch(e){
                        if(kDebugMode){
                          print(e);
                        }
                        if(mounted){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("That image is corrupted. Try another image."),));
                        }
                      }
                    },
                  )
                ]
              ),
              const Text(
                "Profile Description", 
                textAlign: TextAlign.start
              ),
              editingDescription ? TextField(
                controller: descriptionController,
                maxLength: 200,
                showCursor: true,
                maxLines: 5,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description),
                  label: Text("Profile Description")
                ),
              ) : Text(
                descriptionController.text.isEmpty ? "Provide a description" : descriptionController.text, 
                textAlign: TextAlign.start
              ),
              !editingDescription ? TextButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Description"),
                onPressed: (){
                  setState(() {
                    editingDescription = true;
                  });
                },
              ) : TextButton.icon(
                icon: const Icon(Icons.done),
                label: const Text("Done Editing"),
                onPressed: (){
                  setState((){
                    editingDescription = false;
                  });

                  BlocProvider.of<SettingsBloc>(context).add(
                    SettingsBlocUpdateProfileDescriptionEvent(
                      newDescription: descriptionController.text
                    )
                  );
                },
              ),
              Row(
                children: [
                  const Text("Make Profile Private"),
                  Switch(
                    value: model.profileVisibility == ProfileVisibility.private ? true : false, 
                    onChanged: (value){
                      // Add event to Settings bloc to update the profile visibility
                      BlocProvider.of<SettingsBloc>(context).add(SettingsBlocUpdateProfileVisibilityEvent(visibility: value == true ? ProfileVisibility.private : ProfileVisibility.public));
                    }
                  )
                ],
              ),
              Row(
                children: [
                  const Text("Allow Friend Requests"),
                  Switch(
                    value: model.allowFriendRequests, 
                    onChanged: (value){
                      BlocProvider.of<SettingsBloc>(context).add(
                        SettingsBlocUpdateAllowFriendsRequestsEvent(
                          allowFriendRequests: value
                        )
                      );
                    }
                  )
                ],
              ),
              Row(
                children: [
                  const Text("Allow Comments"),
                  Switch(
                    value: model.allowCommentsGlobal, 
                    onChanged: (value){
                      BlocProvider.of<SettingsBloc>(context).add(
                        SettingsBlocUpdateAllowCommentsEvent(
                          allowComments: value
                        )
                      );
                    } 
                  )
                ]
              ),
              const Text("Profile Banner"),
              MaterialBanner(
                content: model.profileBannerImageUrl.isEmpty ? const Icon(Icons.image, size: 200) : SizedBox(
                  width: 200, 
                  height: 200, 
                  child: Image.network(model.profileBannerImageUrl)
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // try{
                      //   XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      //   if(image != null){
                          
                      //   }else{
                      //     if(mounted){
                      //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The image could not be loaded."),));
                      //     }
                      //   }
                      // }catch(e){
                      //   if(mounted){
                      //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("That image is corrupted. Try another image."),));
                      //   }
                      // }
                      try{
                        XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                        if(mounted && image != null){
                          BlocProvider.of<SettingsBloc>(context).add(
                            SettingsBlocUpdateImageEvent(
                              profileImageFile: File(image.path),
                              imageType: ImageType.profileBanner
                            )
                          );
                        }
                      }catch(e){
                        if(kDebugMode){
                          print(e);
                        }
                        if(mounted){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("That image is corrupted. Try another image."),));
                        }
                      }
                    }, 
                    child: const Text("Change Profile Banner")
                  )
                ]
              ),
              const SizedBox(
                height: 20
              ),
              CSCPicker(
                currentCountry: model.country,
                currentState: model.state,
                currentCity: model.city,
                disabledDropdownDecoration: const BoxDecoration(
                  color: Colors.black45
                ),
                dropdownDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                onCountryChanged: (value){
                  if(kDebugMode) print("Country Has Changed: $value");
                  BlocProvider.of<SettingsBloc>(context).add(SettingsBlocUpdateCountryEvent(newCountry: value));
                },
                onStateChanged: (value){
                  if(kDebugMode) print("State Has Changed: $value");
                  if(value != null){
                    BlocProvider.of<SettingsBloc>(context).add(SettingsBlocUpdateStateEvent(newState: value));
                  }
                },
                onCityChanged: (value){
                  if(kDebugMode) print("City Has Changed: $value");
                  if(value != null){
                    BlocProvider.of<SettingsBloc>(context).add(SettingsBlocUpdateCityEvent(newCity: value));
                  }
                }
              )
            ]
          ),
        );
      }else{
        return const SingleChildScrollView(
          child: Center(
            child: Text("Model was not loaded.")
          )
        );
      }
    }

    Center uploadingView(ImageType imageType, double uploadPercentage){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Uploading ${imageType == ImageType.profilePicture ? " New Profile Picture" : " New Profile Banner"}"),
            const SizedBox(height: 20,),
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: uploadPercentage
              ),
            )
          ],
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: BlocListener<SettingsBloc, SettingsBlocState>(
        listener: (context, state) {
          if(state.runtimeType == SettingsBlocErrorState){
            var st = state as SettingsBlocErrorState;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(st.error)
              )
            );
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsBlocState>(
              buildWhen: (previous, current) => current.runtimeType != SettingsBlocActionState,
              builder: (context, state) {
                if(kDebugMode) print(state.runtimeType);

                switch (state.runtimeType){
                  case SettingsBlocLoadingState:
                    return const Center(
                      child: CircularProgressIndicator()
                    );
                  case SettingsBlocLoadedState:
                    var st = state as SettingsBlocLoadedState;
                    return loadedView(st.settingsDataModel);
                  case SettingsBlocUploadingImageState:
                    var st = state as SettingsBlocUploadingImageState;
                    return uploadingView(st.imageType, st.uploadPercentage);
                  default:
                    return const Center(
                      child: Text("Unknown State"),
                    );
                }
              },
            ),
      )
    );
  }
}