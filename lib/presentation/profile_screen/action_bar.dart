import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/profile_bloc/profile_bloc.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20)
      ),
      child: Container(
        color: const Color.fromRGBO(217, 217, 217, 1),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // IconButton(icon : const Icon(Icons.home, color: Colors.redAccent), onPressed: (){},),
              IconButton(icon: const Icon(Icons.music_note, color: Colors.redAccent), onPressed:(){
                BlocProvider.of<ProfileBloc>(context).add(NavigateToMusicPageEvent());
              }),
              IconButton(icon: const Icon(Icons.videocam, color: Colors.redAccent), onPressed:(){
                BlocProvider.of<ProfileBloc>(context).add(NavigateToVideosPageEvent());
              }),
              IconButton(icon: const Icon(Icons.image, color: Colors.redAccent), onPressed:() {
                BlocProvider.of<ProfileBloc>(context).add(NavigateToPicturesPageEvent());
              }),
              IconButton(icon: const Icon(Icons.stacked_line_chart, color: Colors.redAccent), onPressed: (){}),
              const Spacer(flex: 1),
              const Badge(
                label: Text("0", style: TextStyle(color: Colors.white)),
                // offset: Offset(1, 3),
                child: Icon(Icons.notifications, color: Colors.redAccent)
              )
            ],
          )
        )
      )
    );
  }
}