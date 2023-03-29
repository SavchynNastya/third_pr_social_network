import 'package:flutter/material.dart';
import 'package:social_network/models/story_collection.dart';
import 'package:social_network/nav_pages/components/story_open.dart';
import 'package:social_network/models/story.dart';
import 'package:social_network/models/story_model.dart';

class CollectionViewer extends StatelessWidget {
  final StoryCollection collection;

  const CollectionViewer({super.key, required this.collection});

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
          scrollDirection: Axis.horizontal,
          itemCount: collection.storiesList.length,
          itemBuilder: (BuildContext context, int storyIndex) {
            final storyId = collection.storiesList[storyIndex];
            return SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: StreamBuilder<Story>(
                stream: StoriesModel().getStoryStream(storyId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final story = snapshot.data!;
                  return StoryOpen(story: story);
                }
              ),
            );
          },
        ),
      ),
    );
  }
}