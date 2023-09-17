import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';
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
            leading: Container(),
            title: BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? const Text("My Profile") : const Text("Unauthorized"),
            actions: [
              BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? FloatingActionButton(
                mini: true,
                heroTag: "settingsButton",
                child: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed("/settings");
                },
              ) : Container(),
              const SizedBox(width: 10,),
              BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? FloatingActionButton(
                mini: true,
                heroTag: "logoutButton",
                child: const Icon(Icons.exit_to_app),
                onPressed: (){
                  BlocProvider.of<AppStateBlocBloc>(context).add(AppStateAttemptSignOutEvent());
                },
              ) : Container(),
              const SizedBox(width: 10,),
            ],
          ),
          body: BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? 
            AuthorizedView(bloc: settingsBloc) :
            const UnauthorizedView()
        ),
      ),
    );
  }
}