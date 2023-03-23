// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/comment_view.dart';


class OpenComments extends StatefulWidget {
  final int postId;
  final List comments;
  Function? updateComments;
  OpenComments({super.key, required this.postId, required this.comments, required this.updateComments});

  @override
  State<OpenComments> createState() => _OpenCommentsState();
}

class _OpenCommentsState extends State<OpenComments> {
  late String newComment = '';
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
              child: ListView.builder(
                  itemCount: widget.comments.length,
                  itemBuilder: (context, index) {
                    return CommentView(comment: widget.comments[index]);
                  }),
            ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 8, right: 8),
                  child: TextField(
                  autofocus: false,
                  textAlign: TextAlign.start,
                  onChanged: (newText) {
                    newComment = newText;
                  },
                ),
                ),
              ),
                ElevatedButton(
                  onPressed: () {
                    // print(newComment);
                    setState(() {
                      widget.updateComments?.call(newComment, widget.postId);
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