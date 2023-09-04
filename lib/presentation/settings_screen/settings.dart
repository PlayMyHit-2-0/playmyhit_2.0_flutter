import 'dart:io';

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
  
  String? profileImageUrl;
  String? profileDescription;
  bool editingDescription = false;
  TextEditingController? descriptionController;
  bool makeProfilePrivate = false;
  bool allowFriendsRequest = false;
  bool allowComments = false;
  String? profileBannerUrl;


  @override
  void initState() {
    profileImageUrl = "";
    editingDescription = false;
    profileDescription = "";
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
      print("Populating settings view with incoming settings data model.");
      print(model.toString());
      // Set the profile image from the model
      if(model?.profileImageUrl != null){
        profileImageUrl = model?.profileImageUrl;
      }

      // Set the profile banner image from the model
      if(model?.profileBannerImageUrl != null){
        profileBannerUrl = model?.profileBannerImageUrl;
      }

      // Set the profile description from the model
      if(model?.profileIntroduction != null){
        profileDescription = model?.profileIntroduction;
        descriptionController?.text = model!.profileIntroduction;
      }

      // Set the profile visibility from the model
      if(model?.profileVisibility == ProfileVisibility.private){
        makeProfilePrivate = true;
      }else if(model?.profileVisibility == ProfileVisibility.public){
        makeProfilePrivate = false;
      }

      // Set wether to allow friend requests from the model
      // Set wether to allow global comments
      allowFriendsRequest = model?.allowFriendRequests ?? true;
      allowComments = model?.allowCommentsGlobal ?? true;
      
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
                    profileImageUrl == null ? 
                      const Icon(Icons.image, size: 200) : 
                      CircleAvatar(
                        radius: 100,
                        // backgroundImage: Image.file(
                        //   profileImage!,fit: 
                        //   BoxFit.fill
                        // ).image
                        backgroundImage: Image.network(profileImageUrl!).image,
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

                      if(mounted){
                        BlocProvider.of<SettingsBloc>(context).add(
                          SettingsBlocUpdateProfileImageEvent(
                            profileImageFile: File(image!.path),
                            imageType: ImageType.profilePicture
                          )
                        );
                      }
                    }catch(e){
                      print(e);
                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("That image is corrupted. Try another image."),));
                      }
                    }
                    // try{
                    //   XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    //   if(image != null){
                    //     setState(() {
                    //       profileImage = File(image.path);
                    //     });
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
              descriptionController?.text ?? "Provide a description", 
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
                  profileDescription = descriptionController?.text;
                  editingDescription = false;

                });
              },
            ),
            Row(
              children: [
                const Text("Make Profile Private"),
                Switch(
                  value: makeProfilePrivate, 
                  onChanged: (value){
                    setState(() {
                      makeProfilePrivate = !makeProfilePrivate;
                    });
                  }
                )
              ],
            ),
            Row(
              children: [
                const Text("Allow Friend Requests"),
                Switch(
                  value: allowFriendsRequest, 
                  onChanged: (value){
                    setState(() {
                      allowFriendsRequest = !allowFriendsRequest;
                    });
                  }
                )
              ],
            ),
            Row(
              children: [
                const Text("Allow Comments"),
                Switch(
                  value: allowComments, 
                  onChanged: (value){
                    setState(() {
                      allowComments = !allowComments;
                    });
                  }
                )
              ]
            ),
            const Text("Profile Banner"),
            // const SizedBox(
            //   width: double.infinity,
            //   child: Icon(Icons.image, size: 200)
            // )
            MaterialBanner(
              content: profileBannerUrl == null ? const Icon(Icons.image, size: 200) : SizedBox(
                width: 200, 
                height: 200, 
                child: Image.network(profileBannerUrl!)
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try{
                      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if(image != null){
                        // setState(() {
                        //   // profileBannerUrl =  image.path;
                        // });
                      }else{
                        if(mounted){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The image could not be loaded."),));
                        }
                      }
                    }catch(e){
                      if(mounted){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("That image is corrupted. Try another image."),));
                      }
                    }
                  }, 
                  child: const Text("Change Profile Banner")
                )
              ]
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: (){
                  // UserProfileDataModel dataModel = UserProfileDataModel(
                  //   allowFriendRequests: allowFriendsRequest,
                  //   profileIntroduction: descriptionController!.text,
                  //   username: BlocProvider.of<SettingsBloc>(context).settingsRepository.settingsDataModel.username,
                  //   profileImageUrl: profileImage!,
                  //   profileBannerImage: profileBanner!,
                  //   profileVisibility: makeProfilePrivate ? ProfileVisibility.private : ProfileVisibility.public, 
                  //   allowCommentsGlobal: allowComments
                  // );
                  // print(dataModel);
                },
                child: const Text("Update Profile Settings"),
              ),
            )
          ]
        ),
      );
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
                print(state.runtimeType);
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