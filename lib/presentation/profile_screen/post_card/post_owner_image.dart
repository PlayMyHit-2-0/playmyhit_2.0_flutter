import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';

class PostOwnerImage extends StatelessWidget {
  final Post post;
  const PostOwnerImage({super.key, required this.post});

  Future<String?> postOwnerImageUrl(BuildContext context, String postOwnerId) async {
    try{
      Map<String,dynamic> postOwnerSettings = await RepositoryProvider.of<PostsRepository>(context).getPostOwnerSettings(postOwnerId);
      String postOwnerProfileImageUrl = postOwnerSettings["settings"]["profileImageUrl"];
      if(kDebugMode){
        // print("Retrieving profile image url for the post owner with id $postOwnerId");
        // print("Profile Image Url Retrieved: $postOwnerProfileImageUrl");
      }
      return postOwnerProfileImageUrl;
    }catch(e){
      if(kDebugMode){
        print("Found an error while attempting to get the profile settings for the owner of the post.");
        print(e.toString());
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postOwnerImageUrl(context, post.postOwnerId!),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return CircleAvatar(
            radius: 40,
            backgroundImage: Image.network(snapshot.data as String).image
          );
          // return const Icon(Icons.image);
        }else{
          return const CircularProgressIndicator();
        }
      }
    );
  }  
}