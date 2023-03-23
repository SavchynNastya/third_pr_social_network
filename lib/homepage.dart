import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'nav_pages/feed.dart';
import 'nav_pages/account.dart';
import 'nav_pages/search.dart';
import 'nav_pages/add_photo.dart';
import 'nav_pages/reels.dart';
import 'nav_pages/components/post.dart';
import 'nav_pages/components/comment.dart';

class HomePage extends StatefulWidget{
  const HomePage ({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  int _selectedItem = 0;

  List<PostCard> likedPosts = [];
  List<PostCard> savedPosts = [];
  final List<Widget> _children = [];

  String uid = FirebaseAuth.instance.currentUser!.uid;
  late String username;

  void getUserData() async {
    DocumentSnapshot userSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      username = (userSnap.data() as Map<String, dynamic>)['username'];
    });
  }

  void updateComments(String commentText, int postId){
    setState(() {
      comments.add(Comment(
          id: comments.last.id + 1,
          postId: postId,
          username: username,
          commentText: commentText)
        );

        for(var post in feedPosts){
          post.comments = comments.where((comment) => comment.postId == post.id).toList();
        }
        for(var post in accountPosts){
          post.comments = comments.where((comment) => comment.postId == post.id).toList();
        }
        for(var post in mentionedPosts){
          post.comments = comments.where((comment) => comment.postId == post.id).toList();
        }
    });
  }

  void updateLikedPosts(int postId){
    PostCard currentPost;
    if(feedPosts.any((post) => post.id == postId)){
      currentPost = feedPosts.firstWhere((post) => post.id == postId);
      if(currentPost.liked){
        setState(() {
          likedPosts.add(currentPost);
        });
      } else {
        setState(() {
          likedPosts.remove(currentPost);
        });
      }
    }
    if (accountPosts.any((post) => post.id == postId)) {
      currentPost = accountPosts.firstWhere((post) => post.id == postId);
      if (currentPost.liked) {
        setState(() {
          likedPosts.add(currentPost);
        });
      } else {
        setState(() {
          likedPosts.remove(currentPost);
        });
      }
    }
  }

  void updateSavedPosts(int postId) {
    PostCard currentPost;
    if (feedPosts.any((post) => post.id == postId)) {
      currentPost = feedPosts.firstWhere((post) => post.id == postId);
      if (currentPost.saved) {
        setState(() {
          savedPosts.add(currentPost);
        });
      } else {
        setState(() {
          savedPosts.remove(currentPost);
        });
      }
    }
    if (accountPosts.any((post) => post.id == postId)) {
      currentPost = accountPosts.firstWhere((post) => post.id == postId);
      if (currentPost.saved) {
        setState(() {
          savedPosts.add(currentPost);
        });
      } else {
        setState(() {
          savedPosts.remove(currentPost);
        });
      }
    }
  }

  static const List usernames = [
    'lyboff',
    'yulicccka',
    'slava_aysa',
    'marineet_',
    'lbundzyak',
    'bondziakigor',
    'https.v_d'
  ];

  static List images = [
    'images/1.jpg',
    'images/2.jpg',
    'images/3.jpg',
    'images/4.jpg',
    'images/5.jpg',
    'images/6.jpg',
    'images/7.jpg',
    'images/8.jpg',
    'images/9.jpg',
    'images/10.jpg',
    'images/11.jpg',
    'images/12.jpg',
    'images/13.jpg',
    'images/14.jpg',
    'images/15.jpg',
  ];

  static List<Comment> comments = [
    Comment(id: 1, postId: 1, username: usernames[0], commentText: 'Such a nice art!',),
    Comment(id: 2, postId: 1, username: usernames[2], commentText: 'Woooow, looks amazing',),
    Comment(id: 3, postId: 3, username: usernames[1], commentText: 'Nice',),
    Comment(id: 4, postId: 4, username: usernames[4], commentText: 'I feel the vibe',),
    Comment(id: 5, postId: 4, username: usernames[2], commentText: 'Amazing',),
    Comment(id: 6, postId: 5, username: usernames[3], commentText: 'Like it',),
    Comment(id: 7, postId: 5, username: usernames[5], commentText: 'I save it',),
    Comment(id: 8, postId: 6, username: usernames[6], commentText: 'So beautiful',),
    Comment(id: 9, postId: 7, username: usernames[4], commentText: 'Cool',),
    Comment(id: 10, postId: 8, username: usernames[2], commentText: 'Subscribe',),
    Comment(id: 11, postId: 8, username: usernames[1], commentText: 'Vibe is cool',),
    Comment(id: 12, postId: 9, username: usernames[6], commentText: 'I love anime',),
    Comment(id: 13, postId: 10, username: usernames[6], commentText: 'Looks good',),
    Comment(id: 14, postId: 11, username: usernames[4], commentText: 'Just like me lol',),
    Comment(id: 15, postId: 11, username: usernames[2], commentText: 'Love your posts',),
    Comment(id: 16, postId: 12, username: usernames[1], commentText: 'Check direct pls',),
    Comment(id: 17, postId: 13, username: usernames[6], commentText: 'So good',),
    Comment(id: 18, postId: 14, username: usernames[5], commentText: 'Love the technique',),
    Comment(id: 19, postId: 15, username: usernames[2], commentText: 'Pretty',),
  ];

