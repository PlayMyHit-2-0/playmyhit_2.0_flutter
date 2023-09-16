import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/models/post.dart';

class PostsRepository {
  FirebaseFirestore firestore;
  FirebaseStorage storage;
  PostsRepository({required this.firestore, required this.storage});
  StreamSubscription? currentPostsListener;
  List<Post>? posts;

  // When the posts repository is disposed
  void dispose(){
    // Cancel the current posts subscription
    currentPostsListener?.cancel();
  }

  //Write logic to get posts
  Future<bool> listenToPostsForUid(String uid) async {
    try{  
      
      // Get a reference to the posts collection for the given UID
      CollectionReference ref = firestore.collection("/users/$uid/posts");

      // Start listening to the posts collection 
      currentPostsListener = ref.snapshots().listen((event) { 
        posts = List.empty(); // Empty the list of current posts
        // Fill it with the new posts
        for (var element in event.docs) {
            posts?.add(Post.fromJson(element.data() as Map<String,dynamic>));
        }

        if(kDebugMode){
          print(posts);
        }
      });

      if(kDebugMode){
        print("Listening to posts collection for user with uid: $uid");
      }

      return Future.value(true);
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      rethrow;
    }
  }

  // TODO Write logic to create posts
  // TODO Write logic to update posts
  // TODO Write logic to delete posts
  // TODO Write logic to like posts
  // TODO Write logic to comment on a post
  // TODO Write logic to edit a comment on a post
  // TODO Write logic to delete a post comment
}