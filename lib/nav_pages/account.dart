// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post_preview.dart';
import 'package:social_network/nav_pages/liked_posts.dart';
import 'package:social_network/nav_pages/saved_posts.dart';
import 'package:social_network/nav_pages/posts_viewer.dart';
import 'package:social_network/nav_pages/direct.dart';
import 'package:social_network/nav_pages/components/post.dart';
import 'package:social_network/authentication/auth.dart';
import 'package:social_network/nav_pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Account extends StatefulWidget {
  final List usernames;
  final List<PostCard> posts;
  final List<PostCard> mentionedPosts;
  final List<PostCard> likedPosts;
  final List<PostCard> savedPosts;

  Account(
      {super.key,
      required this.posts,
      required this.usernames,
      required this.mentionedPosts,
      required this.likedPosts,
      required this.savedPosts});

  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account> {
  late String username;
  late String photoUrl;
  late List followers;
  late List following;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      _loading = true;
    });

    DocumentSnapshot userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // DocumentSnapshot postSnap =
    //     await FirebaseFirestore.instance.collection('posts').doc(uid).get();

    setState(() {
      photoUrl = (userSnap.data() as Map<String, dynamic>)['photoUrl'];
      username = (userSnap.data() as Map<String, dynamic>)['username'];
      followers = (userSnap.data() as Map<String, dynamic>)['followers'];
      following = (userSnap.data() as Map<String, dynamic>)['following'];

      _loading = false;
    });
  }

  bool _isTapped = false;

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black26,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      )
    );

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue.shade500,
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(username, style: const TextStyle(color: Colors.black)),
                  const Icon(Icons.add_box_outlined, color: Colors.black),
                ],
              ),
            ),
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Text(
                      'Profile Menu',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.messenger_outline_sharp,
                      color: Colors.grey,
                    ),
                    title: const Text('Direct'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Direct(
                                currentUsername: username,
                                usernames: widget.usernames)),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.grey,
                    ),
                    title: const Text('Liked posts'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LikedPosts(
                                  likedPosts: widget.likedPosts,
                                )),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.bookmark_outlined,
                      color: Colors.grey,
                    ),
                    title: const Text('Saved posts'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SavedPosts(
                                  savedPosts: widget.savedPosts,
                                )),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.grey,
                    ),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                    title: const Text('Sign Out'),
                    onTap: () async {
                      await AuthMethods().signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${widget.posts.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const Text(
                          'Posts',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${followers.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const Text(
                          'Followers',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${following.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const Text(
                          'Following',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: null,
                        style: elevatedButtonStyle,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text('Edit profile',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: null,
                        style: elevatedButtonStyle,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text('Share profile',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: null,
                        style: elevatedButtonStyle,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Icon(
                            Icons.group_add_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border:
                                    Border.all(color: Colors.black54, width: 1),
                              ),
                              child: const SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(Icons.add),
                              ),
                            ),
                            const Text(
                              'Create',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Row(
                children: [
                  Flexible(
                      child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(color: Colors.black45, width: 1)),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isTapped = !_isTapped;
                          });
                        },
                        icon: const Icon(
                          Icons.grid_on,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )),
                  Flexible(
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isTapped = !_isTapped;
                          });
                        },
                        icon: Icon(
                          _isTapped
                              ? Icons.person_pin_rounded
                              : Icons.person_pin_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    children: _isTapped
                        ? List.generate(widget.mentionedPosts.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostsViewer(
                                          index, widget.mentionedPosts)),
                                );
                              },
                              child: Hero(
                                tag: 'post${widget.mentionedPosts[index].id}',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: PostPreview(
                                      id: widget.mentionedPosts[index].id,
                                      post: widget.mentionedPosts[index]),
                                ),
                              ),
                            );
                          })
                        : List.generate(widget.posts.length, (index) {
                            // index += 17;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PostsViewer(index, widget.posts)),
                                );
                              },
                              child: Hero(
                                tag: 'post${widget.posts[index].id}',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: PostPreview(
                                      id: widget.posts[index].id,
                                      post: widget.posts[index]),
                                ),
                              ),
                            );
                          })),
              ),
            ]),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Direct(
                          currentUsername: username,
                          usernames: widget.usernames)),
                );
              },
              child: const Icon(Icons.message, color: Colors.black),
            ),
          );
  }
}
