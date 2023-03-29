import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {

  final String username;
  final String userId;
  final String profilePic;

  const StoryCircle({super.key, required this.username, required this.userId,
    required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.centerLeft, 
              end: Alignment.centerRight,
              colors: [Colors.purple.shade800, Colors.orange.shade600],
            ), 
          ),
          child: Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(profilePic)
              )
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(FirebaseAuth.instance.currentUser!.uid == userId ? "My story" : username),
      ],),
    );
  }
}