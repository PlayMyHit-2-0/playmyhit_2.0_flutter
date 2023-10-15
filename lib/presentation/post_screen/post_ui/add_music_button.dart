import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

class AddMusicButton extends StatelessWidget{
  const AddMusicButton({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    heroTag: "AddMusicButton",
    backgroundColor: Colors.red,
    mini: true,
    onPressed: (){
      print("Pressed add music button");
      BlocProvider.of<PostBloc>(context).add(PostAddAudioAttachmentEvent());
    },
    child: const Icon(Icons.audio_file)
  );
}