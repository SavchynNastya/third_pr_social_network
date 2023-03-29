import 'package:flutter/material.dart';
import 'package:social_network/models/story_collection.dart';
import 'package:social_network/models/story_model.dart';
import 'package:social_network/models/story.dart';

class StoryCollectionCircle extends StatelessWidget {
  final StoryCollection collection;

  const StoryCollectionCircle({super.key, required this.collection});

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     width: 60,
  //     height: 60,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       image: DecorationImage(
  //         image: NetworkImage(
  //           // collection.storiesList.first
  //           StoriesModel().getStoryById(collection.storiesList.first)
  //         )
  //       )
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final storyId = collection.storiesList.first;
    // return Container(
    //   width: 60,
    //   height: 60,
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //     image: DecorationImage(
    //       image: NetworkImage(imageUrl),
    //       fit: BoxFit.cover,
    //     ),
    //   ),
    // );
    return StreamBuilder<Story>(
        stream: StoriesModel().getStoryStream(storyId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final story = snapshot.data!.storyPic;
          return Padding(
            padding: EdgeInsets.only(right: 8),
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
                  '${collection.storyCollectionName}',
                  style: TextStyle(fontSize: 12),
                ))
              ],
            ),
          );
        });
  }
}
