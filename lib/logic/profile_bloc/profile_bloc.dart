import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final PostsRepository postsRepository;
  final PostBloc postsBloc;
  late StreamSubscription postsStateSubscription;
  late StreamSubscription postsStreamSubscription; 
  List<Post> cachedPosts = [];
  ProfileBloc({required this.postsRepository, required this.postsBloc}) : super(ProfileInitial()) {
    on<ProfileInitialEvent>((event, emit) async {
        emit(ProfileLoadingState());

        // Start listening to posts for the currently logged in user.
        postsRepository.profileUid = postsRepository.auth.currentUser?.uid;

        // Return the stream of posts for the currently logged in user.
        await Future.delayed(const Duration(seconds: 0), () async {
          emit(ProfileLoadedState(posts: event.posts));
          emit(ProfileScrollToTopState());
        });
    });

    on<ScrollToTopEvent>((event,emit){
      if(kDebugMode){
        print("Received scroll to top event. Emitting profile scroll to top state.");
      }
      emit(ProfileScrollToTopState());
    });

    on<NavigateToMusicPageEvent>((event, emit) async {
      
      List<Attachment> musicAttachments = await postsRepository.postsMusicAttachments.first;

      emit(NavigateToMusicPageState(myMusicAttachments: musicAttachments));
    });

    on<NavigateToVideosPageEvent>((event, emit) async {
      
      List<Attachment> videoAttachments = await postsRepository.postsVideoAttachments.first;

      emit(NavigateToVideosPageState(myVideoAttachments: videoAttachments));
    });

    on<NavigateToPicturesPageEvent>((event, emit) async {

      List<Attachment> pictureAttachments = await postsRepository.postsPictureAttachments.first;

      emit(NavigateToPicturesPageState(myPictureAttachments: pictureAttachments));
    });


    
    postsStateSubscription = postsBloc.stream.listen((st) {
      if(kDebugMode){
        print("Received state from the PostBloc in the ProfileBloc");
        print(st.runtimeType);
      }

      if(st.runtimeType == PostSavedState){
        if(kDebugMode){
          print("Received PostSavedState from PostBloc");
        }

        Future.delayed(const Duration(milliseconds: 500),(){
          add(ProfileInitialEvent(posts: cachedPosts));
        });
      }
    });

    postsStateSubscription = postsRepository.postsStream.listen((posts) {
      if(kDebugMode){
        print("Received new posts. Updating the profile UI.");
      }

      cachedPosts = posts; 
      Future.delayed(const Duration(milliseconds: 500),(){
        add(ProfileInitialEvent(posts: posts));
      });
    });

  }

  @override
  Future<void> close() {
    postsStateSubscription.cancel();
    postsStateSubscription.cancel();
    postsBloc.close();
    return super.close();
  }
}
