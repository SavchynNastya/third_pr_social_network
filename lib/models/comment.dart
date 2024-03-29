import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String commentText;
  final String uid;
  final String username;
  final DateTime datePublished;
  final String profilePic;
  const Comment({
    required this.commentId,
    required this.commentText,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.profilePic,
  });

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      commentId: snapshot['commentId'],
      commentText: snapshot["text"],
      uid: snapshot["uid"],
      username: snapshot["name"],
      datePublished: snapshot["datePublished"].toDate(),
      profilePic: snapshot['profilePic'],
    );
  }

  Map<String, dynamic> toJson() => {
    "commentText": commentText,
    "uid": uid,
    "username": username,
    "datePublished": datePublished,
    'profilePic': profilePic,
  };
}
