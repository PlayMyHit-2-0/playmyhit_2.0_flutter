import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    .snapshots()
    .map((snapshot){
      List posts = snapshot.docs.map((element) {
        return Post.fromJson(element.data());
      }).toList();
      return List<Post>.from(posts.reversed);
    });

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
  Stream<dynamic> fileUploadProgressStream(File file){
    try{
      UploadTask task = storage.ref("${auth.currentUser?.uid}/files").putFile(file);
      task.resume();
      StreamController controller = StreamController();
      StreamSubscription sub = task.snapshotEvents.listen((event) { 
        controller.add(event);
      });

      // Cancel the subscription when it's done and add completed true as
      // Map<String, dynamic>
      sub.onDone(() {
        sub.cancel();
        controller.add({
          "completed" : "true"
        });
      });

      return controller.stream;
    }catch(e){
      rethrow;
    }
  }

  List<Attachment> postAttachments = [];
  String currentPostText = "";
}