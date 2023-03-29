// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:social_network/models/story_collection.dart';
import 'package:social_network/models/story_collection_model.dart';
import 'package:social_network/nav_pages/components/collection_viewer.dart';
import 'package:social_network/nav_pages/components/post_preview.dart';
import 'package:social_network/nav_pages/components/story_collection_circle.dart';
import 'package:social_network/nav_pages/liked_posts.dart';
import 'package:social_network/nav_pages/saved_posts.dart';
import 'package:social_network/nav_pages/posts_viewer.dart';
// import 'package:social_network/nav_pages/direct.dart';
import 'package:social_network/authentication/auth.dart';
import 'package:social_network/nav_pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_network/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:social_network/models/posts_model.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    // user.fetchUserById(widget.userId);
    // Provider.of<PostsModel>(context).fetchPosts(widget.userId);
    // print(FirebaseAuth.instance.currentUser!.uid);
    // print(widget.userId);
    // print(user.username);

    return FutureBuilder(
      future: user.fetchUserById(widget.userId),
      builder: (context, snapshot) {
        Provider.of<PostsModel>(context).fetchPosts(widget.userId);
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
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user.username,
                      style: const TextStyle(color: Colors.black)),
                  const Icon(Icons.add_box_outlined, color: Colors.black),
                ],
              ),
            ),
            endDrawer: widget.userId == FirebaseAuth.instance.currentUser!.uid
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
                          leading: const Icon(
                            Icons.messenger_outline_sharp,
                            color: Colors.grey,
                          ),
                          title: const Text('Direct'),
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
                          leading: const Icon(
                            Icons.favorite,
                            color: Colors.grey,
                          ),
                          title: const Text('Liked posts'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Consumer<PostsModel>(
                                      builder: (context, postsModel, child){
                                        Provider.of<PostsModel>(context)
                                        .fetchLikedPosts
                                        (FirebaseAuth.instance.currentUser!.uid);
                                        return LikedPosts(
                                          likedPosts: postsModel.likedPosts,
                                        );
                                      }
                                ),
                              ),
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
                                builder: (context) => Consumer<PostsModel>(
                                    builder: (context, postsModel, child) {
                                  Provider.of<PostsModel>(context)
                                      .fetchSavedPosts(FirebaseAuth
                                          .instance.currentUser!.uid);
                                  return SavedPosts(
                                    savedPosts: postsModel.savedPosts,
                                  );
                                }),
                              ),
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
                  )
                : const SizedBox(),
            body: 
              Consumer<PostsModel>(
              builder: (context, postsModel, child) {
                // if (postsModel.posts.isEmpty) {
                //   return Center(
                //     // child: CircularProgressIndicator(),
                //     child: Text('No posts yet', style: TextStyle(color: Colors.grey[600]),),
                //   );
                // }
                

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
                          '${postsModel.posts.length}',
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
                          '${user.followers.length}',
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
                          '${user.following.length}',
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
                      widget.userId == FirebaseAuth.instance.currentUser!.uid
                          ? ElevatedButton(
                              onPressed: () {},
                              style: elevatedButtonStyle,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Text('Edit profile',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            )
                          : user.followers.contains(FirebaseAuth.instance.currentUser!.uid)
                              ? ElevatedButton(
                                  style: elevatedButtonStyle,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Text('Unfollow',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  onPressed: () async {
                                    await UserModel().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      user.uid
                                    );

                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  },
                                )
                              : ElevatedButton(
                                  style: blueButtonsStyle,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Text('Follow',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255))),
                                  ),
                                  onPressed: () async {
                                    await UserModel().followUser(
                                      FirebaseAuth.instance.currentUser!.uid,
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
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text('Share profile',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
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
                    StreamBuilder<List<StoryCollection>>(
                      stream: StoryCollectionModel().fetchCollections(user.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        List<StoryCollection> collections = snapshot.data!;

                        return collections.isNotEmpty?
                        Expanded(
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
                                        CollectionViewer(collection: collections[index]),
                                    ),
                                  );
                                },
                                child: StoryCollectionCircle(collection: collections[index],),
                              );
                            },
                          ),
                        ),
                        ) 
                        : 
                        SizedBox.shrink();
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 10),
                    //   child: ListView.builder(

                    //   ),
                    // ),

                    // Padding(
                    //     padding: const EdgeInsets.only(right: 10),
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           width: 60,
                    //           height: 60,
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: Colors.transparent,
                    //             border:
                    //                 Border.all(color: Colors.black54, width: 1),
                    //           ),
                    //           child: const SizedBox(
                    //             width: 40,
                    //             height: 40,
                    //             child: Icon(Icons.add),
                    //           ),
                    //         ),
                    //         const Text(
                    //           'Create',
                    //           style: TextStyle(color: Colors.black),
                    //         )
                    //       ],
                    //     )
                    //   ),
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
              postsModel.posts.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No posts yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  )
                :
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  children:
                  
                      // _isTapped
                      //     ? List.generate(widget.mentionedPosts.length, (index) {
                      //         return GestureDetector(
                      //           onTap: () {
                      //             Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => PostsViewer(
                      //                       index, widget.mentionedPosts)),
                      //             );
                      //           },
                      //           child: Hero(
                      //             tag: 'post${widget.mentionedPosts[index].id}',
                      //             child: Material(
                      //               type: MaterialType.transparency,
                      //               child: PostPreview(
                      //                   id: widget.mentionedPosts[index].id,
                      //                   post: widget.mentionedPosts[index]),
                      //             ),
                      //           ),
                      //         );
                      //       })
                      //     :
                      List.generate(
                    postsModel.posts.length,
                    (index) {
                      // index += 17;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // PostsViewer(index, posts)
                                  Consumer<PostsModel>(
                                builder: (context, postsModel, child) =>
                                    PostsViewer(index, postsModel.posts),
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'post${postsModel.posts[index].postId}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: PostPreview(post: postsModel.posts[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]
            );
              },
              child: SizedBox(),
            ),
            
          );
      },
    );
    // return _loading
    //     ? const Center(
    //         child: CircularProgressIndicator(),
    //       )
    //     : Scaffold(
    //         appBar: AppBar(
    //           iconTheme: const IconThemeData(
    //             color: Colors.black,
    //           ),
    //           backgroundColor: Colors.transparent,
    //           elevation: 0,
    //           title: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(user.username,
    //                   style: const TextStyle(color: Colors.black)),
    //               const Icon(Icons.add_box_outlined, color: Colors.black),
    //             ],
    //           ),
    //         ),
    //         endDrawer: widget.userId == FirebaseAuth.instance.currentUser!.uid
    //             ? Drawer(
    //                 child: ListView(
    //                   padding: EdgeInsets.zero,
    //                   children: [
    //                     const DrawerHeader(
    //                       decoration: BoxDecoration(
    //                         color: Colors.grey,
    //                       ),
    //                       child: Text(
    //                         'Profile Menu',
    //                         style: TextStyle(color: Colors.white),
    //                       ),
    //                     ),
    //                     ListTile(
    //                       leading: const Icon(
    //                         Icons.messenger_outline_sharp,
    //                         color: Colors.grey,
    //                       ),
    //                       title: const Text('Direct'),
    //                       onTap: () {
    //                         // Navigator.push(
    //                         //   context,
    //                         //   MaterialPageRoute(
    //                         //       builder: (context) => Direct(
    //                         //           currentUsername: username,
    //                         //           usernames: widget.usernames)),
    //                         // );
    //                       },
    //                     ),
    //                     ListTile(
    //                       leading: const Icon(
    //                         Icons.favorite,
    //                         color: Colors.grey,
    //                       ),
    //                       title: const Text('Liked posts'),
    //                       onTap: () {
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) =>
    //                                 Consumer<PostsModel>(
    //                                   builder: (context, postsModel, child){
    //                                     Provider.of<PostsModel>(context)
    //                                     .fetchLikedPosts
    //                                     (FirebaseAuth.instance.currentUser!.uid);
    //                                     return LikedPosts(
    //                                       likedPosts: postsModel.likedPosts,
    //                                     );
    //                                   }
    //                             ),
    //                           ),
    //                         );
    //                       },
                          
    //                     ),
    //                     ListTile(
    //                       leading: const Icon(
    //                         Icons.bookmark_outlined,
    //                         color: Colors.grey,
    //                       ),
    //                       title: const Text('Saved posts'),
    //                       onTap: () {
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) => Consumer<PostsModel>(
    //                                 builder: (context, postsModel, child) {
    //                               Provider.of<PostsModel>(context)
    //                                   .fetchSavedPosts(FirebaseAuth
    //                                       .instance.currentUser!.uid);
    //                               return SavedPosts(
    //                                 savedPosts: postsModel.savedPosts,
    //                               );
    //                             }),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                     ListTile(
    //                       leading: const Icon(
    //                         Icons.settings,
    //                         color: Colors.grey,
    //                       ),
    //                       title: const Text('Settings'),
    //                       onTap: () {
    //                         Navigator.pop(context);
    //                       },
    //                     ),
    //                     ListTile(
    //                       leading: const Icon(
    //                         Icons.logout,
    //                         color: Colors.grey,
    //                       ),
    //                       title: const Text('Sign Out'),
    //                       onTap: () async {
    //                         await AuthMethods().signOut();
    //                         Navigator.of(context).pushReplacement(
    //                           MaterialPageRoute(
    //                             builder: (context) => const Login(),
    //                           ),
    //                         );
    //                       },
    //                     )
    //                   ],
    //                 ),
    //               )
    //             : const SizedBox(),
    //         body: 
    //           Consumer<PostsModel>(
    //           builder: (context, postsModel, child) {
    //             // if (postsModel.posts.isEmpty) {
    //             //   return Center(
    //             //     // child: CircularProgressIndicator(),
    //             //     child: Text('No posts yet', style: TextStyle(color: Colors.grey[600]),),
    //             //   );
    //             // }
                

    //             return Column(children: [
    //           Padding(
    //             padding: const EdgeInsets.only(left: 15, right: 15),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Container(
    //                   width: 80,
    //                   height: 80,
    //                   decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     image: DecorationImage(
    //                       image: NetworkImage(user.profilePic),
    //                     ),
    //                   ),
    //                 ),
    //                 Column(
    //                   children: [
    //                     Text(
    //                       '${postsModel.posts.length}',
    //                       style: const TextStyle(
    //                           fontWeight: FontWeight.bold, color: Colors.black),
    //                     ),
    //                     const Text(
    //                       'Posts',
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w400, color: Colors.black),
    //                     ),
    //                   ],
    //                 ),
    //                 Column(
    //                   children: [
    //                     Text(
    //                       '${user.followers.length}',
    //                       style: const TextStyle(
    //                           fontWeight: FontWeight.bold, color: Colors.black),
    //                     ),
    //                     const Text(
    //                       'Followers',
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w400, color: Colors.black),
    //                     ),
    //                   ],
    //                 ),
    //                 Column(
    //                   children: [
    //                     Text(
    //                       '${user.following.length}',
    //                       style: const TextStyle(
    //                           fontWeight: FontWeight.bold, color: Colors.black),
    //                     ),
    //                     const Text(
    //                       'Following',
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w400, color: Colors.black),
    //                     ),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(10),
    //             child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   widget.userId == FirebaseAuth.instance.currentUser!.uid
    //                       ? ElevatedButton(
    //                           onPressed: () {},
    //                           style: elevatedButtonStyle,
    //                           child: const Padding(
    //                             padding: EdgeInsets.only(left: 5, right: 5),
    //                             child: Text('Edit profile',
    //                                 style: TextStyle(color: Colors.black)),
    //                           ),
    //                         )
    //                       : user.followers.contains(FirebaseAuth.instance.currentUser!.uid)
    //                           ? ElevatedButton(
    //                               style: elevatedButtonStyle,
    //                               child: const Padding(
    //                                 padding: EdgeInsets.only(left: 5, right: 5),
    //                                 child: Text('Unfollow',
    //                                     style: TextStyle(color: Colors.black)),
    //                               ),
    //                               onPressed: () async {
    //                                 await UserModel().followUser(
    //                                   FirebaseAuth.instance.currentUser!.uid,
    //                                   user.uid
    //                                 );

    //                                 setState(() {
    //                                   isFollowing = false;
    //                                   followers--;
    //                                 });
    //                               },
    //                             )
    //                           : ElevatedButton(
    //                               style: blueButtonsStyle,
    //                               child: const Padding(
    //                                 padding: EdgeInsets.only(left: 5, right: 5),
    //                                 child: Text('Follow',
    //                                     style: TextStyle(
    //                                         color: Color.fromARGB(
    //                                             255, 255, 255, 255))),
    //                               ),
    //                               onPressed: () async {
    //                                 await UserModel().followUser(
    //                                   FirebaseAuth.instance.currentUser!.uid,
    //                                   user.uid,
    //                                 );

    //                                 setState(() {
    //                                   isFollowing = true;
    //                                   followers++;
    //                                 });
    //                               },
    //                             ),
    //                   ElevatedButton(
    //                     onPressed: () {},
    //                     style: elevatedButtonStyle,
    //                     child: const Padding(
    //                       padding: EdgeInsets.only(left: 5, right: 5),
    //                       child: Text('Share profile',
    //                           style: TextStyle(color: Colors.black)),
    //                     ),
    //                   ),
    //                   ElevatedButton(
    //                     onPressed: () {},
    //                     style: elevatedButtonStyle,
    //                     child: const Padding(
    //                       padding: EdgeInsets.only(left: 5, right: 5),
    //                       child: Icon(
    //                         Icons.group_add_outlined,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ),
    //                 ]),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 StreamBuilder<List<StoryCollection>>(
    //                   stream: StoryCollectionModel().fetchCollections(user.uid),
    //                   builder: (context, snapshot) {
    //                     if (!snapshot.hasData) {
    //                       return CircularProgressIndicator();
    //                     }
    //                     List<StoryCollection> collections = snapshot.data!;

    //                     return collections.length > 0?
    //                     Expanded(
    //                       child: Container(
    //                       height: 90,
    //                       padding: const EdgeInsets.only(
    //                           left: 10.0, right: 10.0),
    //                       child: ListView.builder(
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount: collections.length,
    //                         itemBuilder: (context, index) {
    //                           return GestureDetector(
    //                             onTap: () {
    //                               Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (context) =>
    //                                     CollectionViewer(collection: collections[index]),
    //                                 ),
    //                               );
    //                             },
    //                             child: StoryCollectionCircle(collection: collections[index],),
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                     ) 
    //                     : 
    //                     SizedBox.shrink();
    //                   },
    //                 ),
    //                 // Padding(
    //                 //   padding: const EdgeInsets.only(right: 10),
    //                 //   child: ListView.builder(

    //                 //   ),
    //                 // ),

    //                 // Padding(
    //                 //     padding: const EdgeInsets.only(right: 10),
    //                 //     child: Column(
    //                 //       children: [
    //                 //         Container(
    //                 //           width: 60,
    //                 //           height: 60,
    //                 //           decoration: BoxDecoration(
    //                 //             shape: BoxShape.circle,
    //                 //             color: Colors.transparent,
    //                 //             border:
    //                 //                 Border.all(color: Colors.black54, width: 1),
    //                 //           ),
    //                 //           child: const SizedBox(
    //                 //             width: 40,
    //                 //             height: 40,
    //                 //             child: Icon(Icons.add),
    //                 //           ),
    //                 //         ),
    //                 //         const Text(
    //                 //           'Create',
    //                 //           style: TextStyle(color: Colors.black),
    //                 //         )
    //                 //       ],
    //                 //     )
    //                 //   ),
    //               ],
    //             ),
    //           ),
    //           Row(
    //             children: [
    //               Flexible(
    //                   child: Container(
    //                 decoration: const BoxDecoration(
    //                   border: Border(
    //                       right: BorderSide(color: Colors.black45, width: 1)),
    //                 ),
    //                 child: FractionallySizedBox(
    //                   widthFactor: 1,
    //                   child: IconButton(
    //                     onPressed: () {
    //                       setState(() {
    //                         _isTapped = !_isTapped;
    //                       });
    //                     },
    //                     icon: const Icon(
    //                       Icons.grid_on,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                 ),
    //               )),
    //               Flexible(
    //                 child: FractionallySizedBox(
    //                   widthFactor: 1,
    //                   child: IconButton(
    //                     onPressed: () {
    //                       setState(() {
    //                         _isTapped = !_isTapped;
    //                       });
    //                     },
    //                     icon: Icon(
    //                       _isTapped
    //                           ? Icons.person_pin_rounded
    //                           : Icons.person_pin_outlined,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           postsModel.posts.isEmpty
    //             ? Expanded(
    //                 child: Center(
    //                   child: Text(
    //                     'No posts yet',
    //                     style: TextStyle(color: Colors.grey[600]),
    //                   ),
    //                 )
    //               )
    //             :
    //           Expanded(
    //             child: GridView.count(
    //               crossAxisCount: 3,
    //               crossAxisSpacing: 2,
    //               mainAxisSpacing: 2,
    //               children:
                  
    //                   // _isTapped
    //                   //     ? List.generate(widget.mentionedPosts.length, (index) {
    //                   //         return GestureDetector(
    //                   //           onTap: () {
    //                   //             Navigator.push(
    //                   //               context,
    //                   //               MaterialPageRoute(
    //                   //                   builder: (context) => PostsViewer(
    //                   //                       index, widget.mentionedPosts)),
    //                   //             );
    //                   //           },
    //                   //           child: Hero(
    //                   //             tag: 'post${widget.mentionedPosts[index].id}',
    //                   //             child: Material(
    //                   //               type: MaterialType.transparency,
    //                   //               child: PostPreview(
    //                   //                   id: widget.mentionedPosts[index].id,
    //                   //                   post: widget.mentionedPosts[index]),
    //                   //             ),
    //                   //           ),
    //                   //         );
    //                   //       })
    //                   //     :
    //                   List.generate(
    //                 postsModel.posts.length,
    //                 (index) {
    //                   // index += 17;
    //                   return GestureDetector(
    //                     onTap: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) =>
    //                               // PostsViewer(index, posts)
    //                               Consumer<PostsModel>(
    //                             builder: (context, postsModel, child) =>
    //                                 PostsViewer(index, postsModel.posts),
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                     child: Hero(
    //                       tag: 'post${postsModel.posts[index].postId}',
    //                       child: Material(
    //                         type: MaterialType.transparency,
    //                         child: PostPreview(post: postsModel.posts[index]),
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //           ),
    //         ]
    //         );
    //           },
    //           child: SizedBox(),
    //         ),
            
    //       );
  }
}
