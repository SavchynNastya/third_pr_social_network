import 'package:cloud_firestore/cloud_firestore.dart';

class StoryCollection {
  final String storyCollectionId;
  String storyCollectionName;
  final String uid;
  List storiesList;
  final DateTime datePublished;
  StoryCollection({
    required this.storyCollectionId,
    required this.storyCollectionName,
    required this.uid,
    required this.storiesList,
    required this.datePublished
  });

  static StoryCollection fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return StoryCollection(
      storyCollectionId: snapshot['storyCollectionId'],
      storyCollectionName : snapshot['collectionName'],
      uid: snapshot["uid"],
      storiesList: snapshot['storiesList'],
      datePublished: snapshot['datePublished'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    "storyCollectionId": storyCollectionId,
    "collectionName" : storyCollectionName,
    "uid": uid,
    "storiesList": storiesList,
    "datePublished": datePublished,
  };
}
