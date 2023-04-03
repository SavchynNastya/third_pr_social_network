import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_network/models/comment.dart';
import './comment_view.dart';
import 'package:provider/provider.dart';
import 'package:social_network/cubit/posts_cubit.dart';
import 'package:social_network/providers/user_provider.dart';

class OpenComments extends StatefulWidget {
  String postId;
  OpenComments({super.key, required this.postId});

  @override
  State<OpenComments> createState() => _OpenCommentsState();
}

class _OpenCommentsState extends State<OpenComments> {
  late String newComment = '';
  final commentController = TextEditingController();

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.blue.shade500,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    )
  );


  @override
  Widget build(BuildContext context) {

    final postCubit = context.watch<PostsCubit>();
    final postCommentsStream = postCubit.fetchPostComments(widget.postId);


    final user = Provider.of<UserProvider>(context, listen: false);
    user.fetchUser();

    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Comments', style: Theme.of(context).textTheme.headlineSmall),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // child: StreamBuilder<List<Comment>>(
              //   stream: widget.commentsStream,
              //   initialData: List.from(widget.comments)..addAll(_comments),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<List<Comment>> snapshot) {
              //     if (snapshot.hasData) {
              // return ListView.builder(
              //   itemCount: snapshot.data!.length,
              //   itemBuilder: (context, index) {
              //     return CommentView(comment: snapshot.data![index]);
              //   },
              // );
              //     } else {
              //       return Center(child: CircularProgressIndicator());
              //     }
              //   },
              // ),

              child: StreamBuilder<List<Comment>>(
                stream: postCommentsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Comment>> snapshot) {
                  if (snapshot.hasData) {
                    final comments = snapshot.data!;
                    if (comments.isEmpty) {
                      return Center(
                        child: Text('No comments yet',
                            style: TextStyle(color: Colors.grey[600])),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return CommentView(comment: comments[index]);
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 8, right: 8),
                    child: TextField(
                      autofocus: false,
                      controller: commentController,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(newComment);
                    setState(() {
                      newComment = commentController.text;
                      postCubit.postComment(widget.postId, newComment, user.uid,
                          user.username, user.profilePic);
                      // widget.updateComments?.call(newComment, widget.postId);
                      newComment = '';
                      commentController.clear();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  style: elevatedButtonStyle,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
