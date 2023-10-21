import 'package:flutter/material.dart';
import 'package:playmyhit/data/enumerations/attachment_type.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/presentation/common_widgets/vigo_video_player.dart';

class PostVideos extends StatelessWidget{
  final Post post;
  
  const PostVideos({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        // children: [],
        children: post.postAttachments?.where(
          (element) => element.attachmentType == AttachmentType.video)
          .map((e)=>ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // child: VigoVideoPlayer(attachment: e)
            child: SizedBox(
              height: 400,
              width: 300,
              // child: Text(e.attachmentUrl ?? "No Url")
              child: VigoVideoPlayer(attachment: e)
            ),
          ))
          .toList() as List<Widget>,
      ),
    );      
  }
}