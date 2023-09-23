import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:playmyhit/data/models/comment.dart';
import 'package:playmyhit/data/models/post.dart';

class PostsRepository {
  FirebaseFirestore firestore;
  FirebaseStorage storage;
  FirebaseAuth auth;
  PostsRepository({required this.firestore, required this.storage, required this.auth}){
    profileUid = auth.currentUser?.uid;
  }
  
  void dispose(){
    postsStreamController?.close();
    postsStreamSubscription?.cancel();
  }


  // Stream for getting posts by the profile uid
  StreamController<Post>? postsStreamController = StreamController<Post>();
  String? profileUid;
  StreamSubscription? postsStreamSubscription;

  Stream<List<Post>> get postsStream => firestore.collection("users/$profileUid/posts")
  .snapshots()
  .map((snapshot){
    List posts = snapshot.docs.map((element) {
      return Post.fromJson(element.data());
    }).toList();
    return List<Post>.from(posts);
  });

  Future<DocumentReference> savePost(Post post) => firestore.collection("users/${auth.currentUser?.uid}/posts").add(post.toJson());
}