import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
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


    on<PostAddImageAttachmentEvent>((event, emit)=>emit(PostShowImageUploadUIState(postAttachments: null)));

    on<PostUpdatePostContentText>((event, emit){
      postsRepository.currentPostText = event.postContentText;
      emit(PostUpdatedContentTextState(newPostContentText: postsRepository.currentPostText!));
    });
  }
}
