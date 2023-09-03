import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/enumerations/profile_visibility.dart';
import 'package:playmyhit/data/models/user_profile_data_model.dart';
import 'package:playmyhit/data/repositories/authentication_repo.dart';
import 'package:playmyhit/data/repositories/settings_repo.dart';
import 'package:playmyhit/data/repositories/user_data_repo.dart';
import 'package:playmyhit/logic/app_state_bloc/app_state_bloc_bloc.dart';
import 'package:playmyhit/logic/settings_bloc/settings_bloc.dart';
import 'package:playmyhit/presentation/dashboard_screen/dashboard_screen.dart';
import 'package:playmyhit/presentation/login_screen/login_screen.dart';
import 'package:playmyhit/presentation/recovery_screen/recovery_screen.dart';
import 'package:playmyhit/presentation/registration_screen/registration_screen.dart';
import 'package:playmyhit/presentation/registration_screen/username_selection_screen.dart';
import 'package:playmyhit/presentation/settings_screen/settings.dart';
import 'data/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    // late AppStateBlocBloc appStateBloc = AppStateBlocBloc(authRepo: RepositoryProvider.of<AuthenticationRepository>(context));

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserDataRepo(firestore: FirebaseFirestore.instance)), // Pass the user data repo
        RepositoryProvider(create: (context) => AuthenticationRepository(auth: FirebaseAuth.instance)), // And the 
        RepositoryProvider(create: (context) => SettingsRepository(
          settingsDataModel: UserProfileDataModel(
            username: "", 
            profileBannerImage: null, 
            profileImage: null, 
            profileVisibility: ProfileVisibility.public, 
            profileIntroduction: '',
            allowFriendRequests: true,
            allowCommentsGlobal: true,
          ), 
          storage: FirebaseStorage.instance,
          auth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance
        )
      )
      ],
      child: MultiBlocProvider(
        providers : [
          BlocProvider<AppStateBlocBloc>(create: (context){
            return AppStateBlocBloc(
              authRepo: RepositoryProvider.of<AuthenticationRepository>(context),
              userDataRepo: RepositoryProvider.of<UserDataRepo>(context)
            );
          }),
          BlocProvider<SettingsBloc>(create: (context){
            return SettingsBloc(
              authRepo: RepositoryProvider.of<AuthenticationRepository>(context),
              settingsRepository: RepositoryProvider.of<SettingsRepository>(context),
            );
          })
        ],
        child: MaterialApp(
          title: 'PlayMyHit',
          // theme: ThemeData(
          //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          //   useMaterial3: true,
          // ),
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.dark,
            primaryColor: Colors.black,
      
            // Define the default font family.
            fontFamily: 'Georgia',
      
            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.normal),
              bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: "/login",
          routes : {
            "/login" : (context) => const LoginScreen(),
            "/register" : (context) => const RegistrationScreen(),
            "/selectusername" : (context) => const UsernameSelectionScreen(),
            "/recover" : (context) => const RecoveryScreen(),
            "/dashboard" : (context) => const DashboardScreen(),
            "/settings" : (context) => const SettingsScreen()
          }
        ),
      )
    );
  }
}