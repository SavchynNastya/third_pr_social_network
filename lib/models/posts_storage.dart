import 'package:social_network/models/post.dart';

class PostsStorage {
  final List<Post> posts;

  PostsStorage({
    required this.posts,
  });

  PostsStorage copyWith({
    List<Post>? posts,
  }) {
    return PostsStorage(
      posts: posts ?? this.posts,
    );
  }
}
