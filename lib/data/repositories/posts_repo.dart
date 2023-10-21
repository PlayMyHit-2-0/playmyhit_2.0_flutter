import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/enumerations/attachment_type.dart';
import 'package:playmyhit/data/enumerations/post_mode.dart';
import 'package:playmyhit/data/models/attachment.dart';
import 'package:playmyhit/data/models/post.dart';

class PostsRepository {
  FirebaseFirestore firestore;
  FirebaseStorage storage;
  FirebaseAuth auth;
  PostsRepository({required this.firestore, required this.storage, required this.auth}){
    profileUid = auth.currentUser?.uid;
  }
  
  void dispose(){
  }

  String? profileUid;
  Stream<List<Post>> get postsStream => firestore.collection("users/$profileUid/posts")
    .orderBy('post_created_at')
    .limit(10)
    .snapshots()
    .asyncMap((snapshot){
      List posts = snapshot.docs.map((element) {
        Post p = Post.fromJson(element.data());
        return p;
      }).toList();
      return List<Post>.from(posts.reversed);
    });

  Stream<List<Attachment>> get postsPictureAttachments => firestore.collection("users/$profileUid/posts")
    .orderBy('post_created_at')
    .snapshots()
    .map((snapshot){
      if(kDebugMode){
        print("Retrieving posts with picture attachments.");
      }

      List<Post> postsWithPictureAttachments = snapshot.docs.where((element){
        Post p = Post.fromJson(element.data());
        bool hasPictureAttachment = false;

        if(p.postAttachments != null){
          for(Attachment a in p.postAttachments!){
            if(a.attachmentType == AttachmentType.image){
              hasPictureAttachment = true;
              break;
            }
          }
        }else{
          return false;
        }
        
        return hasPictureAttachment;
      }).map((element)=>Post.fromJson(element.data())).toList();

      if(kDebugMode){
        print("Found ${postsWithPictureAttachments.length} posts with picture attachments.");
        print("Retrieving picture attachments from those posts.");
      }

      List<List<Attachment>> att = postsWithPictureAttachments.map((e){ 
        List<Attachment>? pictureAttachments = [];
        for(Attachment a in e.postAttachments!){
          if(a.attachmentType == AttachmentType.image){
            pictureAttachments.add(a);
          }
        }

        return pictureAttachments;
      }).toList();

      if(att.isNotEmpty){
        List<Attachment> attReduced = att.reduce((value, element){
          value.insertAll(0,element);
          if(value.isNotEmpty){
            return value;
          }else{
            return [];
          }
        }).toList();

        if(kDebugMode){
          print("Retrieved ${att.length} picture attachments from the posts.");
        }

        return attReduced;
      }else{
        return [];
      }

    });

  Stream<List<Attachment>> get postsVideoAttachments => firestore.collection("users/$profileUid/posts")
    .orderBy('post_created_at')
    .snapshots()
    .map((snapshot){
      if(kDebugMode){
        print("Retrieving posts with video attachments.");
      }

      List<Post> postsWithVideoAttachments = snapshot.docs.where((element){
        Post p = Post.fromJson(element.data());
        bool hasVideoAttachment = false;

        if(p.postAttachments != null){
          for(Attachment a in p.postAttachments!){
            if(a.attachmentType == AttachmentType.video){
              hasVideoAttachment = true;
              break;
            }
          }
        }else{
          return false;
        }
        
        return hasVideoAttachment;
      }).map((element)=>Post.fromJson(element.data())).toList();

      if(kDebugMode){
        print("Found ${postsWithVideoAttachments.length} posts with video attachments.");
        print("Retrieving video attachments from those posts.");
      }

      List<List<Attachment>> att = postsWithVideoAttachments.map((e){ 
        List<Attachment>? videoAttachments = [];
        for(Attachment a in e.postAttachments!){
          if(a.attachmentType == AttachmentType.video){
            videoAttachments.add(a);
          }
        }

        return videoAttachments;
      }).toList();

      if(att.isNotEmpty){
        List<Attachment> attReduced = att.reduce((value, element){
          value.insertAll(0,element);
          if(value.isNotEmpty){
            return value;
          }else{
            return [];
          }
        }).toList();

        if(kDebugMode){
          print("Retrieved ${att.length} video attachments from the posts.");
        }

        return attReduced;
      }else{
        return [];
      }

    });

  Stream<List<Attachment>> get postsMusicAttachments => firestore.collection("users/$profileUid/posts")
    .orderBy('post_created_at')
    .snapshots()
    .map((snapshot){

      if(kDebugMode){
        print("Retrieving posts with music attachments.");
      }
      
      List<Post> postsWithMusicAttachments = snapshot.docs.where((element){
        Post p = Post.fromJson(element.data());
        bool hasAudioAttachment = false;

        if(p.postAttachments != null){
          for(Attachment a in p.postAttachments!){
            if(a.attachmentType == AttachmentType.audio){
              hasAudioAttachment = true;
              break;
            }
          }
        }else{
          return false;
        }
        return hasAudioAttachment;
      }).map((element)=>Post.fromJson(element.data())).toList();

      if(kDebugMode){
        print("Found ${postsWithMusicAttachments.length} posts with music attachments.");
        print("Retrieving music attachments from those posts.");
      }

      List<List<Attachment>> att = postsWithMusicAttachments.map((e){ 
        List<Attachment>? musicAttachments = [];
        for(Attachment a in e.postAttachments!){
          if(a.attachmentType == AttachmentType.audio){
            musicAttachments.add(a);
          }
        }

        return musicAttachments;
      }).toList();
      

      if(att.isNotEmpty){
        List<Attachment> attReduced = att.reduce((value, element){
          value.insertAll(0,element);
          if(value.isNotEmpty){
            return value;
          }else{
            return [];
          }
        }).toList();

        if(kDebugMode){
          print("Retrieved ${att.length} music attachments from the posts.");
        }

        return attReduced;
      }else{
        return [];
      }
    }
  );
  

  Future<DocumentReference> savePost(Post post) => firestore.collection("users/${auth.currentUser?.uid}/posts").add(post.toJson());

  Future<String> getPostOwnerUsername(String postOwnerId) async => 
    (await firestore.doc("users/$postOwnerId").get())
    .data()?["username"];

  Future<Map<String,dynamic>> getPostOwnerSettings(String postOwnerId) async =>
    (await firestore.doc("users/$postOwnerId").get())
    .data() as Map<String,dynamic>;
  
  /*
    Stream of TaskSnapshots for uploading a file
  */
  Stream<Map<String,dynamic>> fileUploadProgressStream(File file){
    try{
      UploadTask task = storage.ref("${auth.currentUser?.uid}/files/${file.path.split('/').last}").putFile(file);
      task.resume();
      StreamController<Map<String,dynamic>> controller = StreamController();
      StreamSubscription sub = task.snapshotEvents.listen((event) { 
        controller.add({
          "upload_percentage" : event.bytesTransferred / event.totalBytes,
          "completed" : "false",
          "filename" : file.path.split('/').last
         });
      });

      // Cancel the subscription when it's done and add completed true as
      sub.onDone(() {
        sub.cancel();
        controller.add({
          "upload_percentage" : 1,
          "completed" : "true",
          "filename" : file.path.split('/').last
        });
      });
      
      return controller.stream;
    }catch(e){
      rethrow;
    }
  }

  PostMode postMode = PostMode.add;
  List<Attachment> postAttachments = [];
  String currentPostText = "";



}