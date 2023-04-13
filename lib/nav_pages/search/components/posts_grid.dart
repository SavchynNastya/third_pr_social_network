import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../feed/components/post_preview.dart';
import 'package:social_network/models/post.dart';

class PostsGrid extends StatelessWidget {
  final postsSnapshot;

  const PostsGrid({super.key, required this.postsSnapshot});

  @override
  Widget build(BuildContext context){

    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      itemCount: (postsSnapshot.data! as dynamic).docs.length,
      itemBuilder: (context, index){
        return PostPreview(
          post: Post.fromSnap((postsSnapshot.data! as dynamic).docs[index]),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(
          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
    );
  }
}
