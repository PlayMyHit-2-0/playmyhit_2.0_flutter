import 'package:flutter/material.dart';
import 'package:playmyhit/data/enumerations/attachment_type.dart';
import 'package:playmyhit/data/models/post.dart';

class PostImages extends StatelessWidget {
  final Post post;
  const PostImages({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        // children: [],
        children: post.postAttachments?.where(
          (element) => element.attachmentType == AttachmentType.image)
          .map((e)=>ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              e.attachmentUrl ?? "",
              errorBuilder:(context, error, stackTrace) => const CircularProgressIndicator(),
            )
          ))
          .toList() as List<Widget>,
      ),
    );      
  }  
}