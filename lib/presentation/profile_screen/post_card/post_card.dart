import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/enumerations/attachment_type.dart';
import 'package:playmyhit/data/enumerations/poopometer_layout_direction.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/presentation/common_widgets/video_item.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/like_dislike_gesture_ui/like_dislike_gesture_ui.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/post_audio.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/post_images.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/post_owner_image.dart';
import 'package:playmyhit/presentation/profile_screen/post_card/post_videos.dart';

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
      // print("Retrieving the username for the user with the ID: $postOwnerId");
      // print("Username Retrieved: $postOwnerUsername");
    }
    return Future.value(postOwnerUsername);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPostOwnerUsername(context,widget.post.postOwnerId!),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return postContainer(snapshot.data.toString(), widget.post,fireOpacityController, context);
        }else{
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

Widget postContainer(String username,Post post, AnimationController? fireOpacityController, BuildContext context){
  
  String flipDate(String dt){
    String datePart = dt.split(" ").first;
    String timePart = dt.split(" ")[1];

    List<String> dateParts = datePart.split("/");
    String year = dateParts[0];
    String month = dateParts[1];
    String day = dateParts[2];
    
    return "$month/$day/$year $timePart";
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Container(
      margin: const EdgeInsets.only(bottom: 5),
      color: Colors.white38,
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                post.postOwnerId != null ? PostOwnerImage(post: post) : const CircleAvatar(child: Icon(Icons.image)),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(flipDate(post.postCreatedAt!.toDate().toString().split(".").first.replaceAll("-", "/")), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300))
                  ]
                ),
                const Spacer(flex: 1),
                FloatingActionButton(
                  heroTag: post.hashCode,
                  mini: true,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.redAccent,
                  child: const Icon(Icons.delete),
                  onPressed: (){
                    print("Call bloc logic to delete this post.");
                  },
                )
              ]
            ),
          ),
          // const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 40, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      post.postText == null ? const Text("") : Text(post.postText!),
                    ]
                  )
                ),
              ]
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            height: post.postAttachments!.where(
                  (element) => element.attachmentType == AttachmentType.image).isNotEmpty ? 200 : 0,
            width: MediaQuery.of(context).size.width,
            child: PostImages(post: post,),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            height: post.postAttachments!.where((element) => element.attachmentType == AttachmentType.video).isNotEmpty? 400 : 0,
            width: MediaQuery.of(context).size.width,
            // child: VideoItem()
            child: PostVideos(post: post)
          ),
          Container(
            padding: const EdgeInsets.all(8),
            height: post.postAttachments!.where((element)=> element.attachmentType == AttachmentType.audio).isNotEmpty ? 50 : 0,
            width: MediaQuery.of(context).size.width,
            child: PostAudio(post: post)
          ),
          Container(
            padding: const EdgeInsets.all(8),
            // color: Colors.black12,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.black12
                ]
              ),
              borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                const Badge(
                  label: Text("10", style: TextStyle(color: Colors.white)),
                  // padding: EdgeInsets.all(10),
                  offset: Offset(10, -9),
                  child: Text("Comments "), 
                ),
                const Spacer(flex: 1),
                LikeDislikeGestureUI(
                  value: 25.0,
                  layoutDirection: PoopometerLayoutDirection.horizontal,
                  onSlideEnd: (value){
                    if(kDebugMode){
                      print(value.toString());
                    }
                  },
                  onSlideStart: (value){
                    if(kDebugMode){
                      print("Slider at $value");
                    }
                  },
                  onSlideUpdate: (value){
                    if(kDebugMode){
                      print("Slider at $value");
                    }
                  },
                )
              ]
            )
          ),
         
          // Text(post.postAttachments?.where((element) => element.attachmentType == AttachmentType.image).length.toString() ?? ""),
          // Text(post.postAttachments?.length.toString() ?? "0")
        ],
      )
    ),
  );
}