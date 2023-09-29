import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

class AddPhotosButton extends StatelessWidget{
  const AddPhotosButton({super.key});

  @override
  Widget build(BuildContext context){
    return _addPhotosButton(context); 
  }
}

Widget _addPhotosButton(BuildContext context) => FloatingActionButton(
  heroTag: "AddPhotoButton",
  backgroundColor: Colors.red,
  mini: true,
  onPressed: (){
    // Send b
    BlocProvider.of<PostBloc>(context).add(PostAddImageAttachmentEvent());
  },
  child: const Icon(Icons.add_a_photo)
);