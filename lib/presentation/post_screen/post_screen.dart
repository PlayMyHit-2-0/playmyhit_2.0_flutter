import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/presentation/post_screen/default_post_ui/default_post_ui.dart';
import 'package:playmyhit/presentation/post_screen/new_post_ui/new_post_ui.dart';
import 'package:playmyhit/presentation/post_screen/post_attach_images_ui.dart';
import 'package:playmyhit/presentation/post_screen/post_loading_ui.dart';

class PostScreen extends StatelessWidget {
  // The passed in post.
  final Post? post;
  const PostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    TextEditingController postContentController = TextEditingController();
    
    // Pull the text from the repo
    postContentController.text = RepositoryProvider.of<PostsRepository>(context).currentPostText ?? "";

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
            case PostUpdatedContentTextState:
              return BlocProvider.value(
                value: BlocProvider.of<PostBloc>(context),
                child: NewPostUI(postContentController: postContentController)
              );  
            case PostLoadingState :
              PostMode loadingStateMode = (state as PostLoadingState).mode;
              late String loadingLabel;
              if(loadingStateMode == PostMode.add){
                loadingLabel = "Loading";
              }else if(loadingStateMode == PostMode.edit){
                loadingLabel = "Loading Post";
              }
              return PostLoadingUI(loadingLabel: loadingLabel);
            case PostInitial:
              BlocProvider.of<PostBloc>(context).add(PostInitialEvent());
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                )
              );
            case PostShowImageUploadUIState:
              return const PostAttachImagesUi();
            default:
              return const DefaultPostUI();
          }
        }
     );
  }
}
