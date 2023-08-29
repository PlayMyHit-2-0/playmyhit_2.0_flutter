import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return RecoveryScreenState();
  }

}

class RecoveryScreenState extends State<RecoveryScreen> {
  late TextEditingController _emailController;


  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recover Account"),
      ),
      body: BlocConsumer<AppStateBlocBloc, AppStateBlocState>(
        listenWhen: (previous, current) => current.runtimeType == AppStateBlocActionState, // Listen when we have an action state
        buildWhen: (previous, current) => current.runtimeType != AppStateBlocActionState, // And build when we have a regular state
        listener: (context, state) {
          switch(state.runtimeType){
            case AppStateLoginErrorState : // When we throw an error
                var errorState = state as AppStateLoginErrorState; // grab the error message from the state
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorState.error))); // And show a snackbar with it.
                break;
              case AppStateRecoveryEmailRequestEmailSentState :
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("We've sent you a recovery email. Please click the link provided to continue recovering your account."))); // And show a snackbar with it.
                break;
              default:
                break;
          }
        },
        builder: (context, state) {
          return BlocListener<AppStateBlocBloc, AppStateBlocState>(
            bloc : BlocProvider.of<AppStateBlocBloc>(context),
            listener: (context, state) {
              switch(state.runtimeType){
                case AppStateLoginErrorState:
                  var error = (state as AppStateLoginErrorState).error;
                  switch(error){
                    case 'user-not-found':
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("That email address or username was not found in our database. Please check the email address and try again.")));
                      break;
                    default:
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occured while attempting to send you a recovery link to your email. Please check your email address and try again.")));
                      break;
                  }
                  break;
                default:
                  break;
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText : "Email Address",
                        border: OutlineInputBorder()
                      )
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.redAccent),
                            foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                          ),
                          child: const Text("Cancel"),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("Send Recovery Email"),
                          onPressed: (){
                            print("Sending Recovery Email...");
                            // Send a recovery email event with the email field value.
                            BlocProvider.of<AppStateBlocBloc>(context).add(SendRecoveryEmailEvent(email: _emailController.text));
                          },  
                        )
                      ],
                    )
                    
                  ],
                )
              )
            ),
          );
        },
      )
    );
  }
}