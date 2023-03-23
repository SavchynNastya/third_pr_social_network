import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final int id;
  final int postId;
  final String username;
  final String commentText;
  const Comment({super.key, required this.id, required this.postId, required this.username, required this.commentText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 0),
      child: RichText(
        text: 
          TextSpan(
            style: const TextStyle(color: Colors.black), 
            children: [
              TextSpan(
                text: username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const WidgetSpan(
                child: SizedBox(
                  width: 5,
                ),
              ),
              TextSpan(
                text: commentText,
              ),
            ]
          ),
      ),
    );
  }
}