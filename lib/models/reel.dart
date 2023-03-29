
import 'package:cloud_firestore/cloud_firestore.dart';

class ReelItem {
  final String uid;
  final String username;
  final List likes;
  final String reelId;
  final DateTime datePublished;
  final String reelUrl;
  final String profImage;
  const ReelItem({
    required this.uid,
    required this.username,
    required this.likes,
    required this.reelId,
    required this.datePublished,
    required this.reelUrl,
    required this.profImage,
  });

  static ReelItem fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReelItem(
    uid: snapshot["uid"],
    likes: snapshot["likes"],
    reelId: snapshot["reelId"],
    datePublished: snapshot["datePublished"].toDate(),
    username: snapshot["username"],
    reelUrl: snapshot['reelUrl'],
    profImage: snapshot['profImage']);
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "likes": likes,
    "username": username,
    "reelId": reelId,
    "datePublished": datePublished,
    'reelUrl': reelUrl,
    'profImage': profImage,
  };
}
