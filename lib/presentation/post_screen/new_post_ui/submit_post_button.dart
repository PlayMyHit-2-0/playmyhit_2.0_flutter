import 'package:flutter/material.dart';

class SubmitPostButton extends StatelessWidget{
  const SubmitPostButton({super.key});
  
  @override
  Widget build(BuildContext context){
    return _addVideosButton(context);
  }
}

Widget _addVideosButton(BuildContext context) => FloatingActionButton(
  heroTag: "AddVideoButton",
  backgroundColor: Colors.red,
  mini: true,
  onPressed: () {

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
