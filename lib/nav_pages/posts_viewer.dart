import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post.dart';

class PostsViewer extends StatelessWidget {
  final String username;
  final int id;
  final int postsQuantity;
  late final PageController _pageController;

  PostsViewer(this.username, this.id, this.postsQuantity, {super.key}){
    _pageController = PageController(initialPage: id);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> userPosts = List.generate(postsQuantity, (index) {
      if(id < 17) {
        return Post(username: username, id: index);
      } else {
        return Post(username: username, id: index+id-1);
      }
    });

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
        children: userPosts,
      ),
    );
  }
}
