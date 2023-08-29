import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return DashboardScreenState();
  }
  
}

class DashboardScreenState extends State<DashboardScreen> {


  Widget loggedInView = const SingleChildScrollView(
    child: Column(
      children: [
        Text("This is text one.")
      ],
    )
  );

  Widget unauthorizedView = const Center(
    child: Text("You are not authorized to view this content. Please login to view the dashboard.")
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateBlocBloc, AppStateBlocState>(
      bloc: BlocProvider.of<AppStateBlocBloc>(context),
      buildWhen: (previous, current) => current.runtimeType != AppStateBlocActionState,
      // listenWhen:(previous, current) => current.runtimeType == AppStateBlocActionState,
      
      builder : (context,state) => BlocListener<AppStateBlocBloc, AppStateBlocState>(
        listener: (context, state) {
          print("Recieved a new action state from the bloc in the dadshboard view.");
          print(state.runtimeType);
          // Listen for state changes here.
          switch(state.runtimeType){
            case AppStateLoginErrorState:
              break;
            case AppStateLoggedOutState:
              // Kick them back to the login page
              Navigator.of(context).popUntil((route)=>route.isFirst);
              break;
            // case AppStateNavigateToSettingsScreenState:
            //   Navigator.of(context).pushNamed('/settings');
            default:
              print("Recieved an unknown state: ${state.runtimeType}");
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            title: BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? const Text("Dashboard") : const Text("Unauthorized"),
            actions: [
              BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? FloatingActionButton(
                mini: true,
                heroTag: "settingsButton",
                child: const Icon(Icons.settings),
                onPressed: () {
                  // BlocProvider.of<AppStateBlocBloc>(context).add(AppStateNavigateToSettingsScreenEvent());
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
          body: BlocProvider.of<AppStateBlocBloc>(context).authRepo.currentUser != null ? loggedInView : unauthorizedView
        ),
      ),
    );
  }
}