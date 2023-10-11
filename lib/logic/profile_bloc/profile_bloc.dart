import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/data/repositories/posts_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final PostsRepository postsRepository;

  ProfileBloc({required this.postsRepository}) : super(ProfileInitial()) {
    on<ProfileInitialEvent>((event, emit)  {
      emit(ProfileLoadingState());

      // Start listening to posts for the currently logged in user.
      postsRepository.profileUid = postsRepository.auth.currentUser?.uid;

      // Return the stream of posts for the currently logged in user.
      Future.delayed(const Duration(seconds: 4), () async =>emit(ProfileLoadedState(posts: await postsRepository.postsStream.first)));
    });
  }


}
