import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/story.dart';
import 'package:social_network/nav_pages/direct.dart';
import 'package:social_network/nav_pages/liked.dart';
import 'package:social_network/nav_pages/stories_viewer.dart';

class Feeds extends StatelessWidget {
  Feeds(this.usernames, this.currentUsername, this.posts, {super.key}){
    storiesAvailable = List.generate(
      usernames.length,
      (index) => Story(username: usernames[index])
    );
  }

  final List usernames;
  final String currentUsername;
  final List posts;
  static late List storiesAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Instagram', style: TextStyle(color: Colors.black)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Liked(usernames: usernames)),
                      );
                    },
                    icon: const Icon(Icons.favorite_outline),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Direct(
                              currentUsername: currentUsername,
                              usernames: usernames)),
                    );
                  },
                  icon: const Icon(Icons.messenger_outline),
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
                    Direct(
                        currentUsername: currentUsername,
                        usernames: usernames
                    ),
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
          child: Column(
            children: [
              Container(
                height: 130,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: usernames.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StoriesViewer(usernames, index,)),
                        );
                      },
                      child: storiesAvailable[index],
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return posts[index];
                  }
                ),
              ),
            ],
          ),
        ));
  }
}
