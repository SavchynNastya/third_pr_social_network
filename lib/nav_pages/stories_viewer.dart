import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/story_open.dart';

class StoriesViewer extends StatelessWidget {
  final List usernames;
  late final PageController _pageController;
  final int initial;
  StoriesViewer(this.usernames, this.initial, {super.key}){
    _pageController = PageController(initialPage: initial);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stories = List.generate(usernames.length, (index) {
      return StoryOpen(username: usernames[index]);
    });

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivityIndex = 10;
        if(details.delta.dy > sensitivityIndex){
          Navigator.pop(context);
        }
      },
      child: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        padEnds: false,
        children: stories,
      ),
    );
  }
}