
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/logic/profile_bloc/profile_bloc.dart';
import 'package:playmyhit/presentation/profile_screen/pictures_screen/discover_pictures_screen.dart';
import 'package:playmyhit/presentation/profile_screen/pictures_screen/friends_pictures_screen.dart';
import 'package:playmyhit/presentation/profile_screen/pictures_screen/my_pictures_screen.dart';

class PicturesScreen extends StatefulWidget{
  const PicturesScreen({super.key});

  @override
  State<PicturesScreen> createState() => _PicturesScreenState();
}

class _PicturesScreenState extends State<PicturesScreen> with SingleTickerProviderStateMixin{
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
          case NavigateToPicturesPageState:
            NavigateToPicturesPageState st = state as NavigateToPicturesPageState;
            List<Attachment> myPictureAttachments = st.myPictureAttachments;
            return mainUi(controller, context,myPictureAttachments);
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



Widget mainUi(TabController controller, BuildContext context, List<Attachment> myPictureAttachments) => Scaffold(
  appBar: AppBar(
    title: const Text("Pictures"),
    bottom: TabBar(
      controller: controller,
      tabs: const [
        Tab(icon: Icon(Icons.person), text: "My Pictures"),
        Tab(icon: Icon(Icons.people), text: "Friends Pictures"),
        Tab(icon: Icon(Icons.explore), text: "Discover"),
      ],
    ),
  ),
  body: TabBarView(
    controller: controller,
      children: [
        // MyMusciView(myMusicPostAttachments: myMusicAttachments);
        MyPicturesScreen(myPicturePostAttachments: myPictureAttachments),
        const FriendsPicturesScreen(),
        const DiscoverPicturesScreen()
      ],
    ),
  );    