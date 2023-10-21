import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/presentation/common_widgets/video_item.dart';

class MyVideosScreen extends StatelessWidget{
  final List<Attachment> myVideoPostAttachments;

  const MyVideosScreen({super.key, required this.myVideoPostAttachments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myVideoPostAttachments.isNotEmpty ? ListView.builder(
          shrinkWrap: true,
          itemCount : myVideoPostAttachments.length,
          itemBuilder: (context, index){
            return _generateVideoItem(myVideoPostAttachments[index], context);
          }
        ) : const Expanded(child: Center(child: Text("Post some videos and they will show up here."))),
      ],
    );    
  }
  
  Widget _generateVideoItem(Attachment item, BuildContext context){
    if(kDebugMode){
      print("Generating video item in video view.");
      print(item);
    }
    
    if(item.attachmentUrl == null){
      return Container();
    }else{
      // String defaultThumbnailUrl = "https://firebasestorage.googleapis.com/v0/b/playmyhitdev.appspot.com/o/assets%2Fdefault_audio_thumbnail.png?alt=media&token=9aa7a91f-b43d-4052-ac79-015f0263dfc0";
      // String defaultAudioFileTitle = "Untitled Tack";

      return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: VideoItem(
          // inList: true,
          // name: item.attachmentTitle ?? defaultAudioFileTitle, 
          // fileUrl: item.attachmentUrl!, 
          // thumbnailUrl: item.attachmentThumbnailUrl ?? defaultThumbnailUrl,
          // audioFile: item.attachmentFile,
          attachment: item,
          inList: true,
        ),
      );
    }
  }
}

