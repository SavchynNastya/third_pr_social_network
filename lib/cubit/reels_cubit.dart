import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/comment.dart';
import '../models/reel.dart';
import '../storage/storage.dart';
import 'reel_state.dart';

class ReelCubit extends Cubit<ReelState> {
  final CollectionReference<Map<String, dynamic>> reelsCollection =
      FirebaseFirestore.instance.collection('reels');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ReelCubit() : super(ReelInitial());

  Stream<ReelState> getReelsStreamByUserId(String userId) {
    return reelsCollection.where('uid', isEqualTo: userId).snapshots().map(
      (querySnapshot) {
        final reels = <ReelItem>[];
        querySnapshot.docs.forEach((doc) {
          reels.add(ReelItem.fromSnap(doc));
        });
        return ReelLoaded(reels);
      },
    );
  }

  Future<String> addReel(Uint8List file, String username, String profileImageUrl) async {
    // emit(ReelLoading());
    try {
      String reelUrl =
          await StorageMethods().uploadImageToStorage('reels', file, true);
      final reel = ReelItem(
        uid: FirebaseAuth.instance.currentUser!.uid,
        reelId: const Uuid().v1(),
        reelUrl: reelUrl,
        username: username,
        profImage: profileImageUrl,
        datePublished: DateTime.now(),
        likes: [],
        comments: [],
      );
      // print(reel);
      await _firestore
          .collection('reels')
          .doc(reel.reelId)
          .set(reel.toJson());

      if (state is ReelLoaded) {
        final reels = (state as ReelLoaded)
            .reels
            .toList(growable: false);
        emit(ReelLoaded(reels));
      }
      return 'success';
    } catch (error) {
      emit(ReelError(error.toString()));
      print(error.toString());
      return error.toString();
    }
  }

  Future<String> deleteReel(String reelId) async {
    try {
      await reelsCollection.doc(reelId).delete();
      if (state is ReelLoaded) {
        final reels = (state as ReelLoaded)
            .reels
            .where((reel) => reel.reelId != reelId)
            .toList(growable: false);
        emit(ReelLoaded(reels));
      }
      return 'success';
    } catch (e) {
      emit(ReelError(e.toString()));
      return e.toString();
    }
  }

  Future<void> likeReel(String reelId) async {
    try {
      final reelDoc = reelsCollection.doc(reelId);
      final reelSnap = await reelDoc.get();
      if (reelSnap.exists) {
        final reel = ReelItem.fromSnap(reelSnap);
        final likes = List<String>.from(reel.likes)
          ..add(FirebaseAuth.instance.currentUser!.uid);
        await reelDoc.update({'likes': likes});
        final updatedReel = reel.copyWith(likes: likes);
        if (state is ReelLoaded) {
          final reels = (state as ReelLoaded)
              .reels
              .map((r) => r.reelId == updatedReel.reelId ? updatedReel : r)
              .toList(growable: false);
          emit(ReelLoaded(reels as List<ReelItem>));
        }
      } else {
        emit(ReelError('Reel not found'));
      }
    } catch (e) {
      emit(ReelError(e.toString()));
    }
  }

  Future<void> commentReel(String reelId, String text, String uid,
      String username, String profilePic) async {
    try {
      final reelDoc = reelsCollection.doc(reelId);
      final reelSnap = await reelDoc.get();
      if (reelSnap.exists) {
        final reel = ReelItem.fromSnap(reelSnap);
        final comments = reel.comments + [text];
        final commentId = const Uuid().v1();
        await reelDoc.update({'comments': comments});
        final updatedReel = reel.copyWith(comments: comments);
        if (state is ReelLoaded) {
          final reels = (state as ReelLoaded)
              .reels
              .map((r) => r.reelId == updatedReel.reelId ? updatedReel : r)
              .toList(growable: false);
          emit(ReelLoaded(reels as List<ReelItem>));
        }
        await _firestore
            .collection('reels')
            .doc(reelId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': username,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        emit(ReelError('Reel not found'));
      }
    } catch (e) {
      emit(ReelError(e.toString()));
    }
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

}
