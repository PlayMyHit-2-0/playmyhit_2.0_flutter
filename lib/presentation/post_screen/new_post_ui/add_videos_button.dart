import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

class AddVideosButton extends StatelessWidget {
  const AddVideosButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _addVideosButton(context);
  }
}

Widget _addVideosButton(BuildContext context) => FloatingActionButton(
  heroTag: "AddVideoButton",
  backgroundColor: Colors.red,
  mini: true,
  onPressed: () {
    BlocProvider.of<PostBloc>(context).add(PostAddVideoAttachmentEvent());
  },
  child: const Stack(
    children: [
      Icon(Icons.videocam, size: 34),
      Positioned(
        top: 7,
        left: 4,
        child: Icon(Icons.add, size: 20, color: Colors.white)
      )
    ],
  )
);
