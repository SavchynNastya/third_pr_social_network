import 'package:flutter/material.dart';
import 'package:social_network/models/story_collection.dart';
import 'package:social_network/providers/story_provider.dart';
import 'package:social_network/models/story.dart';

class StoryCollectionCircle extends StatefulWidget {
  final StoryCollection collection;

  const StoryCollectionCircle({super.key, required this.collection});

  @override
  State<StoryCollectionCircle> createState() => _StoryCollectionCircleState();
}

class _StoryCollectionCircleState extends State<StoryCollectionCircle>{

  @override
  Widget build(BuildContext context) {
    final storyId = widget.collection.storiesList.first;
    return StreamBuilder<Story>(
      stream: StoriesProvider().getStoryStream(storyId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final story = snapshot.data!.storyPic;
        return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(story),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    widget.collection.storyCollectionName,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          );
      },
    );
  }
}
