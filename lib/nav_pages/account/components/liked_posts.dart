import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/feed/components/post.dart';
import 'package:social_network/models/post.dart';

class LikedPosts extends StatelessWidget {
  final List<Post> likedPosts;
  const LikedPosts({super.key, required this.likedPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Liked Posts', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: 
        Column(
          children: [
            Expanded(
              child: 
                likedPosts.isEmpty ?
                Center(
                  child: Text('No liked posts yet', style: TextStyle(color: Colors.grey[600]),),
                ) :
                ListView.builder(
                  itemCount: likedPosts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: likedPosts[index]);
                  }
                ),
            ),
          ],
        ),
    );
  }
}