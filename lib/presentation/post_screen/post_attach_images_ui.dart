import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

class PostAttachImagesUi extends StatelessWidget {
  const PostAttachImagesUi({super.key});
  @override
  Widget build(BuildContext context) {
    return _attachImageToPostWidget(context);
  }
}

 Widget _attachImageToPostWidget(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Add Image")
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Image.file(
          //   BlocProvider.of<PostBloc>(context).postsRepository.postUiImageAttachment ?? ,
          //   errorBuilder: (context, error, stackTrace) => const Icon(Icons.bug_report),
          // ),
          _selectedImageFile(context),
          TextButton(
            child: const Text("Select Image"),
            onPressed:(){
              try{
                ImagePicker().pickImage(source: ImageSource.gallery).then((value) => {
                  //TODO: Do something with the selected image
                });
              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          )
        ],
      )
    )
  );

  Widget _selectedImageFile(BuildContext context) => BlocProvider.of<PostBloc>(context).postsRepository.postUiImageAttachment != null ? Image.file(
    BlocProvider.of<PostBloc>(context).postsRepository.postUiImageAttachment!,
    errorBuilder: (context, error, stackTrace) => const Icon(Icons.bug_report),
  ) : const Icon(Icons.bug_report);
