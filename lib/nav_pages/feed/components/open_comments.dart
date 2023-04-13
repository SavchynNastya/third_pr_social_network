import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_network/models/comment.dart';
import '../../../cubit/reels_cubit.dart';
import './comment_view.dart';
import 'package:provider/provider.dart';
import 'package:social_network/cubit/posts_cubit.dart';
import 'package:social_network/providers/user_provider.dart';


class OpenComments extends StatefulWidget {
  String postId;
  final bool isReel;
  OpenComments({super.key, required this.postId, required this.isReel});

  @override
  State<OpenComments> createState() => _OpenCommentsState();
}

class _OpenCommentsState extends State<OpenComments> {
  late String newComment = '';
  final commentController = TextEditingController();
  late int commentsLength;

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.blue.shade500,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    )
  );

  late final UserProvider user;

  @override
  void initState(){
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false);
    user.fetchUser();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, commentsLength);
        return Future.value(false);
      },
      child: Scaffold(
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
              child: StreamBuilder<List<Comment>>(
                stream: widget.isReel ? context.watch<ReelCubit>().fetchReelComments(widget.postId)
                                      : context.watch<PostsCubit>().fetchPostComments(widget.postId),
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
                          commentsLength = comments.length;
                          return CommentView(comment: comments[index]);
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                    child: TextField(
                      autofocus: false,
                      controller: commentController,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      newComment = commentController.text;
                      if(widget.isReel){
                        context.read<ReelCubit>().commentReel(widget.postId, newComment, user.uid,
                              user.username, user.profilePic);
                      } else {
                        context.read<PostsCubit>().postComment(widget.postId, newComment, user.uid,
                          user.username, user.profilePic);
                      }
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
        )
      ),
    );
  }
}
