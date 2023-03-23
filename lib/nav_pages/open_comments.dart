// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:social_network/nav_pages/components/comment.dart';
import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/comment_view.dart';


class OpenComments extends StatefulWidget {
  final int postId;
  final List<Comment> comments;
  Function? updateComments;
  Stream<List<Comment>>? commentsStream;
  OpenComments({super.key, required this.postId, required this.comments, required this.updateComments, this.commentsStream});

  @override
  State<OpenComments> createState() => _OpenCommentsState();
}

class _OpenCommentsState extends State<OpenComments> {
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _comments = widget.comments;
    widget.commentsStream?.listen((comments) {
      setState(() {
        _comments = comments;
      });
    });
  }

  late String newComment = '';
  final commentController = TextEditingController();

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.blue.shade500,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Comments',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: widget.commentsStream,
              initialData: List.from(widget.comments)..addAll(_comments),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return CommentView(comment: snapshot.data![index]);
                    },
                  );
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
                  // onChanged: (newText) {
                  //   newComment = newText;
                  // },
                ),
                ),
              ),
                ElevatedButton(
                  onPressed: () {
                    print(newComment);
                    setState(() {
                      newComment = commentController.text;
                      widget.updateComments?.call(newComment, widget.postId);
                      newComment = '';
                      commentController.clear();
                      FocusScope.of(context).unfocus();
                    });
                  },
                  style: elevatedButtonStyle,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text('Send',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          )
        ],
      )
    );
  }
}