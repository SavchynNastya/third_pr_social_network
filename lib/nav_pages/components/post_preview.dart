import 'package:flutter/material.dart';
class PostPreview extends StatelessWidget {
  const PostPreview({super.key, required this.post});


  final dynamic post;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(post.postUrl),
          fit: BoxFit.cover,
        )
      ),
    );
  }
}