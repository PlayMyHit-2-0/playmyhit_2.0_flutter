
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/logic/profile_bloc/profile_bloc.dart';
import 'package:playmyhit/presentation/profile_screen/music_screen/discover_music_screen.dart';
import 'package:playmyhit/presentation/profile_screen/music_screen/friends_music_screen.dart';
import 'package:playmyhit/presentation/profile_screen/music_screen/my_music_screen.dart';

class MusicScreen extends StatefulWidget{
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> with SingleTickerProviderStateMixin{
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc,ProfileState>(
      listenWhen: (previous, current) => current.runtimeType == ProfileActionState,
      buildWhen: (previous, current) => current.runtimeType != ProfileActionState,
      listener: (context, state){
        if(state.runtimeType == ProfileErrorState){
          var errState = state as ProfileErrorState;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errState.error)
            )
          );
        }
      },
      builder: (context, state){
        switch(state.runtimeType){
          case NavigateToMusicPageState:
            NavigateToMusicPageState st = state as NavigateToMusicPageState;
            List<Attachment> myMusicAttachments = st.myMusicAttachments;
            return mainUi(controller, context,myMusicAttachments);
          default: return Scaffold(
            appBar: AppBar(
              title: const Text("Unknown State")
            ),
            body : const Center(
              child: Text("Unknown State"),
            )
          );
        }
      },
    );
  }
}



Widget mainUi(TabController controller, BuildContext context, List<Attachment> myMusicAttachments) => Scaffold(
  appBar: AppBar(
    title: const Text("Music"),
    bottom: TabBar(
      controller: controller,
      tabs: const [
        Tab(icon: Icon(Icons.person), text: "My Music"),
        Tab(icon: Icon(Icons.people), text: "Friends Music"),
        Tab(icon: Icon(Icons.explore), text: "Discover"),
      ],
    ),
  ),
  body: TabBarView(
    controller: controller,
      children: [
        // MyMusciView(myMusicPostAttachments: myMusicAttachments);
        MyMusicScreen(myMusicPostAttachments: myMusicAttachments),
        const FriendsMusicScreen(),
        const DiscoverMusicScreen()
      ],
    ),
  );    