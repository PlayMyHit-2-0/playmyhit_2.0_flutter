import 'dart:convert';

import 'package:playmyhit/data/models/attachment.dart';

class Post {
  final String postId;
  final String postOwnerId;
  final String? postText;
  final String? postImageUrl;
  final List<Attachment> postAttachments;
  final DateTime? postCreatedAt;

  Post({
    required this.postId, 
    required this.postOwnerId,
    required this.postText,
    required this.postImageUrl,
    required this.postAttachments,
    required this.postCreatedAt
  });

  Map<String,dynamic> toJson() => {
    "post_id" : postId,
    "post_owner_id" : postOwnerId,
    "post_text" : postText,
    "post_image_url" : postImageUrl,
    "post_attachments" : postAttachments,
    "post_created_at" : postCreatedAt
  };

  Post.fromJson(Map<String, dynamic> json)
      : postId = json['post_id'],
        postOwnerId = json['post_owner_id'],
        postText = json['post_text'],
        postImageUrl = json['post_image_url'],
        postAttachments = List<Attachment>.from(jsonDecode(json['attachments'])),
        postCreatedAt = json['post_created_at'];

}