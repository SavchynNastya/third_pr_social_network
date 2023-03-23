import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post.dart';

class LikedPosts extends StatelessWidget {
  final List<PostCard> likedPosts;
  const LikedPosts({super.key, required this.likedPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Liked Posts', style: TextStyle( color: Colors.black, 
                          fontWeight: FontWeight.bold)),
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
                    return likedPosts[index];
                  }
                ),
            ),
          ],
        ),
    );
  }
}