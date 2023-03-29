

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/story_collection.dart';
import 'package:uuid/uuid.dart';

class StoryCollectionModel extends ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Stream<List<StoryCollection>> fetchCollectionsWhereStoryPresent(String userId, String storyId) {
    return FirebaseFirestore.instance
        .collection('story_collections')
        .where('uid', isEqualTo: userId)
        .where('storiesList', arrayContains: storyId)
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

      final collection = StoryCollection.fromSnap(collectionSnapshot);
      if(collection.storiesList.contains(storyId)){
        res = "Story is already in list";
        return res;
      }

      var currentStoriesList = StoryCollection.fromSnap(collectionSnapshot);
      currentStoriesList.storiesList.add(storyId);

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

  Future<String> renameCollection(String collectionId, String newName) async {
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

      final collection = StoryCollection.fromSnap(collectionSnapshot);
      collection.storyCollectionName = newName;

      await _firestore
          .collection('story_collections')
          .doc(collectionId)
          .update({'collectionName': collection.storyCollectionName});

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


  Future<String> removeFromCollection(
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