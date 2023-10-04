import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/like_dislike_gesture_ui/like_dislike_gesture_ui.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/post_owner_image.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<StatefulWidget> createState() {
    return PostCardState();
  }

}

class PostCardState extends State<PostCard> with TickerProviderStateMixin{

  AnimationController? fireOpacityController;

  @override
  initState(){
    fireOpacityController = AnimationController(vsync: this);
    fireOpacityController?.value = 0;
    super.initState();
  }

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
    return FutureBuilder(
      future: getPostOwnerUsername(context,widget.post.postOwnerId!),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return postContainer(snapshot.data.toString(), widget.post,fireOpacityController!);
        }else{
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

Widget postContainer(String username,Post post, AnimationController fireOpacityController){
  
  return Padding(
    padding: const EdgeInsets.all(6),
    child:   Stack(
      children: [
         ClipRRect(
          borderRadius: BorderRadius.circular(20),
           child: Container(
            height: 290,
            decoration: BoxDecoration(
              image: DecorationImage(
                repeat: ImageRepeat.repeatX,
                  alignment: const Alignment(0, 0),
                  image: Image.asset(
                    "assets/images/flames_animation.gif",
                    fit: BoxFit.cover,
                    opacity: fireOpacityController,
                  ).image
              )
            ),
                 ),
         ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 290,
            color: const Color.fromARGB(210, 0, 0, 0),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  post.postOwnerId != null ? PostOwnerImage(post: post) : const CircleAvatar(child: Icon(Icons.image)),
                  const SizedBox(width: 10),
                  Text(username),
                ]
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: post.postText == null ? const Text("") : Text(post.postText!),
                  ),
                  const LikeDislikeGestureUI()
                ]
              )
            ],
          ),
        ),
      ],
    ),
  );
}