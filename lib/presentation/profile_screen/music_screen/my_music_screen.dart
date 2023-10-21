import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/presentation/common_widgets/music_item.dart';

class MyMusicScreen extends StatelessWidget{
  final List<Attachment> myMusicPostAttachments;

  const MyMusicScreen({super.key, required this.myMusicPostAttachments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myMusicPostAttachments.isNotEmpty ? ListView.builder(
          shrinkWrap: true,
          itemCount : myMusicPostAttachments.length,
          itemBuilder: (context, index){
            return _generateMusicItem(myMusicPostAttachments[index], context);
          }
        ) : const Expanded(child: Center(child: Text("Post some music and it will show up here."))),
      ],
    );    
  }
  
  Widget _generateMusicItem(Attachment item, BuildContext context){
    if(kDebugMode){
      print("Generating music item in music view.");
      print(item);
    }
    
    if(item.attachmentUrl == null){
      return Container();
    }else{
      String defaultThumbnailUrl = "https://firebasestorage.googleapis.com/v0/b/playmyhitdev.appspot.com/o/assets%2Fdefault_audio_thumbnail.png?alt=media&token=9aa7a91f-b43d-4052-ac79-015f0263dfc0";
      String defaultAudioFileTitle = "Untitled Tack";

      return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: MusicItem(
          inList: true,
          name: item.attachmentTitle ?? defaultAudioFileTitle, 
          fileUrl: item.attachmentUrl!, 
          thumbnailUrl: item.attachmentThumbnailUrl ?? defaultThumbnailUrl,
          audioFile: item.attachmentFile,
        ),
      );
    }
  }
}

