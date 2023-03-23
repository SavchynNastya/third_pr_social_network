import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({super.key, required this.id, required this.post});

  final int id;
  final PostCard post;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[300],
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(post.imageUrl),
        )
      ),
      // child: Center(
      //   child: Text("$id"),
      // ),
    );
  }
}