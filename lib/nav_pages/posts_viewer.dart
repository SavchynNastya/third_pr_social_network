import 'package:flutter/material.dart';
import 'package:social_network/models/posts_model.dart';
import 'package:social_network/models/posts_storage.dart';
import 'package:social_network/nav_pages/components/post.dart';
import 'package:provider/provider.dart';
import 'package:social_network/models/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsViewer extends StatelessWidget {
  final int initial;
  final List posts;
  late final PageController _pageController;

  PostsViewer(this.initial, this.posts, {super.key}){
    _pageController = PageController(initialPage: initial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Posts', style: Theme.of(context).textTheme.headlineSmall),
      ),
      // body: PageView(
      //   scrollDirection: Axis.vertical,
      //   controller: _pageController,
      //   padEnds: false,
      //   children: [
      //     for (var post in posts) PostCard(post: post),
      //   ],
      // ),

      // body: Consumer<PostsModel>(
      //   builder: (context, provider, _) {
      //     return PageView(
      //       scrollDirection: Axis.vertical,
      //       controller: _pageController,
      //       padEnds: false,
      //       children: [
      //         for (var post in provider.posts) PostCard(post: post),
      //       ],
      //     );
      //   },
      // ),
      body: BlocProvider<PostsCubit>(
        create: (context) => PostsCubit(),
        child: BlocBuilder<PostsCubit, PostsStorage>(
        builder: (context, state) {
          return PageView(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            padEnds: false,
            children: [
              for (var post in posts) PostCard(post: post),
            ],
          );
        },
      ),
      ),
    );
  }
}
