import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final PostsRepository postsRepository;
  final PostBloc postsBloc;
  late StreamSubscription postsStateSubscription;
  ProfileBloc({required this.postsRepository, required this.postsBloc}) : super(ProfileInitial()) {
    on<ProfileInitialEvent>((event, emit) async {
        emit(ProfileLoadingState());

        // Start listening to posts for the currently logged in user.
        postsRepository.profileUid = postsRepository.auth.currentUser?.uid;

        // Return the stream of posts for the currently logged in user.
        await Future.delayed(const Duration(seconds: 4), () async {
          emit(ProfileLoadedState(posts: await postsRepository.postsStream.first));
          emit(ProfileScrollToTopState());
        });
    });

    on<ScrollToTopEvent>((event,emit){
      if(kDebugMode){
        print("Received scroll to top event. Emitting profile scroll to top state.");
      }
      emit(ProfileScrollToTopState());
    });

    on<NavigateToMusicPageEvent>((event, emit){
      emit(NavigateToMusicPageState());
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

        add(ScrollToTopEvent());
      }
    });

  }

  @override
  Future<void> close() {
    postsStateSubscription.cancel();
    return super.close();
  }


}
