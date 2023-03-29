import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/models/comment.dart';
import 'dart:typed_data';
import 'package:social_network/storage/storage.dart';
import 'package:uuid/uuid.dart';

class PostsModel extends ChangeNotifier {

  List<Post> _posts = [];
  List<Comment> _comments = [];

  List<Post> _savedPosts = [];
  List<Post> _likedPosts = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Post> get posts => _posts;
  List<Comment> get comments => _comments;

  List<Post> get savedPosts => _savedPosts;
  List<Post> get likedPosts => _likedPosts;

  Future<void> fetchFeedPosts(String userId) async {
    final postsSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isNotEqualTo: userId)
        .orderBy('datePublished', descending: true)
        .get();
    final posts = postsSnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
    _posts = posts;
    notifyListeners();
  }

  Future<void> fetchPosts(String userId) async {
    final postsSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: userId)
        .orderBy('datePublished', descending: true)
        .get();
    final posts =
        postsSnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
    _posts = posts;
    notifyListeners();
  }

  Future<void> fetchSavedPosts(String userId) async{
    final savedPostSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('savings', arrayContains: userId)
        .get();
    final savedPosts = savedPostSnap.docs.map((doc) => Post.fromSnap(doc)).toList();
    _savedPosts = savedPosts;
  }

  Future<void> fetchLikedPosts(String userId) async {
    final likedPostSnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('likes', arrayContains: userId)
        .get();
    final likedPosts =
        likedPostSnap.docs.map((doc) => Post.fromSnap(doc)).toList();
    _likedPosts = likedPosts;
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('datePublished', descending: false)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((doc) => Comment.fromSnap(doc)).toList());
  }


  Future<String> uploadPost(Uint8List file, String uid, String username,
      String profImage, String desc) async {
    String res = "Error";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        username: username,
        likes: [],
        savings: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        desc: desc,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());

      _posts.insert(0, post);
      notifyListeners();

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
      notifyListeners();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> savePost(String postId, String uid, List savings) async {
    String res = "Some error occurred";
    try {
      if (savings.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'savings': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'savings': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
      notifyListeners();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Error";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
        notifyListeners();
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Error";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
      _posts.removeWhere((post) => post.postId == postId);
      notifyListeners();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<void> followUser(String uid, String followId) async {
  //   try {
  //     DocumentSnapshot snap =
  //         await _firestore.collection('users').doc(uid).get();
  //     List following = (snap.data()! as dynamic)['following'];

  //     if (following.contains(followId)) {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayRemove([uid])
  //       });

  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayRemove([followId])
  //       });
  //     } else {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayUnion([uid])
  //       });

  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayUnion([followId])
  //       });
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // user content data
  // List<Photo> _photos = [];
  // List<Story> _stories = [];


  // void setProfilePhotoUrl(String newUrl) {
  //   _profilePhotoUrl = newUrl;
  //   notifyListeners();
  // }

}