import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/logic/profile_bloc/profile_bloc.dart';
import 'package:playmyhit/logic/settings_bloc/settings_bloc.dart';
import 'package:playmyhit/presentation/profile_screen/authorized_view.dart';
import 'package:playmyhit/presentation/profile_screen/unauthorized_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // Load the initial profile data from the settings bloc before building the dashboard view.
    BlocProvider.of<SettingsBloc>(context).add(SettingsBlocInitialEvent());
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);

    return BlocBuilder<AppStateBlocBloc, AppStateBlocState>(
      bloc: BlocProvider.of<AppStateBlocBloc>(context),
      buildWhen: (previous, current) => current.runtimeType != AppStateBlocActionState,      
      builder : (buildContext,state) => BlocListener<AppStateBlocBloc, AppStateBlocState>(
        listener: (listenContext, state) {
          if(kDebugMode){
            print ("Recieved a new action state from the bloc in the dadshboard view.");
            print(state.runtimeType);
          }
          switch(state.runtimeType){
            case AppStateLoginErrorState:
              break;
            case AppStateLoggedOutState:
              Navigator.of(context).popUntil((route)=>route.isFirst);
              break;
            default:
              if(kDebugMode) print("Recieved an unknown state: ${state.runtimeType}");
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            leading: Container(),
            title: BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? const Text("My Profile") : const Text("Unauthorized"),
            actions: [
              BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? FloatingActionButton(
                mini: true,
                heroTag: "settingsButton",
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).pushNamed("/settings");
                },
                child: const Icon(Icons.settings),
              ) : Container(),
              const SizedBox(width: 10,),
              BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? FloatingActionButton(
                mini: true,
                heroTag: "logoutButton",
                backgroundColor: Colors.redAccent,
                onPressed: (){
                  BlocProvider.of<AppStateBlocBloc>(context).add(AppStateAttemptSignOutEvent());
                },
                child: const Icon(Icons.exit_to_app),
              ) : Container(),
              const SizedBox(width: 10,),
            ],
          ),
          body: BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? 
            AuthorizedView(settingsBloc: settingsBloc, profileBloc: BlocProvider.of<ProfileBloc>(context)) :
            const UnauthorizedView(),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: NavigationBar(
            destinations: [
              TextButton.icon(
                onPressed: (){
                  BlocProvider.of<PostBloc>(context).add(PostInitialEvent(postMode: PostMode.add));
                  Navigator.of(context).pushNamed("/post");
                }, 
                icon: const Icon(Icons.post_add, color: Colors.white),
                label: const Text("New Post", style: TextStyle(color: Colors.white)),
              ),
              TextButton.icon(
                onPressed: (){}, 
                icon: const Icon(Icons.messenger, color: Colors.white),
                label : const Text("Messages", style: TextStyle(color: Colors.white))
              )
            ],
          )),
        ),
      ),
    );
  }
}