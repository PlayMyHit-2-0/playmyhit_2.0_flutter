import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:playmyhit/data/models/registration_form_data_model.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';
import 'package:playmyhit/utils/utils.dart';

class RegistrationScreen extends StatefulWidget{
  const RegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegistrationScreenState();
  }

}

class RegistrationScreenState extends State<RegistrationScreen> {

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmationController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late GlobalKey _formKey;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _formKey = GlobalKey();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  bool visiblePassword = false;
  bool visiblePasswordConfirmation = false;

  bool isCreator = true;
  bool agreedToRecieveNewsletter = false;
  bool agreedToTermsAndConditions = false;


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Account"),
      ),   
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  label : Text("First Name"),
                  hintText: "First Name",
                  border: OutlineInputBorder()
                ),
                validator: (value) => value!.isEmpty ? "Please provide a first name." : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  label: Text("Last Name"),
                  hintText: "Last Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Please provide a last name." : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label : Text("Email Address"),
                  hintText: "Email Address",
                  border: OutlineInputBorder()
                ),
                validator: (value) => Utils.isPasswordInvalid(value,context) ? "Password is invalid" : null, 
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller : _passwordController,
                obscureText: visiblePassword ? false : true,
                decoration: const InputDecoration(
                  label : Text("Password"),
                  hintText: "Password",
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordConfirmationController,
                obscureText: visiblePasswordConfirmation ? false : true,
                decoration : const InputDecoration(
                  label : Text("Password Confirmation"),
                  hintText: "Password Confirmation",
                  border: OutlineInputBorder()
                )
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const Text("I am a:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Creator"),
                  Switch(
                    inactiveThumbColor: Colors.greenAccent,
                    value: !isCreator,
                    onChanged: (value){
                      setState((){
                        isCreator = !value;
                      });
                    },
                  ),
                  const Text("Fan")
                ],
              ),
              const Text("I agree to recieve a monthly newsletter."),
              Switch(
                inactiveThumbColor: Colors.greenAccent,
                value: agreedToRecieveNewsletter ,
                onChanged: (value){
                  setState((){
                    agreedToRecieveNewsletter = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children : [
                  const Text("I agree to the"),
                  TextButton(
                    child: const Text("Terms and Conditions"),
                    onPressed: () async {
                      await showDialog(context: context, builder: (context)=> AboutDialog(
                        applicationIcon: SizedBox(
                          width: 56,
                          height: 56,
                          child: LottieBuilder.asset("assets/lotties/logo_black.json"),
                        ),
                        applicationName: "PlayMyHit 2.0",
                        children: const [
                          // Markdown(
                          //   shrinkWrap: true,
                          //   data: "## Terms and Conditions",
                          // ),
                        ],
                      ));
                    },
                  )
                ]
              ),
              Switch(
                inactiveThumbColor: Colors.greenAccent,
                value: agreedToTermsAndConditions ,
                onChanged: (value){
                  setState((){
                    agreedToTermsAndConditions = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.redAccent),
                      foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white)
                    ),
                    onPressed: (){
                      Navigator.of(context).popUntil((route)=>route.isFirst); // Return to the login screen
                    },
                    child: const Text("Cancel")
                  ),
                  BlocListener<AppStateBlocBloc, AppStateBlocState>(
                    listener: (context, state) {
                      switch(state.runtimeType){
                        case AppStateBlocNavigateToUsernameSelectionScreenState:
                          Navigator.of(context).pushNamed("/selectusername");
                          break;
                        case AppStateRegistrationErrorState:
                          var st = state as AppStateRegistrationErrorState;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(st.error),
                            )
                          );
                      }
                    },
                    child: TextButton(
                      onPressed: (){
                        BlocProvider.of<AppStateBlocBloc>(context).add(StoreRegistrationFormInRepositoryEvent(
                          dataModel: RegistrationFormDataModel(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            passwordConfirmation: _passwordConfirmationController.text,
                            isCreator: isCreator,
                            agreedToRecieveNewsletter: agreedToRecieveNewsletter,
                            agreedToTermsAndConditions: agreedToTermsAndConditions,
                            userName: null,
                          )
                        ));
                      },
                      child: const Text("Next")
                    ),
                  )
                ]
              )
            ],
          ),
        )
      )
    );
  }
}