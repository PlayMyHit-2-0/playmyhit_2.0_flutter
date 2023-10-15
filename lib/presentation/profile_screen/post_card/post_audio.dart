import 'package:flutter/material.dart';
import 'package:playmyhit/data/enumerations/attachment_type.dart';
import 'package:playmyhit/data/models/post.dart';
import 'package:playmyhit/presentation/common_widgets/music_item.dart';

class PostAudio extends StatelessWidget {
  final Post post;
  const PostAudio({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: post.postAttachments?.where(
          (element) => element.attachmentType == AttachmentType.audio)
          .map((e)=>ClipRRect(
            borderRadius: BorderRadius.circular(20),
            // child: Image.network(
            //   e.attachmentUrl ?? "",
            //   errorBuilder:(context, error, stackTrace) => const CircularProgressIndicator(),
            // )
            child: MusicItem(
              thumbnailUrl: e.attachmentThumbnailUrl,
              audioFile: e.attachmentFile,
              fileUrl: e.attachmentUrl,
              name: e.attachmentTitle,
              inList: true,
            )
          ))
          .toList() as List<Widget>,
      ),
    );      
  }
}