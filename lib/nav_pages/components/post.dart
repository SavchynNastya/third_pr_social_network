// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/open_comments.dart';
import 'dart:async';
import 'package:social_network/nav_pages/components/comment.dart';
import 'package:social_network/models/post.dart';
import 'package:provider/provider.dart';
import 'package:social_network/models/posts_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/errors_display/snackbar.dart';

class PostCard extends StatefulWidget {
  // final String username;
  // final int id;
  // final String imageUrl;
  // List<Comment> comments;
  // Function? updateLikedPosts;
  // Function? updateSavedPosts;
  // Function? updateComments;
  // Stream<List<Comment>>? commentsStream;
  // int likes;
  final Post post;

  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCard();
}

class _PostCard extends State<PostCard> {
  late bool _loading;

  void deleteImage(String postId) async {
    setState(() {
      _loading = true;
    });
    try {
      String res = await PostsModel().deletePost(
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
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false);
    user.fetchUser();
    final postModel = Provider.of<PostsModel>(context, listen: false);
    postModel.fetchPostComments(widget.post.postId);

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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                user.uid == widget.post.uid ?
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
                        icon: widget.post.likes.contains(user.uid)
                            ? Icon(Icons.favorite, color: Colors.red[900])
                            : Icon(Icons.favorite_outline),
                        onPressed: () {
                          setState(() {
                            Provider.of<PostsModel>(context, listen: false)
                                .likePost(widget.post.postId, user.uid,
                                    widget.post.likes);
                          });
                        },
                      ),
                      Text(
                        "${widget.post.likes.length}",
                        style: const TextStyle(color: Colors.black),
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
                  widget.post.savings.contains(user.uid)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
                onPressed: () {
                  setState(() {
                    Provider.of<PostsModel>(context, listen: false).savePost(
                        widget.post.postId, user.uid, widget.post.savings);
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
              Consumer<UserModel>(
                builder: (context, userProvider, child) {
                  String userId = widget.post.likes.last;
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
              Text(user.username, style: TextStyle(fontWeight: FontWeight.bold,),),
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
            itemCount: postModel.comments.length,
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
                child: Comment(comment: postModel.comments[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
