import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final List likes;
  final List savings;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final String desc;
  const Post({
    required this.uid,
    required this.username,
    required this.likes,
    required this.savings,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.desc,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      savings: snapshot["savings"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"].toDate(),
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      desc: snapshot['desc']
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "likes": likes,
    "savings": savings,
    "username": username,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'profImage': profImage,
    'desc': desc,
  };
}
