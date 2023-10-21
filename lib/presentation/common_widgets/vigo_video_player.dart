import 'package:flutter/material.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VigoVideoPlayer extends StatefulWidget {
  final Attachment attachment;

  const VigoVideoPlayer({super.key, required this.attachment});

  @override
  State<StatefulWidget> createState() {
    return VigoVideoPlayerState();
  }
}

class VigoVideoPlayerState extends State<VigoVideoPlayer> {
  late VideoPlayerController controller;
  bool isPlaying = false;

  void checkEndOfVideo() {
    bool endOfVideo = controller.value.isInitialized &&
        controller.value.position ==
            controller.value.duration;
    if(endOfVideo){ // When we get to the end of the video
      // Seek back to the beginning and play again
      controller.seekTo(Duration.zero);
      controller.play();
    }
  }

  String videoTitle() {
    if(widget.attachment.attachmentFile != null){
      return widget.attachment.attachmentFile!.path.split('/').last.substring(0,30);
    }else{
      // return widget.attachment.attachmentUrl!.split('/').last.substring(0,30);
      return "";
    }
  }

  @override
  void initState() {
    if(widget.attachment.attachmentFile != null){
      controller = VideoPlayerController.file(widget.attachment.attachmentFile!);
    }else{
      controller = VideoPlayerController.networkUrl(Uri.parse(widget.attachment.attachmentUrl!));
    }

    controller.initialize();
    controller.setLooping(true);
    controller.addListener(checkEndOfVideo);
    isPlaying = false;
    // controller.play();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(checkEndOfVideo);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.attachment.hashCode.toString()),
      onVisibilityChanged: (info){
        double visiblePercentage = info.visibleFraction * 100;
        if(visiblePercentage < 0.5){
          // When the video goes off screen by 50%
          if(mounted){
            setState((){
              // Pause the video
              isPlaying = false;
              controller.pause();
            });
          }
        }
      },
      child: SingleChildScrollView(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Text(videoTitle()),
                  SizedBox(
                    width: double.maxFinite,
                    height: 400,
                    child: AspectRatio(aspectRatio: 1.0,child: VideoPlayer(
                      controller,
                    )),
                  ),
                  // TextButton(onPressed: (){
                  //   Navigator.of(context).pop(); // Close the dialog
                  // }, child: const Text("Close"))
                ],
              ),
              Positioned(
                child: IconButton(
                  color: const Color.fromARGB(100, 255, 255, 255),
                  iconSize: 100,
                  icon: isPlaying ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
                  onPressed: (){
                    if(isPlaying){
                      if(mounted){
                        setState(() {
                          isPlaying = false;
                          controller.pause();
                        });
                      }
                    }else{
                      if(mounted){
                        setState(() {
                          isPlaying = true;
                          controller.play();
                        });
                      }
                    }
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
