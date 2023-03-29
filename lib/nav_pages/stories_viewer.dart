import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/story_open.dart';

class StoriesViewer extends StatefulWidget {
  var storiesMap;
  late final allStories;
  late int initial;
  StoriesViewer(this.storiesMap, this.initial, {super.key}) {
    allStories = [];
    storiesMap.forEach((key, value) {
      allStories.add(value);
    });

    // String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // allStories.sort((a, b) {
    //   if (a.first.uid == currentUserId) {
    //     return -1;
    //   } else if (b.first.uid == currentUserId) {
    //     return 1;
    //   } else {
    //     return 0;
    //   }
    // });
  }

  @override
  State<StoriesViewer> createState() => _StoriesViewerState();
}

class _StoriesViewerState extends State<StoriesViewer> {
  late int _currentPageIndex;
  int _currentStoryIndex = 0;

  late PageController _pageController;


  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initial;
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivityIndex = 10;
        if (details.delta.dy > sensitivityIndex) {
          Navigator.pop(context);
        }
      },
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.storiesMap.length,
          onPageChanged: (pageIndex) {
            setState(() {
              _currentPageIndex = pageIndex;
              _currentStoryIndex = 0;
            });
          },
          itemBuilder: (BuildContext context, int userIndex) {
            final currentUserStories = widget.allStories[userIndex];
            // print("CURRENT USER STORIES $currentUserStories");
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (_currentStoryIndex < currentUserStories.length - 1) {
                  setState(() {
                    _currentStoryIndex++;
                    // print("CURRENT USER st index $_currentStoryIndex");
                  });
                } else if (userIndex < widget.storiesMap.length - 1) {
                  setState(() {
                    _currentPageIndex++;
                    // print("CURRENT STORIES PAGE $_currentPageIndex");
                    _pageController.jumpToPage(
                      _currentPageIndex,
                    );
                    _currentStoryIndex = 0;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: currentUserStories.length,
                itemBuilder: (BuildContext context, int storyIndex) {
                  final currentStory = currentUserStories[_currentStoryIndex];
                  return SizedBox(
                    height: screenSize.height,
                    width: screenSize.width,
                    child: StoryOpen(story: currentStory),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

