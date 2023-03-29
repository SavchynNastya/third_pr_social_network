import 'package:flutter/material.dart';
import 'package:social_network/models/comment.dart' as comment_model;

class Comment extends StatelessWidget {
  // final int id;
  // final int postId;
  // final String username;
  // final String commentText;
  final comment_model.Comment comment;
  const Comment({super.key, required this.comment});

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
                text: comment.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const WidgetSpan(
                child: SizedBox(
                  width: 5,
                ),
              ),
              TextSpan(
                text: comment.commentText,
              ),
            ]
          ),
      ),
    );
  }
}