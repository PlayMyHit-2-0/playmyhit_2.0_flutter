import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:playmyhit/data/models/comment.dart';
import 'package:playmyhit/data/models/post.dart';

class PostsRepository {
  FirebaseFirestore firestore;
  FirebaseStorage storage;
  FirebaseAuth auth;
  PostsRepository({required this.firestore, required this.storage, required this.auth});
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

  // Write logic to create posts
  Future<bool> createPost(Post post) async {
    try{
      if(auth.currentUser?.uid != null){
        CollectionReference ref = firestore.collection("users/${auth.currentUser?.uid}/posts");
        await ref.add(post.toJson());
        return true;
      }else{
        throw Exception("You need to login to make a new post.");
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      rethrow;
    }
  }

  // Write logic to update posts
  Future<bool> updatePost(Post post){
    try {
      if(auth.currentUser?.uid != null){
        CollectionReference ref = firestore.collection("users/${auth.currentUser?.uid}/posts");
        return firestore.runTransaction((transaction) async {
          await ref.doc(post.postId).update(post.toJson());
          return true;
        });
      }else{
        throw Exception("You must be logged in to update a post.");
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      rethrow;
    }
  }

  // Write logic to delete posts
  Future<bool> deleteExistingPost(Post post) async {
    try {
      if(auth.currentUser?.uid != null){
        await firestore.collection("users/${auth.currentUser?.uid}/posts").doc(post.postId).delete();
        return true;
      }else{
        throw Exception("You must be logged in to delete an existing post.");
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      rethrow;
    }
  }

  // Write logic to like posts
  Future<bool> likeUnlikePost(Post post,bool isLiked){
    try{
      if(auth.currentUser?.uid != null){
        DocumentReference ref = firestore.doc("users/${post.postOwnerId}/posts/${post.postId}/likes/${auth.currentUser?.uid}");
        return firestore.runTransaction((transaction) async {
          if(isLiked){
            ref.set(false);
          }else{  
            ref.set(true);
          }
          return true;
        });
      }else {
        throw Exception("You have to be logged in to like a post.");
      }
    }catch(e){
      if(kDebugMode){
        print("There was an error while liking the post.");
      }
      rethrow;
    }
  }

  // Write logic to comment on a post
  Future<bool> leaveComment(Post post, Comment comment){
    try {
      if(auth.currentUser?.uid != null){
        CollectionReference postsCollectionRef = firestore.collection("users/${post.postOwnerId}/posts/${post.postId}/comments/");
        return firestore.runTransaction((transaction) async {
          await postsCollectionRef.add(comment.toJson());
          return true;
        });
      }else{
        throw Exception("You must be logged in to leave a comment.");
      }
    } catch (e) {
      if(kDebugMode){
        print("There was an error while leaving a comment in the posts repository.");
      }
      rethrow;
    }
  }

  //Write logic to edit a comment on a post
  Future<bool> editComment(Post post, Comment comment) {
    try {
      if(auth.currentUser?.uid != null){
        DocumentReference commentDocReference = firestore.doc("users/${post.postOwnerId}/comments/${comment.commentId}");
        if(comment.commentOwnerId != auth.currentUser?.uid){
          throw Exception("You are not the owner of the comment you're trying to delete.");
        }else{
          return firestore.runTransaction((transaction) async {
            await commentDocReference.update(comment.toJson());
            return true;
          });
        }
      }else{
        throw Exception("You must be logged in to edit a comment on a post.");
      }
    } catch(e){
      if(kDebugMode){
        print("There was an error while attempting to edit a comment from the posts repository.");
      }
      rethrow;
    }
  }

  //Write logic to delete a post comment
  Future<bool> deleteComment(Post post, Comment comment) {
    try { 
      if(auth.currentUser?.uid != null){
        if(comment.commentOwnerId != auth.currentUser?.uid){
          throw Exception("You cannot delete comments you do not own.");
        }else{
          DocumentReference commentDocReference = firestore.doc("users/${post.postOwnerId}/comments/${comment.commentId}");
          return firestore.runTransaction((transaction) async {
            await commentDocReference.delete();
            return true;
          });
        }
      }else{
        throw Exception("You must be logged in to delete a comment on a post.");
      }
    } catch(e){
      if(kDebugMode){
        print("There was an error while attempting to delete a post comment from the posts repository.");
      }
      rethrow;
    }
  }

}