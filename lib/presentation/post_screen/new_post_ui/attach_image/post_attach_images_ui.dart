import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_images_bloc/post_images_bloc.dart';

class PostAttachImagesUi extends StatelessWidget {
  const PostAttachImagesUi({super.key});
  @override
  Widget build(BuildContext context) {
    return _attachImageToPostWidget(context);
  }
}

 Widget _attachImageToPostWidget(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Add Image"),
      leading: GestureDetector(
        child: const Icon(Icons.chevron_left, size: 40),
        onTap: (){
          BlocProvider.of<PostBloc>(context).add(PostInitialEvent());
        },
      )
    ),
    body: BlocConsumer(
      bloc: BlocProvider.of<PostImagesBloc>(context),
      buildWhen: (previous, current){
        if(current.runtimeType == PostImagesBlocSelectedImageState ||
           current.runtimeType == PostAddImageLoadingState ||
           current.runtimeType == PostDeletedImageState ||
           current.runtimeType == PostImagesBlocInitial
        ){
          return true;
        }else{
          return false;
        }
      },
      listenWhen: (previous, current){
        if(current.runtimeType == PostImagesBlocImageAlreadyAddedState || current.runtimeType == PostImagesBlocAttachToPostState){
          return true;
        }else{
          return false;
        }
      },
      builder:(context, state){
        print("CURRENT STATE $state");
        if(state.runtimeType == PostAddImageLoadingState){
          if(kDebugMode){
            print("Loading.....");
          }
          return const Center(
            child: Text("Checking Image...")
          );
        }else if(
          state.runtimeType == PostImagesBlocSelectedImageState || 
          state.runtimeType == PostDeletedImageState ||
          state.runtimeType == PostImagesBlocInitial
        ){
          PostImagesBlocState imagesSelectedState;
          List<Attachment>? attachments;

          // Grab the data depending on which state we have
          if(state.runtimeType == PostImagesBlocSelectedImageState){
            imagesSelectedState = state as PostImagesBlocSelectedImageState;
            attachments = (imagesSelectedState as PostImagesBlocSelectedImageState).selectedImages;
          }else if(state.runtimeType == PostDeletedImageState){
            imagesSelectedState = state as PostDeletedImageState;
            attachments = (imagesSelectedState as PostDeletedImageState).selectedImages;
          }else if(state.runtimeType == PostImagesBlocInitial){
            imagesSelectedState = state as PostImagesBlocInitial;
            attachments = (imagesSelectedState as PostImagesBlocInitial).selectedImages;
          }
          

          // Make it happen
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: attachments!.isNotEmpty ? attachments.map((currentImageFile) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      height: 100,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.file(currentImageFile.attachmentFile!),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: FloatingActionButton(
                              backgroundColor: Colors.redAccent,
                              mini: true,
                              onPressed: (){
                                if(kDebugMode){
                                  print("Deleting image.");
                                }
                                BlocProvider.of<PostImagesBloc>(context).add(PostImagesBlocDeleteImageEvent(selectedImage: currentImageFile.attachmentFile!));
                              },
                              child: const Icon(Icons.delete)
                            )
                          )
                        ]
                      )
                    )).toList() : [
                      const Text("Select an image.")
                    ]
                  )
                ),
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 30),
                    TextButton(
                      child: const Text("Add Image"),
                      onPressed:(){
                        try{
                          ImagePicker().pickImage(source: ImageSource.gallery).then((XFile? value){
                            RepositoryProvider.of<PostsRepository>(context).postAddImageUiImageAttachment = File(value!.path);
                            BlocProvider.of<PostImagesBloc>(context).add(PostImagesBlocSelectImageEvent(selectedImage: File(value.path)));
                          });
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    ),
                    const SizedBox(width: 30),
                    TextButton(
                      child: const Text("Done"),
                      onPressed: (){
                        if(kDebugMode){
                          print("Attaching images to the post.");
                        }

                        BlocProvider.of<PostImagesBloc>(context).add(PostImagesBlocAttachToPostEvent());
                      },
                    ),
                  ]
                )
              ]
            )
          );
        }else{
          return Center(
            child: TextButton(
              child: const Text("Select Image"),
              onPressed:(){
                try{
                  ImagePicker().pickImage(source: ImageSource.gallery).then((XFile? value){
                    RepositoryProvider.of<PostsRepository>(context).postAddImageUiImageAttachment = File(value!.path);
                    BlocProvider.of<PostImagesBloc>(context).add(PostImagesBlocSelectImageEvent(selectedImage: File(value.path)));
                  });
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            ),
          );
        }
      }, 
      listener:(context, state){
        if(kDebugMode){
          print("Listener: ");
          print(state);
        }
        if(state.runtimeType == PostImagesBlocImageAlreadyAddedState){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("The image you tried to add has already been added."))
          );
        }else if(state.runtimeType == PostImagesBlocAttachToPostState){
          print("Sending post bloc initial event from the post attach images ui.");
          BlocProvider.of<PostBloc>(context).add(PostInitialEvent());
        }
      }),
  );