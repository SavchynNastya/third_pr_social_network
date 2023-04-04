

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/user.dart' as UserStructure;
import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  late String uid = '';
  late String username;
  late String email;
  late List followers;
  late List following;
  late String profilePic;

  late String lastLikedUsername = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void clear() {
    uid = '';
    username = '';
    email = '';
    followers = [];
    following = [];
    profilePic = '';
    lastLikedUsername = '';
    notifyListeners();
  }


  Future<void> fetchUser() async {
    DocumentSnapshot userSnap = await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();

    UserStructure.User? _user = UserStructure.User.fromSnap(userSnap);

    uid = _user.uid;
    username = _user.username;
    email = _user.email;
    followers = _user.followers;
    following = _user.following;
    profilePic = _user.photoUrl;
    
    notifyListeners();
  }

  Future<void> fetchUserById(String userId) async {
    DocumentSnapshot userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    UserStructure.User? _userById = UserStructure.User.fromSnap(userSnap);

    uid = _userById.uid;
    username = _userById.username;
    email = _userById.email;
    followers = _userById.followers;
    following = _userById.following;
    profilePic = _userById.photoUrl;

    notifyListeners();
  }


  Future<void> getUsernameById(String userId) async {
    DocumentSnapshot userSnap =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    UserStructure.User? _userById = UserStructure.User.fromSnap(userSnap);

    lastLikedUsername = _userById.username;
  }

  
  Future<void> followUser(String userId, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(userId).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([userId])
        });

        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([userId])
        });

        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }


  // user content data
  // List<Photo> _photos = [];
  // List<Story> _stories = [];

  // void setProfilePhotoUrl(String newUrl) {
  //   _profilePhotoUrl = newUrl;
  //   notifyListeners();
  // }
}
