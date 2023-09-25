import 'package:flutter/material.dart';
import 'package:playmyhit/data/models/post.dart';

class PostImage extends StatelessWidget {
  final Post post;
  const PostImage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Image.network(post.postImageUrl!);
  }  
}