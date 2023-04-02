// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/models/story.dart';
import 'package:social_network/nav_pages/components/story_circle.dart';
// import 'package:social_network/nav_pages/direct.dart';
import 'package:social_network/nav_pages/liked.dart';
import 'package:social_network/nav_pages/stories_viewer.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/models/posts_model.dart';
import 'package:provider/provider.dart';
import 'package:social_network/nav_pages/components/post.dart';
import 'package:social_network/nav_pages/add_story.dart';
import 'package:social_network/models/story_model.dart';
import 'package:social_network/models/story.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/models/posts_storage.dart';

class Feeds extends StatelessWidget {
  Feeds({super.key}) ;
  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    user.fetchUser();
    final storiesModel = Provider.of<StoriesModel>(context, listen: false);
    final Stream<Map<String, List<Story>>> storiesStream = storiesModel.fetchUserStories(user.uid);
    // print(storiesStream);

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:     
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddStory())),
                  icon: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(255, 149, 56, 206),
                          Colors.orange.shade600
                        ],
                        tileMode: TileMode.repeated,
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                Text('Instagram', style: Theme.of(context).textTheme.headlineSmall),
            ],
            ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => Liked(usernames: usernames)),
                    // );
                  },
                  icon: Icon(Icons.favorite_outline, color: Theme.of(context).iconTheme.color),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => Direct(usernames: usernames)),
                  // );
                },
                icon: Icon(Icons.messenger_outline, color: Theme.of(context).iconTheme.color),
              ),
            ],
          )
        ]),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 0) {
            // Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //       Direct(
            //           usernames: usernames
            //       ),
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) {
            //       return FadeTransition(
            //         opacity: animation,
            //         child: child,
            //       );
            //     },
            //   ),
            // );
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddStory(),
              )
            );
          }
        },
        child: Column(
          children: [
            StreamBuilder<Map<String, List<Story>>>(
              stream: storiesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                Map<String, List<Story>> storiesMap = snapshot.data!;

                return Container(
                  height: 130,
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: storiesMap.keys.length,
                    itemBuilder: (context, index) {
                      String authorId = storiesMap.keys.toList()[index];
                      List<Story> authorStories = storiesMap[authorId]!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoriesViewer(
                                storiesMap, 
                                index
                              ),
                            ),
                          );
                        },
                        child: StoryCircle(
                          profilePic: authorStories.last.profilePic, 
                          userId: authorId, 
                          username: authorStories.last.username
                        ),
                      );
                    },
                  ),
                );
              },
            ),
           
            StreamBuilder<List<Post>>(
              stream:
                  context.watch<PostsCubit>().feedPostsStream(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final feedPosts = snapshot.data ?? [];
                if (feedPosts.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text('No new posts for you',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: feedPosts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: feedPosts[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      )
    );
  }
}
