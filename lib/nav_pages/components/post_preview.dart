import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post.dart';
import 'package:social_network/models/post.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({super.key, required this.post});

  // final int id;

  final dynamic post;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[300],
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(post.postUrl),
          fit: BoxFit.cover,
        )
      ),
      // child: Center(
      //   child: Text("$id"),
      // ),
    );
  }
}