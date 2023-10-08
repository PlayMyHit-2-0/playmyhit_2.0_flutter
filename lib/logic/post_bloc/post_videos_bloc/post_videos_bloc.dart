import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'post_videos_event.dart';
part 'post_videos_state.dart';

class PostVideosBloc extends Bloc<PostVideosEvent, PostVideosState> {
  PostVideosBloc() : super(PostVideosInitial()) {
    on<PostVideosEvent>((event, emit) {
    });
  }
}
