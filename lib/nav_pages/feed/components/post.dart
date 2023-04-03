// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './open_comments.dart';
import 'dart:async';
import './comment.dart';
import 'package:social_network/models/post.dart';
import 'package:provider/provider.dart';
import 'package:social_network/cubit/posts_cubit.dart';
import 'package:social_network/providers/user_provider.dart';
import 'package:social_network/errors_display/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCard();
}

class _PostCard extends State<PostCard> {
  late bool _loading;
  late StreamSubscription<List<dynamic>> _commentsSubscription;

  List comments = [];

  void deleteImage(String postId) async {
    setState(() {
      _loading = true;
    });
    try {
      String res = await PostsCubit().deletePost(
        widget.post.postId
      );
      if (res == "success") {
        setState(() {
          _loading = false;
        });
        showSnackBar(
          context,
          'Post has been successfully deleted.',
        );
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        _loading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    _commentsSubscription = context
        .read<PostsCubit>()
        .fetchPostComments(widget.post.postId)
        .listen((comments) {
      setState(() {
        this.comments = comments;
      });
    });
  }

  @override
  void dispose() {
    _commentsSubscription
        .cancel(); 
    super.dispose();
  }

  @override
  void deactivate() {
    _commentsSubscription.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        // color: Colors.grey[200],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(widget.post.profImage),
                        )
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.post.username,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                FirebaseAuth.instance.currentUser!.uid == widget.post.uid ?
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Delete a post?'),
                          children: <Widget>[
                            SimpleDialogOption(
                                padding: const EdgeInsets.all(20),
                                child: const Text('Yes'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  deleteImage(widget.post.postId);
                                }
                              ),
                            SimpleDialogOption(
                              padding: const EdgeInsets.all(20),
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ) 
                :
                SizedBox(),
              ],
            )
          ),
        Hero(
            tag: 'post${widget.post.postId}',
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                // color: Colors.grey[400],
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.post.postUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: widget.post.likes.contains(FirebaseAuth.instance.currentUser!.uid)
                            ? Icon(Icons.favorite, color: Colors.red[900])
                            : Icon(Icons.favorite_outline),
                        onPressed: () {
                          setState(() {
                            // Provider.of<PostsModel>(context, listen: false)
                            //     .likePost(widget.post.postId, user.uid,
                            //         widget.post.likes);
                            context.read<PostsCubit>().likePost(
                              widget.post.postId,
                              FirebaseAuth.instance.currentUser!.uid,
                              widget.post.likes
                            );
                          });
                        },
                      ),
                      Text(
                        "${widget.post.likes.length}"
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpenComments(postId: widget.post.postId),
                          ),
                        );
                      },
                      icon: Icon(Icons.chat_bubble_outline)
                    )
                  ),
                  const Icon(Icons.share),
                ],
              ),
              IconButton(
                icon: Icon(
                  widget.post.savings.contains(FirebaseAuth.instance.currentUser!.uid)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
                onPressed: () {
                  setState(() {
                    context.read<PostsCubit>().savePost(
                        widget.post.postId, FirebaseAuth.instance.currentUser!.uid, widget.post.savings);
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: widget.post.likes.isNotEmpty ?
          Row(
            children: [
              Text('Liked by '),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  String userId = widget.post.likes.last;
                  final user = Provider.of<UserProvider>(context);
                  user.getUsernameById(userId);
                  if (user.lastLikedUsername.isNotEmpty){
                    return Text('${user.lastLikedUsername}', style: TextStyle(fontWeight: FontWeight.bold));
                  }else{
                    return CircularProgressIndicator();
                  }
                  
                },
              ),
              widget.post.likes.length > 1 ?
              Row(
                children: const [
                  Text(' and '),
                  Text('others', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ) :
              SizedBox(),
            ],
          ) :
          SizedBox(),
        ),
        widget.post.desc != ""
        ?
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
          child: Row(
            children: [
              Text(widget.post.username, style: TextStyle(fontWeight: FontWeight.bold,),),
              SizedBox(width: 8,),
              Text(widget.post.desc),
            ],
          ),
        ) 
        :
        SizedBox(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenComments(postId: widget.post.postId,)
                    ),
                  );
                },
                child: Comment(comment: comments[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
