// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network/models/post.dart';
import 'package:social_network/models/story.dart';
import 'package:social_network/nav_pages/feed/components/story_circle.dart';
import 'package:social_network/nav_pages/direct/direct_screen.dart';
import 'package:social_network/nav_pages/notifications/notifications_screen.dart';
import 'package:social_network/nav_pages/splash_screen.dart';
import './components/stories_viewer.dart';
import 'package:social_network/providers/user_provider.dart';
import 'package:social_network/cubit/posts_cubit.dart';
import 'package:provider/provider.dart';
import 'package:social_network/nav_pages/feed/components/post.dart';
import 'package:social_network/nav_pages/add_story/add_story_screen.dart';
import 'package:social_network/providers/story_provider.dart';

import 'components/animated_diagram.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late Stream<Map<String, List<Story>>>? storiesStream;
  late Stream<List<Post>>? postsStream;
  late final storiesModel;
  late final postsProvider;
  late final UserProvider user;
  // late SharedPreferences prefs;
  late bool loggedInBefore = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false);
    storiesModel = Provider.of<StoriesProvider>(context, listen: false);
    postsProvider = BlocProvider.of<PostsCubit>(context);

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        loggedInBefore = prefs.getBool('loggedInBefore') ?? false;
      });
    });

    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      _loading = true;
    });

    await user.fetchUser();

    postsStream = postsProvider.feedPostsStream(user.uid);
    storiesStream = storiesModel.fetchUserStories(user.uid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedInBefore', false);

    if (loggedInBefore) {
      await Future.delayed(Duration(seconds: 2));
    }

    setState(() {
      _loading = false;
    });
  }

  // @override
  // void dispose(){
  //   user.clear();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? loggedInBefore
            ? SplashScreen()
            : Center(
                child: CircularProgressIndicator(),
              )
        : Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddStory()
                            ),
                          ),
                          icon: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  const Color.fromARGB(255, 149, 56, 206),
                                  Colors.orange.shade600
                                ],
                                tileMode: TileMode.repeated,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.add_circle_outline,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        Text('Instagram',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => Liked(usernames: usernames)
                                  builder: (context) => AnimatedDiagram(
                                    values: const [20, 50, 80, 40, 90],
                                    maxValue: 100,
                                    height: 250,
                                    width: 300,
                                    duration: Duration(seconds: 2),
                                    baseColor: Colors.blue[300]!,
                                    highlightColor: Colors.blue[900]!,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.favorite_outline,
                                color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Direct(
                                        user: user,
                                      )),
                            );
                          },
                          icon: Icon(Icons.messenger_outline,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ],
                    )
                  ]),
            ),
            body: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx < 0) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                        Direct(user: user),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddStory(),
                  ));
                }
              },
              child: Column(
                children: [
                  StreamBuilder<Map<String, List<Story>>>(
                    stream: storiesStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        // return CircularProgressIndicator();
                        return SizedBox.shrink();
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
                                    builder: (context) =>
                                        StoriesViewer(storiesMap, index),
                                  ),
                                );
                              },
                              child: StoryCircle(
                                  profilePic: authorStories.last.profilePic,
                                  userId: authorId,
                                  username: authorStories.last.username),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  StreamBuilder<List<Post>>(
                    stream: postsStream,
                    // context.watch<PostsCubit>().feedPostsStream(user.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No new posts for you',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }
                      final feedPosts = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: feedPosts!.length,
                          itemBuilder: (context, index) {
                            return PostCard(post: feedPosts[index]);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ));
    //     }
    //   }
    // );
  }
}
