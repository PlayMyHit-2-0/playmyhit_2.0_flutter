import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VigoVideoPlayer extends StatefulWidget {
  final File videoFile;

  const VigoVideoPlayer({super.key, required this.videoFile});

  @override
  State<StatefulWidget> createState() {
    return VigoVideoPlayerState();
  }
}

class VigoVideoPlayerState extends State<VigoVideoPlayer> {
  late VideoPlayerController controller;
  bool isPlaying = true;

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

  @override
  void initState() {
    controller = VideoPlayerController.file(widget.videoFile);
    controller.initialize();
    controller.addListener(checkEndOfVideo);
    isPlaying = true;
    controller.play();
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
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Text("${widget.videoFile.path.split('/').last.substring(0,30)}..."),
                SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: AspectRatio(aspectRatio: 1.0,child: VideoPlayer(
                    controller,
                  )),
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pop(); // Close the dialog
                }, child: const Text("Close"))
              ],
            ),
            Positioned(
              child: IconButton(
                color: const Color.fromARGB(100, 255, 255, 255),
                iconSize: 100,
                icon: isPlaying ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
                onPressed: (){
                  if(isPlaying){
                    setState(() {
                      isPlaying = false;
                      controller.pause();
                    });
                  }else{
                    setState(() {
                      isPlaying = true;
                      controller.play();
                    });
                  }
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
