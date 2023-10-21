import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/enumerations/attachment_type.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/presentation/post_screen/default_post_ui/default_post_ui.dart';
import 'package:playmyhit/presentation/post_screen/loading_post_ui/post_loading_ui.dart';
import 'package:playmyhit/presentation/post_screen/post_ui/post_ui.dart';

class PostScreen extends StatefulWidget {
  // The passed in post.
  final Post? post;
  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController postContentController = TextEditingController();
    
    // Pull the text from the repo
    postContentController.text = RepositoryProvider.of<PostsRepository>(context).currentPostText;

    return BlocConsumer<PostBloc, PostState>(
        listenWhen: (previous, current){
          if(current.runtimeType == PostSavedState){
            return true;
          }else if(current.runtimeType == PostErrorState){
            return true;
          }else if(current.runtimeType == PostShowImagePickerState){
            return true;
          }else if(current.runtimeType == PostShowVideoPickerState){
            return true;
          }else if(current.runtimeType == PostShowAudioPickerState){
            return true;
          }

          return false;
        },// Listen when we have an action state
        buildWhen: (previous, current){
          if(current.runtimeType != PostSavedState 
          && current.runtimeType != PostErrorState
          && current.runtimeType != PostShowImagePickerState 
          && current.runtimeType != PostShowVideoPickerState
          && current.runtimeType != PostShowAudioPickerState){
            return true;
          }
          return false;
        }, // And build when we have a regular state
        listener: (context, state) {
          if(kDebugMode){
            print("PostListener: ${state.runtimeType}");
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
            case PostShowImagePickerState:
              try {
                FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true,).then((result){
                  if(result != null){
                    List<File> files = result.files.map((e) => File(e.path!)).toList();
                    BlocProvider.of<PostBloc>(context).add(PostAttachmentsSelectedEvent(selectedAttachments: files,type: AttachmentType.image));
                  }
                });
              }catch(error){
                if(kDebugMode){
                  print(error);
                }
              }
              break;
            case PostShowVideoPickerState:
              try {
                FilePicker.platform.pickFiles(type: FileType.video, allowMultiple: true, onFileLoading: (FilePickerStatus status){
                  BlocProvider.of<PostBloc>(context).add(PostVideoLoadingEvent(status: status.name));
                }).then((result){
                  if(result != null){
                    List<File> files = result.files.map((e) => File(e.path!)).toList();
                    BlocProvider.of<PostBloc>(context).add(PostAttachmentsSelectedEvent(selectedAttachments: files, type: AttachmentType.video));
                  }
                });
              }catch(error){
                if(kDebugMode){
                  print(error);
                }
              }
              break;
            case PostShowAudioPickerState:
              try{
                FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['mp3', 'aac', 'wav'], 
                  allowMultiple: true, 
                  onFileLoading: (FilePickerStatus status){
                    // BlocProvider.of<PostBloc>(context).ad
                    if(kDebugMode){
                      print("Loading selected audio files..");
                    }
                  }
                ).then((result){
                  if(result != null){
                    List<File> files = result.files.map((e) => File(e.path!)).toList();

                    if(kDebugMode){
                      print("Audio files selected:");
                      print("${files.length}");
                    }

                    BlocProvider.of<PostBloc>(context).add(PostAttachmentsSelectedEvent(selectedAttachments: files, type: AttachmentType.audio));
                  }else{
                    if(kDebugMode){
                      print("The results of picking audio files was empty.");
                    }
                  }
                });
              }catch(error){
                if(kDebugMode){
                  print(error);
                }
              }
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
            case PostInitial:
              List<Attachment> attachedImages = [];
              List<Attachment> attachedVideos = [];
              List<Attachment> attachedAudio = [];
              List<Attachment> attachedPdf = [];

              PostInitial st = state as PostInitial;
              attachedImages = st.imageAttachments ?? [];
              attachedVideos = st.videoAttachments ?? [];
              attachedAudio = st.audioAttachments ?? [];
              
              return BlocProvider.value(
                value: BlocProvider.of<PostBloc>(context),
                child: PostUI(
                  postContentController: postContentController, 
                  attachedImageFiles: attachedImages,
                  attachedVideoFiles: attachedVideos,
                  attachedAudioFiles: attachedAudio,
                  attachedPdfFiles: attachedPdf,
                )
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
            case PostVideoLoadingState:
              String status = (state as PostVideoLoadingState).status;
              return Scaffold(
                appBar: AppBar(title: const Text("Loading")),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(status == "picking" ? "Loading Selected Videos" : status)
                    ),
                    const SizedBox(height: 20,),
                    const CircularProgressIndicator()
                  ]
                )
              );
            case PostFilesUploadingState:
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Uploading Files"),
                ),
                body: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Uploading Attached Files..."),
                          SizedBox(height: 8),
                          CircularProgressIndicator()
                        ]
                      ),
                    ),
                  )
                )
              );
            default:
              return const DefaultPostUI();
          }
        }
     );
  }
}
