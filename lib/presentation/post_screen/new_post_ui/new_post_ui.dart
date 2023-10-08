import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/add_photos_button.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/add_videos_button.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/advertisement_area.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/submit_post_button.dart';

class NewPostUI extends StatefulWidget {
  final TextEditingController postContentController;

  const NewPostUI({super.key, required this.postContentController});
  
  @override
  State<StatefulWidget> createState() {
    return NewPostUIState();
  }
}

class NewPostUIState extends State<NewPostUI>{

  bool visible = false;

  @override
  void initState() {
    // Start with it hidden
    visible = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     //In 1 second show it
    Future.delayed(const Duration(milliseconds: 0),(){
      if(mounted){
        setState(() {
          visible = true;
        }); 
      }
    });
    // return newPostUI(postContentController: widget.postContentController, context: context);
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: newPostUI(postContentController: widget.postContentController, context: context, attachments: RepositoryProvider.of<PostsRepository>(context).postUiImageAttachments)
    );
  }
}

Widget newPostUI(
    {required TextEditingController postContentController,
    required BuildContext context, List<File>? attachments}) => 
  Scaffold(
    appBar: AppBar(
      title: const Text("New Post"),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          postContentsLabel,
          postContentTextField(postContentController, context),
          Padding(
            padding: const EdgeInsets.all(10),
            child: BlocProvider.value(
              value: BlocProvider.of<PostBloc>(context),
              child: const Row(
                children: [
                  AddPhotosButton(),
                  SizedBox(width: 10),
                  AddVideosButton(),
                  Spacer(),
                  SubmitPostButton()
                ]
              )
            ),
          ),
          // Images Attachemnts
          RepositoryProvider.of<PostsRepository>(context).postUiImageAttachments.isNotEmpty ? imagesAttachedLabel : Container(),
          const SizedBox(height: 8),
          RepositoryProvider.of<PostsRepository>(context).postUiImageAttachments.isNotEmpty ? attachedImagesList(attachments, context) : Container(),
          const AdvertisementArea()
        ],
      ),
    )
  );


Widget attachedImagesList(List<File>? attachments, BuildContext context) => SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: attachments?.map((currentImageFile) => SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Image.file(currentImageFile),
          Positioned(
            right: 10,
            top: 10,
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              mini: true,
              onPressed: (){
                if(kDebugMode){
                  print("Deleting image.");
                }
                BlocProvider.of<PostBloc>(context).add(PostDeleteImageEvent(selectedImage: currentImageFile));
              },
              child: const Icon(Icons.delete)
            )
          )
        ]
      )
    )).toList() ?? [
      const Text("Select an image.")
    ]
  )
);

Widget imagesAttachedLabel = const Row(
  children: [
    Text("Images Attached:", textAlign: TextAlign.start,),
    Spacer(flex: 2),
  ]
);

Widget postContentsLabel = const Row(
  children: [
    Text("Post Contents:", textAlign: TextAlign.start,),
    Spacer(flex: 2),
  ]
);

Widget postContentTextField(TextEditingController postContentController, BuildContext context) =>  TextField(
  controller: postContentController,
  decoration: const InputDecoration(
    hintText: "Write your post here...",
    label: Text("Post")
  ),
  maxLines: 5,
  onChanged: (newValue){
    BlocProvider.of<PostBloc>(context).add(PostUpdatePostContentText(postContentText: newValue)); 
  },
);