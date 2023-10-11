import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/enumerations/attachment_type.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostsRepository postsRepository;

  PostBloc({required this.postsRepository}) : super(PostInitial(mode: PostMode.add, imageAttachments: null, videoAttachments: null, audioAttachments: null, pdfAttachments: null, postContentText: null)) {
    on<PostInitialEvent>((event, emit) async {
      emit(PostLoadingState(
        mode: PostMode.add
      ));

      // Clear out the post attachments
      postsRepository.postAttachments = [];

      // await Future.delayed(const Duration(seconds: 2), ()=>{});
      emit(PostInitial(mode: PostMode.add, imageAttachments: null, videoAttachments: null, audioAttachments: null, pdfAttachments: null, postContentText: null));
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

    on<PostDeleteAttachmentEvent>((event, emit){
      try {
        // Grab the selected image from the event
        File? selectedImage = event.selectedAttachmentFile;

        // Remove the image from the post image attachments list in the posts repo
        // postsRepository.postUiImageAttachments.remove(selectedImage);
        postsRepository.postAttachments.removeWhere((Attachment item)=>item.attachmentFile == selectedImage);

        // Filter the list of attachments for images only
        List<Attachment> imageAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.image).toList();

        // Fileter the list of attachments for videos only
        List<Attachment> videoAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.video).toList();

        // Fileter the list of attachments for audio files only
        List<Attachment> audioAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.audio).toList();

        // Fileter the list of attachments for pdf files only
        List<Attachment> pdfAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.pdf).toList();

        String postContentText = postsRepository.currentPostText;
        
        // Emit an initial event 
        emit(PostInitial(
          mode: PostMode.add,
          imageAttachments: imageAttachments, 
          videoAttachments: videoAttachments, 
          audioAttachments: audioAttachments, 
          pdfAttachments: pdfAttachments, 
          postContentText: postContentText
          )
        );
      }catch(error){
        if(kDebugMode){
          print("Error while removing attached image on the post bloc.");
        }

        emit(PostErrorState(error: error.toString()));
      }
    });

    on<PostAddImageAttachmentEvent>((event,emit){
      emit(PostShowImagePickerState());
    });

    on<PostAddVideoAttachmentEvent>((event, emit){
      emit(PostShowVideoPickerState());
    });

    on<PostAttachmentsSelectedEvent>((event, emit){
      // Convert selected images to a list of Attachment
      List<File> selectedAttachments = event.selectedAttachments;
      List<Attachment> attachments = [];
      
      // Map the incoming files to attachments
      attachments = selectedAttachments.map((item)=>Attachment(item, attachmentType: event.type, attachmentUrl: null)).toList(); 

      // Store them in the repo.
      for(Attachment a in attachments){
        postsRepository.postAttachments.add(a);
      }

      // Filter the list of attachments for images only
      List<Attachment> imageAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.image).toList();

      // Fileter the list of attachments for videos only
      List<Attachment> videoAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.video).toList();

      if(kDebugMode){
        print("Attached Videos: ");
        print(videoAttachments);
      }

      // Fileter the list of attachments for audio files only
      List<Attachment> audioAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.audio).toList();

      // Fileter the list of attachments for pdf files only
      List<Attachment> pdfAttachments = postsRepository.postAttachments.where((item)=>item.attachmentType == AttachmentType.pdf).toList();

      String postContentText = postsRepository.currentPostText;

      // Emit a images selected state
      emit(PostInitial(
        mode: PostMode.add,
        imageAttachments: imageAttachments, 
        videoAttachments: videoAttachments,
        audioAttachments: audioAttachments, 
        pdfAttachments: pdfAttachments,
        postContentText: postContentText
        )
      );
    });
  }
}
