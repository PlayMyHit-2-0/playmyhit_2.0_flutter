import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostsRepository postsRepository;

  PostBloc({required this.postsRepository}) : super(PostInitial(mode: PostMode.add)) {
    on<PostInitialEvent>((event, emit) async {
      emit(PostLoadingState(
        mode: PostMode.add
      ));
      // await Future.delayed(const Duration(seconds: 2), ()=>{});
      emit(NewPostState());
    });

    on<LoadPostEvent>((event, emit) async {
      String postId = event.postId;
      String uid = event.uid;
      postsRepository.profileUid = uid;
      try {
        Post selectedPost =(await postsRepository.postsStream.last).firstWhere((p) => p.postId == postId);
        emit(ExistingPostLoadedState(post: selectedPost));
      }catch(e){
        emit(PostErrorState(error: e.toString()));
      } 
    });

    on<SavePostEvent>((event, emit) async {
      try{
        // Save the post to firestore
        await postsRepository.savePost(event.post);
        
        // Clear the previous post contents
        emit(PostSavedState());
      }catch(e){
        emit(PostErrorState(error: e.toString()));
      }
    });

    on<NewPostEvent>((event, emit){
      emit(PostInitial(mode: PostMode.add));  
    });

    on<PostAddImageAttachmentEvent>((event, emit){

      if(postsRepository.postUiImageAttachments.isNotEmpty){
        // Copy the images attachments for the post to the image attachments of the post image ui
        postsRepository.postAddImageUiImageAttachments = postsRepository.postUiImageAttachments;
      } 

      // Send them to the post images upload ui
      emit(PostShowImageUploadUIState(postAttachments: postsRepository.postUiImageAttachments));
    });

    on<PostAddVideoAttachmentEvent>((event, emit){
      emit(PostShowVideoUploadUIState(postAttachments: null));
    });

    on<PostUpdatePostContentText>((event, emit){
      postsRepository.currentPostText = event.postContentText;
      emit(PostUpdatedContentTextState(newPostContentText: postsRepository.currentPostText!));
    });

    on<PostDeleteImageEvent>((event, emit){
      try {
        // Grab the selected image from the event
        File? selectedImage = event.selectedImage;

        // Remove the image from the post image attachments list in the posts repo
        // postsRepository.postUiImageAttachments.remove(selectedImage);
        postsRepository.postUiImageAttachments.removeWhere((Attachment item)=>item.attachmentFile == selectedImage);


        // Emit an initial event 
        emit(PostInitial(mode: PostMode.add));
      }catch(error){
        if(kDebugMode){
          print("Error while removing attached image on the post bloc.");
        }

        emit(PostErrorState(error: error.toString()));
      }
    });
  }
}
