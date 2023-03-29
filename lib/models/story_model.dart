import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:social_network/storage/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:social_network/models/story.dart';
import 'package:collection/collection.dart';

class StoriesModel extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  late Story currentStory;

  Stream<Map<String, List<Story>>> fetchUserStories(String userId) {
    return _firestore
        .collection('stories')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((doc) => Story.fromSnap(doc)).toList())
        .map((stories) {
      var groupedStories = groupBy(stories, (Story s) => s.uid);
      if (groupedStories.containsKey(userId)) {
        var currentUserStories = groupedStories.remove(userId);
        groupedStories = {userId: currentUserStories!, ...groupedStories};
      }
      return groupedStories;
    });
  }

  Future<String> uploadStory(Uint8List file, String uid, String username,
      String profImage) async {
    String res = "Error";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('stories', file, true);
      String storyId = const Uuid().v1();
      Story story = Story(
        storyId: storyId,
        storyPic: photoUrl,
        uid: uid,
        username: username,
        datePublished: DateTime.now(),
        profilePic: profImage,
      );
      _firestore.collection('stories').doc(storyId).set(story.toJson());

      // _posts.insert(0, post);
      notifyListeners();

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteStory(String storyId) async {
    String res = "Error";
    try {
      await _firestore.collection('stories').doc(storyId).delete();
      res = 'success';
      notifyListeners();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Stream<Story> getStoryStream(String storyId) {
    return FirebaseFirestore.instance
        .collection('stories')
        .doc(storyId)
        .snapshots()
        .map((snapshot) => Story.fromSnap(snapshot));
  }

}
