import 'dart:convert';

import 'package:playmyhit/data/models/attachment.dart';

class Comment {
  final String commentOwnerId;
  final String postId;
  final String commentId;
  final DateTime timestamp;
  final String commentContent;
  final List<Attachment> commentAttachments;

  Comment({
    required this.commentOwnerId,
    required this.postId,
    required this.commentId,
    required this.timestamp,
    required this.commentContent,
    required this.commentAttachments
  });

  Map<String,dynamic> toJson() => {
    "comment_owner_id" : commentOwnerId,
    "post_id" : postId,
    "comment_id" : commentId,
    "timestamp" : timestamp,
    "comment_content" : commentContent,
    "comment_attachments" : commentAttachments 
  };

  Comment.fromJson(Map<String, dynamic> json)
      : commentOwnerId = json['comment_owner_id'],
      postId = json['post_id'],
      commentId = json['comment_id'],
      timestamp = json['timestamp'],
      commentContent = json['comment_content'],
      commentAttachments = List<Attachment>.from(jsonDecode(json['comment_attachments']));
}