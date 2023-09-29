import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/post_owner_image.dart';

class PostCard extends StatelessWidget{
  final Post post;
  const PostCard({super.key, required this.post});
  
  Future<String> getPostOwnerUsername(BuildContext context,String postOwnerId) async {
    String postOwnerUsername = await RepositoryProvider.of<PostsRepository>(context).getPostOwnerUsername(postOwnerId);
    if(kDebugMode){
      print("Retrieving the username for the user with the ID: $postOwnerId");
      print("Username Retrieved: $postOwnerUsername");
    }
    return Future.value(postOwnerUsername);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FutureBuilder(
        future: getPostOwnerUsername(context, post.postOwnerId!),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Text(snapshot.data.toString());
          }else{
            return const CircularProgressIndicator();
          }
        },
      ),
      leading: post.postOwnerId != null ? PostOwnerImage(post: post) : const CircleAvatar(child: Icon(Icons.image)),
      subtitle: post.postText == null ? const Text("") : Text(post.postText!)
    );
  }
}