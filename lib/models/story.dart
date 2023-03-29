import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String storyId;
  final String storyPic;
  final String uid;
  final String username;
  final DateTime datePublished;
  final String profilePic;
  const Story({
    required this.storyId,
    required this.storyPic,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.profilePic,
  });

  static Story fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Story(
      storyId: snapshot['storyId'],
      storyPic: snapshot["storyPic"],
      uid: snapshot["uid"],
      username: snapshot["username"],
      datePublished: snapshot["datePublished"].toDate(),
      profilePic: snapshot['profilePic'],
    );
  }

  Map<String, dynamic> toJson() => {
    "storyId": storyId,
    "storyPic": storyPic,
    "uid": uid,
    "username": username,
    "datePublished": datePublished,
    'profilePic': profilePic,
  };
}
