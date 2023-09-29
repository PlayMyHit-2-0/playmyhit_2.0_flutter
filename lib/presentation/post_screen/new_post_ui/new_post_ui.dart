import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/add_photos_button.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/add_videos_button.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/advertisement_area.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/submit_post_button.dart';

class NewPostUI extends StatelessWidget {
  final TextEditingController postContentController;

  const NewPostUI({super.key, required this.postContentController});

  @override
  Widget build(BuildContext context) {
    return newPostUI(postContentController: postContentController, context: context);
  }
}

Widget newPostUI(
    {required TextEditingController postContentController,
    required BuildContext context}) => 
    Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: postContentController,
              decoration: const InputDecoration(
                hintText: "Write your post here...",
                label: Text("Post")
              ),
              maxLines: 5,
              onChanged: (newValue){
                BlocProvider.of<PostBloc>(context).add(PostUpdatePostContentText(postContentText: newValue)); 
              },
            ),
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
            const AdvertisementArea()
          ],
        ),
      )
    );