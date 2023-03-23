import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post.dart';

class PostsViewer extends StatelessWidget {
  final int initial;
  final List<PostCard> posts;
  late final PageController _pageController;

  PostsViewer(this.initial, this.posts, {super.key}){
    _pageController = PageController(initialPage: initial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Posts',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        padEnds: false,
        children: posts,
      ),
    );
  }
}
