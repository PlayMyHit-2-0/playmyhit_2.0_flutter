import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/models/attachment.dart';

class Post {
  String? postId;
  String? postOwnerId;
  String? postText;
  String? postImageUrl;
  List<Attachment>? postAttachments;
  Timestamp? postCreatedAt;

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
    "post_attachments" : List<Map<String,dynamic>>.from(postAttachments?.map((element)=>element.toJson()) ?? []),
    "post_created_at" : postCreatedAt
  };

  Post.fromJson(Map<String, dynamic> json){
      try{
        postId = json['post_id'];
        postAttachments = List.from(json['post_attachments']).map((item)=>Attachment.fromJson(item)).toList();
        postOwnerId = json['post_owner_id'];
        postText = json['post_text'];
        postImageUrl = json['post_image_url'];
        postCreatedAt = json['post_created_at'];
      }catch(err){
        if(kDebugMode){
          //print("Error:");
          print(err);
        }
      }     
  }
}
