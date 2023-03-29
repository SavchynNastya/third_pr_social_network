

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/story.dart';
import 'package:social_network/models/story_collection.dart';
import 'dart:typed_data';
import 'package:social_network/storage/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:social_network/errors_display/snackbar.dart';

class StoryCollectionModel extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List<String> currentStoriesList = [];

  Stream<List<StoryCollection>> fetchCollections(String userId) {
    return FirebaseFirestore.instance
        .collection('story_collections')
        .where('uid', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => StoryCollection.fromSnap(doc))
          .toList();
    });
  }

  Future<String> addStoryToCollection(
      String collectionId, String storyId) async {
    String res = "Error";
    try {
      DocumentSnapshot collectionSnapshot = await _firestore
          .collection('story_collections')
          .doc(collectionId)
          .get();

      if (!collectionSnapshot.exists) {
        res = "Collection does not exist";
        return res;
      }

      var currentStoriesList = StoryCollection.fromSnap(collectionSnapshot);
      currentStoriesList.storiesList.add(storyId);
      // print(currentStoriesList.storiesList);

      await _firestore
          .collection('story_collections')
          .doc(collectionId)
          .update({'storiesList': currentStoriesList.storiesList});

      res = "success";
      notifyListeners();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> createStoryCollection(
      String uid, String storyCollectionName, String storyId) async {
    String res = "Error";
    try {
      String collectionId = const Uuid().v1();

      StoryCollection newCollection = StoryCollection(
        storyCollectionId: collectionId,
        storyCollectionName: storyCollectionName,
        uid: uid,
        storiesList: [storyId],
        datePublished: DateTime.now(),
      );

      await _firestore
          .collection('story_collections')
          .doc(collectionId)
          .set(newCollection.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> removeStoryFromCollection(
    String collectionId, String storyId) async {
    String res = "Error";
    try {
      DocumentSnapshot collectionSnapshot = await _firestore
          .collection('story_collections')
          .doc(collectionId)
          .get();

      if (!collectionSnapshot.exists) {
        res = "Collection does not exist";
        return res;
      }

      var currentStoriesList = StoryCollection.fromSnap(collectionSnapshot);
      currentStoriesList.storiesList.remove(storyId);

      await _firestore
            .collection('story_collections')
            .doc(collectionId)
            .update({'storiesList': currentStoriesList.storiesList});

        res = "success";
        notifyListeners();
    } catch (err) {
        res = err.toString();
    }
    return res;
  }

}