import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:playmyhit/presentation/common_widgets/vigo_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
    final Attachment attachment;

    const VideoItem({required this.attachment, super.key});

    @override
    State<StatefulWidget> createState() {
      return VideoItemState();
    }

}


class VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {

    if(widget.attachment.attachmentFile != null){
      _controller = VideoPlayerController.file(widget.attachment.attachmentFile!)
        ..initialize().then((_) {
          setState(() {});  //when your thumbnail will show.
        });
    }else{
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.attachment.attachmentUrl!))
        ..initialize().then((_) {
          setState(() {});
        });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String videoTitle() {
    if(widget.attachment.attachmentFile != null){
      return widget.attachment.attachmentFile!.path.split('/').last.substring(0,30);
    }else{
      return widget.attachment.attachmentUrl!.split('/').last.substring(0,30);
    }
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
      videoTitle(),
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
        BlocProvider.of<PostBloc>(context).add(PostDeleteAttachmentEvent(selectedAttachmentFile: widget.attachment.attachmentFile));
      },
    ),
    onTap: () async {
      if(kDebugMode){
        print("Show video player");
        await showDialog(context: context, builder:(context)=>Dialog(
          child: VigoVideoPlayer(attachment: widget.attachment,)
        ));
      }
    },
  );
 }
}