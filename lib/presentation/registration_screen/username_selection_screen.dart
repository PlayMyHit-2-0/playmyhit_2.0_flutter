import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';

class UsernameSelectionScreen extends StatefulWidget {
  const UsernameSelectionScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return UsernameSelectionScreenState();
  }  
}

class UsernameSelectionScreenState extends State<UsernameSelectionScreen>{
  @override
  Widget build(BuildContext context) {
    SingleChildScrollView usernameSelectionView(String? username,bool? available) => SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            initialValue: username,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Select a username",
            ),
            validator: (value){
              if(available == false) return "Username Unavailable";
              return null;
            },
            onChanged: (value) => {
              // Check if the username is available
              BlocProvider.of<AppStateBlocBloc>(context).add(AppStateUpdateSelectedUsernameEvent(selectedUsername: value)),
            },
          ),
          const SizedBox(height: 20),
          Visibility(visible: !available! && username!.isNotEmpty, child: const Text(
            "Username Unavailable.",
            style: TextStyle(
              color: Colors.red
            )
          )),
          Visibility(visible: username!.length < 6 && username.isNotEmpty,
            child: const Text(
              "it's too short", 
              style: TextStyle(color: Colors.red)
            )
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: available,
            child: TextButton(
              onPressed: (){
                
              },
              child: const Text("Select Username")
            ),
          )
        ],
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Username")
      ),
      body: BlocListener<AppStateBlocBloc, AppStateBlocState>(
        listenWhen: (previous, current) => current.runtimeType == AppStateBlocActionState,
        listener: (context, state) {
          switch(state.runtimeType){
            case AppStateUsernameSelectionErrorState:
              var st = state as AppStateUsernameSelectionErrorState;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(st.error)
                )
              );
            default:
              break;
          }
        },
        child: BlocBuilder<AppStateBlocBloc,AppStateBlocState>(
          bloc: BlocProvider.of<AppStateBlocBloc>(context),
          buildWhen: (previous, current) => current.runtimeType != AppStateBlocActionState,
          builder:(context, state){
            switch(state.runtimeType){
              case AppStateBlocInitialState:
                return usernameSelectionView("", false);
              case AppStateBlocNavigateToUsernameSelectionScreenState:
                var st = state as AppStateBlocNavigateToUsernameSelectionScreenState;
                return usernameSelectionView(st.username, st.available);
              case AppStateBlocUpdateUsernameAvailabilityState:
                var st = state as AppStateBlocUpdateUsernameAvailabilityState;
                return usernameSelectionView(st.username, st.available);
              default:
                print(state.runtimeType);
                return const Center(
                  child: Text("Unknown State")
                );
            }
          },
        )
      )
    );   
  }
}