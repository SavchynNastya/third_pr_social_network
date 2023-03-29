import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/reel.dart';
import 'package:social_network/models/comment.dart';
import 'dart:typed_data';
import 'package:social_network/storage/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:social_network/errors_display/snackbar.dart';

class ReelsModel extends ChangeNotifier {

  // List<Reels> _reels = [];
  // List<Comment> _comments = [];

  // List<Post> _savedPosts = [];
  // List<Post> _likedPosts = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List<Post> get posts => _posts;
  // List<Comment> get comments => _comments;

  // List<Post> get savedPosts => _savedPosts;
  // List<Post> get likedPosts => _likedPosts;

  // Future<void> fetchFeedPosts(String userId) async {
  //   final postsSnapshot = await FirebaseFirestore.instance
  //       .collection('posts')
  //       .where('uid', isNotEqualTo: userId)
  //       .orderBy('datePublished', descending: true)
  //       .get();
  //   final posts = postsSnapshot.docs.map((doc) => Post.fromSnap(doc)).toList();
  //   _posts = posts;
  //   notifyListeners();
  // }

  Stream<List<ReelItem>> fetchReels() {
    return FirebaseFirestore.instance
      .collection('reels')
      .snapshots()
      .map((querySnapshot) =>
          querySnapshot.docs.map((doc) => ReelItem.fromSnap(doc)).toList());
  }

  Stream<List<Comment>> fetchReelComments(String reelId) {
    return FirebaseFirestore.instance
      .collection('reels')
      .doc(reelId)
      .collection('comments')
      .orderBy('datePublished', descending: false)
      .snapshots()
      .map((querySnapshot) =>
          querySnapshot.docs.map((doc) => Comment.fromSnap(doc)).toList());
  }


  Future<String> uploadReel(Uint8List file, String uid, String username,
      String profImage) async {
    String res = "Error";
    try {
      String videoUrl =
          await StorageMethods().uploadImageToStorage('reels', file, true);
      String reelId = const Uuid().v1();
      ReelItem reel = ReelItem(
        uid: uid,
        username: username,
        likes: [],
        reelId: reelId,
        datePublished: DateTime.now(),
        reelUrl: videoUrl,
        profImage: profImage,
      );
      _firestore.collection('reels').doc(reelId).set(reel.toJson());

      // _posts.insert(0, post);
      // notifyListeners();

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likeReel(String reelId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('reels').doc(reelId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('reels').doc(reelId).update({
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

  Future<String> postComment(String reelId, String text, String uid,
      String name, String profilePic) async {
    String res = "Error";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('reels')
            .doc(reelId)
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

  Future<String> deleteReel(String reelId) async {
    String res = "Error";
    try {
      await _firestore.collection('reels').doc(reelId).delete();
      res = 'success';
      // _posts.removeWhere((post) => post.postId == postId);
      // notifyListeners();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}