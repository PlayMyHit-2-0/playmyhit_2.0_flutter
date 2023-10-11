import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/presentation/common_widgets/vigo_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
    final File video;

    const VideoItem({required this.video, super.key});

    @override
    State<StatefulWidget> createState() {
      return VideoItemState();
    }

}


class VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        setState(() {});  //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return ListTile(
    leading: _controller.value.isInitialized
        ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
              width: 100.0,
              height: 56.0,
              child: VideoPlayer(_controller),
            ),
        )
        : const CircularProgressIndicator(),
    subtitle: Text(
      "${widget.video.path.split('/').last.substring(0,30)}...",
      style: const TextStyle(
        fontSize: 10,
        backgroundColor: Colors.black
      ),
    ),
    trailing: FloatingActionButton(
      mini: true,
      backgroundColor: Colors.redAccent,
      child: const Icon(Icons.delete),
      onPressed: (){
        BlocProvider.of<PostBloc>(context).add(PostDeleteAttachmentEvent(selectedAttachmentFile: widget.video));
      },
    ),
    onTap: () async {
      if(kDebugMode){
        print("Show video player");
        await showDialog(context: context, builder:(context)=>Dialog(
          child: VigoVideoPlayer(videoFile: widget.video,)
        ));
      }
    },
  );
 }
}