  static const String currentUsername = 'tatasiyka';

  static List<PostCard> feedPosts = [
    PostCard(username: usernames[0], id: 1, imageUrl: images[0], likes: 3, comments: comments.where((comment) => comment.postId == 1).toList(), updateLikedPosts: null, updateSavedPosts: null, updateComments: null,),
    PostCard(username: usernames[1], id: 2, imageUrl: images[1], likes: 1, comments: comments.where((comment) => comment.postId == 2).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: usernames[2], id: 3, imageUrl: images[2], likes: 15, comments: comments.where((comment) => comment.postId == 3).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: usernames[3], id: 4, imageUrl: images[3], likes: 100, comments: comments.where((comment) => comment.postId == 4).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: usernames[0], id: 5, imageUrl: images[4], likes: 12, comments: comments.where((comment) => comment.postId == 5).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: usernames[1], id: 6, imageUrl: images[5], likes: 6, comments: comments.where((comment) => comment.postId == 6).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: usernames[2], id: 7, imageUrl: images[6], likes: 8, comments: comments.where((comment) => comment.postId == 7).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
  ];

  static List<PostCard> accountPosts = [
    PostCard(username: currentUsername, id: 8, imageUrl: images[7], likes: 3, comments: comments.where((comment) => comment.postId == 8).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: currentUsername, id: 9, imageUrl: images[8], likes: 1, comments: comments.where((comment) => comment.postId == 9).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: currentUsername, id: 10, imageUrl: images[9], likes: 15, comments: comments.where((comment) => comment.postId == 10).toList(), updateLikedPosts: null, updateSavedPosts: null, updateComments: null,),
    PostCard(username: currentUsername, id: 11, imageUrl: images[10], likes: 100, comments: comments.where((comment) => comment.postId == 11).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: currentUsername, id: 12, imageUrl: images[11], likes: 12, comments: comments.where((comment) => comment.postId == 12).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: currentUsername, id: 13, imageUrl: images[12], likes: 6, comments: comments.where((comment) => comment.postId == 13).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: currentUsername, id: 14, imageUrl: images[13], likes: 8, comments: comments.where((comment) => comment.postId == 14).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: currentUsername, id: 15, imageUrl: images[14], likes: 8, comments: comments.where((comment) => comment.postId == 15).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
  ];

  static List<PostCard> mentionedPosts = [
    PostCard(username: usernames[0], id: 1, imageUrl: images[0], likes: 3, comments: comments.where((comment) => comment.postId == 1).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
    PostCard(username: usernames[1], id: 2, imageUrl: images[1], likes: 1, comments: comments.where((comment) => comment.postId == 2).toList(), updateLikedPosts: null,  updateSavedPosts: null, updateComments: null,),
  ];

  @override
  void initState() {
    super.initState();

    for (var post in feedPosts) {
      post.updateLikedPosts = updateLikedPosts;
      post.updateSavedPosts = updateSavedPosts;
      post.updateComments = updateComments;
    }
    for (var post in accountPosts) {
      post.updateLikedPosts = updateLikedPosts;
      post.updateSavedPosts = updateSavedPosts;
      post.updateComments = updateComments;
    }
    for (var post in mentionedPosts) {
      post.updateLikedPosts = updateLikedPosts;
      post.updateSavedPosts = updateSavedPosts;
      post.updateComments = updateComments;
    }

    _children.addAll([
      Feeds(usernames, currentUsername, feedPosts),
      const Search(),
      const AddPhoto(),
      Reels(usernames: usernames),
      Account(usernames: usernames, posts: accountPosts, mentionedPosts: mentionedPosts, likedPosts: likedPosts, savedPosts: savedPosts),
    ]);

    getUserData();
  }

  void _navigateBottomNavBar(int index){
    setState(() {
      _selectedItem = index;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _children[_selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(color: Colors.black),
        currentIndex: _selectedItem,
        onTap: _navigateBottomNavBar,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'add photo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_outlined), label: 'reels'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'account'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}