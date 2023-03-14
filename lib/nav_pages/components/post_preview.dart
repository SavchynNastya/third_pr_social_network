import 'package:flutter/material.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Text("$id"),
      ),
    );
  }
}