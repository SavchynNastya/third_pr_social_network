import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/feed/components/post.dart';
import 'package:social_network/models/post.dart';

class SavedPosts extends StatelessWidget {
  final List<Post> savedPosts;
  const SavedPosts({super.key, required this.savedPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Saved Posts', style: Theme.of(context).textTheme.headlineSmall,),
      ),
      body: Column(
        children: [
          Expanded(
            child: savedPosts.isEmpty
                ? Center(
                    child: Text(
                      'No saved posts yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: savedPosts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: savedPosts[index]);
                    }
                  ),
          ),
        ],
      ),
    );
  }
}
