import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_videos_bloc/post_videos_bloc.dart';

class PostAttachVideosUi extends StatelessWidget {
  const PostAttachVideosUi({super.key});
  @override
  Widget build(BuildContext context) {
    return _attachVideoToPostWidget(context);
  }
}

 Widget _attachVideoToPostWidget(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Add Video"),
      leading: GestureDetector(
        child: const Icon(Icons.chevron_left, size: 40),
        onTap: (){
          BlocProvider.of<PostBloc>(context).add(PostInitialEvent());
        },
      )
    ),
    body: BlocConsumer(
      bloc: BlocProvider.of<PostVideosBloc>(context),
      buildWhen: (previous, current){
        return false;
      },
      listenWhen: (previous, current){
        return false;
      },
      builder:(context, state){
        return Column(
          children: [
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // children: RepositoryProvider.of<PostsRepository>(context).postAddVideoUiVideoAttachments?.map((item){
                //   item.
                // }).toList() ?? [],
                children: [],
              ),
            ), 
            TextButton(onPressed: (){

            }, child: const Text("Select Video"))
          ],
        );
      }, 
      listener:(context, state){
        
      }),
  );