import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playmyhit/data/models/attachment.dart';

class MyPicturesScreen extends StatelessWidget{
  final List<Attachment> myPicturePostAttachments;

  const MyPicturesScreen({super.key, required this.myPicturePostAttachments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myPicturePostAttachments.isNotEmpty ? ListView.builder(
          shrinkWrap: true,
          itemCount : myPicturePostAttachments.length,
          itemBuilder: (context, index){
            return _generatePictureItem(myPicturePostAttachments[index], context);
          }
        ) : const Expanded(child: Center(child: Text("Post some pictures and they will show up here."))),
      ],
    );    
  }
  
  Widget _generatePictureItem(Attachment item, BuildContext context){
    if(kDebugMode){
      print("Generating music item in music view.");
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
        child: Image.network(
          item.attachmentUrl!,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          loadingBuilder: (context, child, loadingProgress) => const Center(child: CircularProgressIndicator()),
        )
        // child: MusicItem(
        //   inList: true,
        //   name: item.attachmentTitle ?? defaultAudioFileTitle, 
        //   fileUrl: item.attachmentUrl!, 
        //   thumbnailUrl: item.attachmentThumbnailUrl ?? defaultThumbnailUrl,
        //   audioFile: item.attachmentFile,
        // ),
      );
    }
  }
}

