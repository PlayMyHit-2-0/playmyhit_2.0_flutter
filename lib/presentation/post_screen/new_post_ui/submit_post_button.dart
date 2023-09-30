import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

class SubmitPostButton extends StatelessWidget{
  const SubmitPostButton({super.key});

  @override
  Widget build(BuildContext context){
    return _submitPostButton(context);
  }
}


Widget _submitPostButton(BuildContext context) => FloatingActionButton(
  heroTag: "SubmitPostButton",
  backgroundColor: Colors.redAccent,
  mini: true,
  child: const Icon(Icons.post_add),
  onPressed: () {
    Post newPost = Post(
      postAttachments: [],
      postCreatedAt: Timestamp.fromDate(DateTime.now()),
      postId: null,
      postImageUrl: null,
      postOwnerId: RepositoryProvider.of<PostsRepository>(context).auth.currentUser?.uid,
      postText: RepositoryProvider.of<PostsRepository>(context).currentPostText
    );
    BlocProvider.of<PostBloc>(context).add(SavePostEvent(post: newPost));
  },
);