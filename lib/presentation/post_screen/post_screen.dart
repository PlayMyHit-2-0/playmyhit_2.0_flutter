import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

class PostScreen extends StatelessWidget {
  // The passed in post.
  final Post? post;
  const PostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    TextEditingController postContentController = TextEditingController();

    Container advertisementUnit() => Container(
      height: MediaQuery.of(context).size.height * 0.2, //20% of the view's height
      width: MediaQuery.of(context).size.height * 0.2, // 20% of the view's height
      color: Colors.black38,
      child: const Icon(Icons.ad_units)
    );

    SingleChildScrollView advertisementArea() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sponsored Ads"),
          Row(
            children: [
              advertisementUnit(),
              advertisementUnit(),
              advertisementUnit()
            ]
          ),
        ],
      )
    );

    SingleChildScrollView newPostUI() => SingleChildScrollView(
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
              
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  mini: true,
                  onPressed: (){
          
                  },
                  child: const Icon(Icons.add_a_photo)
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  mini: true,
                  onPressed: () {

                  },
                  child: const Stack(
                    children: [
                      Icon(Icons.videocam, size: 34),
                      Positioned(
                        top: 7,
                        left: 4,
                        child: Icon(Icons.add, size: 20, color: Colors.white)
                      )
                    ],
                  )
                ),
                const Spacer(),
                FloatingActionButton(
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
                      postText: postContentController.text
                    );
                    BlocProvider.of<PostBloc>(context).add(SavePostEvent(post: newPost));
                  },
                )
              ]
            ),
          ),
          advertisementArea()
        ],
      ),
    );

    return BlocConsumer<PostBloc, PostState>(
        listenWhen: (previous, current){
          if(current.runtimeType == PostSavedState){
            return true;
          }else if(current.runtimeType == PostErrorState){
            return true;
          }

          return false;
        },// Listen when we have an action state
        buildWhen: (previous, current){
          if(current.runtimeType != PostSavedState && current.runtimeType != PostErrorState){
            return true;
          }
          return false;
        }, // And build when we have a regular state
        listener: (context, state) {
          if(kDebugMode){
            print(state.runtimeType);
          }
          switch(state.runtimeType){
            case PostErrorState : // When we throw an error
              var errorState = state as PostErrorState; // grab the error message from the state
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorState.error))); // And show a snackbar with it.
              break;
            case PostSavedState:
              // Show a message letting the user know the post was saved
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Your post has been saved."))
              );

              // Return to the previous screen.
              Navigator.of(context).pop();
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          if(kDebugMode){
            print(state.runtimeType);
          }
          switch (state.runtimeType) {
            case ExistingPostLoadedState:     
              return Scaffold(
                appBar: AppBar(title: const Text("Existing Post")),
              );
            case NewPostState:
              return Scaffold(
                appBar: AppBar(
                  title: const Text("New Post"),
                ),
                body: newPostUI()
              );  
            case PostLoadingState :
              PostMode loadingStateMode = (state as PostLoadingState).mode;

              late String loadingLabel;
              if(loadingStateMode == PostMode.add){
                loadingLabel = "Loading";
              }else if(loadingStateMode == PostMode.edit){
                loadingLabel = "Loading Post";
              }

              return Scaffold(
                appBar: AppBar(
                  title: Text(loadingLabel),
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                )
              );
            case PostInitial:
              BlocProvider.of<PostBloc>(context).add(PostInitialEvent());
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                )
              );
            default:
              return Scaffold(
                appBar: AppBar(title: const Text("Unknown State")),
                body: const Center(
                  child: Text("Unknown State In Post")
                )
              );
          }
        }
     );
  }
}
