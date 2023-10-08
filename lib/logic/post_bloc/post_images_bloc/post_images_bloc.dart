import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_compare/image_compare.dart';
import 'package:bloc/bloc.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
part 'post_images_bloc_event.dart';
part 'post_images_bloc_state.dart';

class PostImagesBloc extends Bloc<PostImagesBlocEvent, PostImagesBlocState> {
  
  PostsRepository postsRepository;

  PostImagesBloc({required this.postsRepository}) : super(PostImagesBlocInitial(selectedImages: const [])) {
    on<PostImagesBlocEvent>((event, emit) {
    });


    on<PostImagesBlocSelectImageEvent>((event,emit) async {
      try{
        File? selectedImage = event.selectedImage;
        bool exists = false;

        emit(PostAddImageLoadingState());

        for (var element in postsRepository.postAddImageUiImageAttachments) {
          if(await compareImages(src1: element, src2: selectedImage) == 0){
            emit(PostImagesBlocImageAlreadyAddedState());
            emit(PostImagesBlocSelectedImageState(selectedImages: postsRepository.postAddImageUiImageAttachments));
            exists = true;
            break;
          }
        }


        // If the image has not been added yet, add it
        if(!exists){
          if(kDebugMode){
            print("PostImagesBloc PostImagesBlocSelectImageEvent received.");
          }

          // If the list of attachments is null, set it to an empty list.
          if(postsRepository.postAddImageUiImageAttachment == null){
            postsRepository.postAddImageUiImageAttachments = [];
          }

          // Add the selected image to the list of attachments.
          postsRepository.postAddImageUiImageAttachments.add(selectedImage);

          // Show em.
          emit(PostImagesBlocSelectedImageState(selectedImages: postsRepository.postAddImageUiImageAttachments));

          if(kDebugMode){
            print("PostImagesBloc emitted PostImagesBlocSelectedImageState");
          }
        }
      }catch (error){
         if(kDebugMode){
          print("There was an error while attempting to add the selected image.");
          print(error);
        }


        emit(PostImagesBlocErrorState(error: "There was an error while adding the selected image."));
      }
    });

    on<PostImagesBlocDeleteImageEvent>((event, emit){
      try{
        // Grab the incoming image from the incoming bloc event
        File? selectedImage = event.selectedImage;

        //Remove the image from the attachments list
        postsRepository.postAddImageUiImageAttachments.remove(selectedImage);


        //Emit an image deleted state
        emit(PostDeletedImageState(selectedImages: postsRepository.postAddImageUiImageAttachments));
      }catch (error){

        if(kDebugMode){
          print("There was an error while attempting to delete the selected image.");
          print(error);
        }


        emit(PostImagesBlocErrorState(error: "There was an error while deleting your image. Please try again."));
      }
    });

    on<PostImagesBlocAttachToPostEvent>((event, emit){
      try{
        if(kDebugMode){
          print("Attaching images to the post from the post images bloc.");
        }
        
        // Copy the attachments from the post image ui to the post ui attachments
        postsRepository.postUiImageAttachments = postsRepository.postAddImageUiImageAttachments;

        // Clear the post images ui attachments list
        postsRepository.postAddImageUiImageAttachments = [];

        // Emit an action state to get sent back to the post screen
        emit(PostImagesBlocAttachToPostState());

      }catch (error) {
        if(kDebugMode){
          print("There was an error while attempting to attach images to the post.");
        }
        emit(PostImagesBlocErrorState(error: error.toString()));
        // Send them back to the post UI
        emit(PostImagesBlocAttachToPostState());
      }
    });

    on<PostImagesBlocLoadEvent>((event, emit){
      try{
        // Copy the image attachments from the post ui to the post images ui
        postsRepository.postAddImageUiImageAttachments = postsRepository.postUiImageAttachments;

        // Show them on the post images UI
        emit(PostImagesBlocInitial(selectedImages: postsRepository.postAddImageUiImageAttachments));

      }catch (error) {
        if(kDebugMode){
          print("There was an error while initializing the post add image ui");
        }
        emit(PostImagesBlocErrorState(error: error.toString()));
      }
    });
  }
}
