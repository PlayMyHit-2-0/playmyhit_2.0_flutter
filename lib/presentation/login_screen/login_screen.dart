import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>{
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Scaffold _loginView() => Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restore, color: Colors.white,), label: "Recover"),
          BottomNavigationBarItem(icon: Icon(Icons.app_registration, color: Colors.white), label:  "Register")
        ],
        onTap: (value){
          switch(value){
            case 0: 
              Navigator.of(context).pushNamed("/recover");
              break;
            case 1:
              Navigator.of(context).pushNamed("/register");
              break;
          }
        },
      ),
      extendBody: false,
      body: SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 50),
          LottieBuilder.asset("assets/lotties/logo_black.json"),
          const SizedBox(height: 8),
          TextField(
            controller : _emailController,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: "Username"
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              hintText: "Password"
            ),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          TextButton(
            child: const Text("Login"),
            onPressed: (){
              if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                BlocProvider.of<AppStateBlocBloc>(context).add(
                  AttemptAuthenticationLoginEvent(
                    password: _passwordController.text, 
                    username: _emailController.text
                  )
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You have to provide a username and password in order to login."),)
                );
              }
            },
          ),
          // TextButton(
          //   child: const Text("Register"),
          //   onPressed: (){
          //     Navigator.of(context).pushNamed("/register");
          //   },
          // ),
          // // const Spacer(flex: 1),
          // // Flex(direction: Axis.vertical,children: [
          // //   Expanded(child: Container(),)
          // // ],),
          // TextButton(
          //     child: const Text("Recover Account"),
          //     onPressed: (){
          //       Navigator.of(context).pushNamed("/recover");
          //     },
          // ),
          const SizedBox(height: 10)
        ],
      ),
    )
  );


  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStateBlocBloc, AppStateBlocState>(
      bloc: BlocProvider.of<AppStateBlocBloc>(context),
      // listenWhen: (previous, current) => current.runtimeType == AppStateBlocActionState, // Listen when we have an action state
      listener: (context, state) {
        print("Recieved state in the login ui: ");
        print(state.runtimeType);
        switch(state.runtimeType){  
          case AppStateLoggedInState :
            print("Recieved logged in state in the login ui. Sending to the dashboard now...");
            // Send them to the dashboard home screen
            Navigator.of(context).pushNamed("/dashboard");
            break;
          //case AppStateErrorState : // When we throw an error
            // var errorState = state as AppStateErrorState; // grab the error message from the state
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorState.error))); // And show a snackbar with it.
          case AppStateLoginErrorState:
            var error = (state as AppStateLoginErrorState).error;
            print(error);
            switch(error){
              case 'user-not-found':
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("That email address or username was not found in our database. Please check the email address and try again.")));
                break;
              case 'wrong-password':
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The credentials you provided were incorrect. Please try again with different credentials.")));
                break;
              case 'invalid-email':
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The email address is invalid. Please provide a valid email address and try again.")));
                break;
              default:
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("An error occured while attempting to log in. Please check your credentials and try again.")));
                break;
            }
            break;
          default:
            break;
        }
      },
      child: _loginView()
    );
  }
}