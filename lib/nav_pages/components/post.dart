// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/open_comments.dart';

class PostCard extends StatefulWidget {
  final String username;
  final int id;
  final String imageUrl;
  List comments;
  Function? updateLikedPosts;
  Function? updateSavedPosts;
  Function? updateComments;
  int likes;
  bool liked = false;
  bool saved = false;
  PostCard({super.key, required this.username, required this.id, required this.imageUrl, 
  required this.likes, required this.comments, required this.updateLikedPosts, required this.updateSavedPosts, required this.updateComments});
  
  @override
  State<PostCard> createState() => _PostCard();
}


class _PostCard extends State<PostCard>{
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
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.more_vert),
              ],
            )),
        Hero(
          tag: 'post${widget.id}', 
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              // color: Colors.grey[400],
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ),
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
                        icon: widget.liked
                            ? Icon(Icons.favorite, color: Colors.red[900])
                            : const Icon(Icons.favorite_outline),
                        onPressed: () {
                          setState(() {
                            if (widget.liked) {
                              widget.likes--;
                            } else {
                              widget.likes++;
                            }
                            widget.liked = !widget.liked;
                            widget.updateLikedPosts?.call(widget.id);
                          });
                        },
                      ),
                      Text("${widget.likes}", style: const TextStyle(color: Colors.black),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: IconButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OpenComments(
                              comments: widget.comments,
                              postId: widget.id,
                              updateComments: widget.updateComments,
                            )
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
                  widget.saved ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () {
                  setState(() {
                    widget.saved = !widget.saved;
                    widget.updateSavedPosts?.call(widget.id);
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: const [
              Text('Liked by '),
              Text('yulicccka', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(' and '),
              Text('others', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OpenComments(comments: widget.comments, postId: widget.id, updateComments: widget.updateComments,)),
                  );
                },
                child: widget.comments[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
