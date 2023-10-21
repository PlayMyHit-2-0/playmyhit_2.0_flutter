import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playmyhit/logic/post_bloc/post_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MusicItem extends StatefulWidget {
  final String? thumbnailUrl;
  final String? name;
  final String? fileUrl;
  final File? audioFile;
  final bool inList;
  const MusicItem({required this.thumbnailUrl,required this.name,super.key, required this.fileUrl, required this.audioFile, required this.inList});

  @override
  State<MusicItem> createState() => _MusicItemState();
}

class _MusicItemState extends State<MusicItem> {
  final player = AudioPlayer();
  late Duration? audioDuration;
  bool isPlaying = false;
  bool isError = false;

  void initializePlayer() async {
    try{
      if(widget.fileUrl != null){
        if(kDebugMode){
          print("Initializing audio file from a url");
        }

        player.setUrl(widget.fileUrl!).then(
          (value){
            setState(() {
              audioDuration = value;   
            });
          }
        );

        player.setLoopMode(LoopMode.all);
      }else if(widget.audioFile != null){
        if(kDebugMode){
          print("Initializing audio file from system memory.");
        }

        player.setFilePath(widget.audioFile!.path).then((value){
          setState(() {
            audioDuration = value;
          });
        });

        player.setLoopMode(LoopMode.all);
      }else{
        isError = true;
      }
    }catch(error){
      if(kDebugMode){
        print("Caught error while initializing audio player on post ui.");
        print(error);
        return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  String defaultThumbnailUrl = "https://firebasestorage.googleapis.com/v0/b/playmyhitdev.appspot.com/o/assets%2Fdefault_audio_thumbnail.png?alt=media&token=9aa7a91f-b43d-4052-ac79-015f0263dfc0";

  Widget inListUi() => VisibilityDetector(
            key: Key(widget.hashCode.toString()),
            onVisibilityChanged: (info){
              double visiblePercentage = info.visibleFraction * 100;
              if(kDebugMode){
                print(visiblePercentage);
              }
              if(visiblePercentage < .5){
                if(player.audioSource != null){
                  player.stop();
                  setState(() {
                    isPlaying = false;
                  });
                }
              }
            },
            child: inPostUi());
  
  Widget inPostUi() => isError ? const ListTile(
      title: Text( "Error loading audio file"),
      leading: Icon(Icons.error),
    ) : Row(
        children:[
          CachedNetworkImage(imageUrl: widget.thumbnailUrl ?? defaultThumbnailUrl),
          const SizedBox(width: 8),
          Text(widget.name ?? "Untitled Track"),
          TextButton.icon(
              label: const Text(""),
              icon : isPlaying ? const Icon(Icons.stop, color: Colors.redAccent) : const Icon(Icons.play_arrow, color: Colors.redAccent),
              onPressed: () async {
                if(kDebugMode){
                  print("Pressing transport button.");
                }

                if(player.audioSource == null){
                  initializePlayer();
                }
                if(kDebugMode){
                  print("Pressed action button");
                }
                if(isPlaying){
                  player.stop();
                  setState(() {
                    isPlaying = false;
                  });
                }else if(!isPlaying){
                  player.play();
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
            ),
            widget.inList ? Container() : TextButton.icon(
              label: const Text(""),
              icon :const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: (){
                BlocProvider.of<PostBloc>(context).add(PostDeleteAttachmentEvent(selectedAttachmentFile: widget.audioFile));
              },
            ),
        ]
    );

  @override
  Widget build(BuildContext context) {
    return widget.inList ? inListUi() : inPostUi();
  }
}