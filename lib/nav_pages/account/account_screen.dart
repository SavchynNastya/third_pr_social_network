// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/models/posts_storage.dart';
import 'package:social_network/models/story_collection.dart';
import 'package:social_network/providers/story_collection_provider.dart';
import 'package:social_network/nav_pages/account/components/collection_viewer.dart';
import '../feed/components/post_preview.dart';
import './components/story_collection_circle.dart';
import './components/liked_posts.dart';
import './components/saved_posts.dart';
import '../feed/components/posts_viewer.dart';
// import 'package:social_network/nav_pages/direct.dart';
import 'package:social_network/authentication/auth.dart';
import 'package:social_network/nav_pages/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_network/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_network/cubit/posts_cubit.dart';
import 'package:social_network/nav_pages/account/components/theme_toggle.dart';
import 'package:social_network/models/post.dart';

import 'package:social_network/theme.dart';

class Account extends StatefulWidget {
  final String userId;

  Account({super.key, required this.userId});

  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account> {
  bool _loading = false;

  int followers = 0;
  int following = 0;
  bool isFollowing = false;

  bool _isTapped = false;

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Color.fromARGB(255, 192, 192, 192),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  final ButtonStyle blueButtonsStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue[350],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    // user.fetchUserById(widget.userId);
    // Provider.of<PostsModel>(context).fetchPosts(widget.userId);
    // print(FirebaseAuth.instance.currentUser!.uid);
    // print(widget.userId);
    // print(user.username);

    return FutureBuilder(
      future: user.fetchUserById(widget.userId),
      builder: (context, snapshot) {
        // Provider.of<PostsModel>(context).fetchPosts(widget.userId);
        // BlocProvider.of<PostsCubit>(context).fetchPosts(widget.userId);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching user data.'),
          );
        }

        return _loading
            ? const Center(
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
                      Text(user.username,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const Icon(Icons.add_box_outlined),
                    ],
                  ),
                ),
                endDrawer: widget.userId ==
                        FirebaseAuth.instance.currentUser!.uid
                    ? Drawer(
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
                              leading: Icon(
                                Icons.messenger_outline_sharp,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: Text(
                                'Direct',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => Direct(
                                //           currentUsername: username,
                                //           usernames: widget.usernames)),
                                // );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.favorite,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: Text(
                                'Liked posts',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StreamBuilder<List<Post>>(
                                      stream: context
                                          .read<PostsCubit>()
                                          .likedPostsStream(widget.userId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        final likedPosts = snapshot.data ?? [];
                                        return LikedPosts(
                                            likedPosts: likedPosts);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.bookmark_outlined,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: Text(
                                'Saved posts',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StreamBuilder<List<Post>>(
                                      stream: context
                                          .read<PostsCubit>()
                                          .savedPostsStream(widget.userId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        final savedPosts = snapshot.data ?? [];
                                        return SavedPosts(
                                            savedPosts: savedPosts);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.settings,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: Text(
                                'Settings',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.logout,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              title: Text(
                                'Sign Out',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              onTap: () async {
                                await AuthMethods().signOut();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 150,
                              child: ListTile(
                                leading: ThemeToggle(),
                                title: Text(
                                  'Dark theme',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                body:
                    // Consumer<PostsModel>(
                    // builder: (context, postsModel, child) {
                    BlocConsumer<PostsCubit, PostsStorage>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    context.read<PostsCubit>().fetchPosts(user.uid);
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user.profilePic),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                    '${state.posts.length}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                Text('Posts',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                            Column(
                              children: [
                                Text('${user.followers.length}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                Text('Followers',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                            Column(
                              children: [
                                Text('${user.following.length}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                Text('Following',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
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
                              widget.userId ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? ElevatedButton(
                                      onPressed: () {},
                                      style: elevatedButtonStyle,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Text('Edit profile',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark)),
                                      ),
                                    )
                                  : user.followers.contains(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      ? ElevatedButton(
                                          style: elevatedButtonStyle,
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text('Unfollow',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                          onPressed: () async {
                                            await UserProvider().followUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                user.uid);

                                            setState(() {
                                              isFollowing = false;
                                              followers--;
                                            });
                                          },
                                        )
                                      : ElevatedButton(
                                          style: blueButtonsStyle,
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text('Follow',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255))),
                                          ),
                                          onPressed: () async {
                                            await UserProvider().followUser(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              user.uid,
                                            );

                                            setState(() {
                                              isFollowing = true;
                                              followers++;
                                            });
                                          },
                                        ),
                              ElevatedButton(
                                onPressed: () {},
                                style: elevatedButtonStyle,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Text('Share profile',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: elevatedButtonStyle,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Icon(Icons.group_add_outlined,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<List<StoryCollection>>(
                              stream: StoryCollectionProvider()
                                  .fetchCollections(user.uid),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                List<StoryCollection> collections =
                                    snapshot.data!;

                                return collections.isNotEmpty
                                    ? Expanded(
                                        child: Container(
                                          height: 90,
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: collections.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CollectionViewer(
                                                              collection:
                                                                  collections[
                                                                      index]),
                                                    ),
                                                  );
                                                },
                                                child: StoryCollectionCircle(
                                                  collection:
                                                      collections[index],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      width: 1)),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isTapped = !_isTapped;
                                  });
                                },
                                icon: Icon(Icons.grid_on,
                                    color: Theme.of(context).iconTheme.color),
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
                                    color: Theme.of(context).iconTheme.color),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // postsModel.posts.isEmpty
                      state.posts.isEmpty
                          ? Expanded(
                              child: Center(
                              child: Text(
                                'No posts yet',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ))
                          : Expanded(
                              child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                children:
                                    List.generate(
                                  state.posts.length,
                                  (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlocBuilder<PostsCubit,
                                                    PostsStorage>(
                                              builder: (context, state) =>
                                                  PostsViewer(
                                                      index, state.posts),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        // tag: 'post${postsModel.posts[index].postId}',
                                        tag: 'post${state.posts[index].postId}',
                                        child: Material(
                                          type: MaterialType.transparency,
                                          // child: PostPreview(post: postsModel.posts[index]),
                                          child: PostPreview(
                                              post: state.posts[index]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ]);
                  },
                ),
              );
      },
    );
  }
}
