import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/feed/components/post.dart';

class PostsViewer extends StatelessWidget {
  final int initial;
  final List posts;
  late final PageController _pageController;

  PostsViewer(this.initial, this.posts, {super.key}){
    _pageController = PageController(initialPage: initial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Posts', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        padEnds: false,
        children: [
          for (var post in posts) PostCard(post: post),
        ],
      ),
    );
  }
}
