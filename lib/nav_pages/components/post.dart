import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String username;
  final int id;
  const Post({super.key, required this.username, required this.id});
  
  @override
  State<Post> createState() => _Post();
}


class _Post extends State<Post>{
  bool liked = false;
  bool saved = false;

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
              color: Colors.grey[400],
              child: Center(
                child: Text(
                  "${widget.id}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold),
                ),
              )
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
                  IconButton(
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_outline,
                    ),
                    onPressed: () {
                      setState(() {
                        liked = !liked;
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.chat_bubble_outline),
                  ),
                  const Icon(Icons.share),
                ],
              ),
              IconButton(
                icon: Icon(
                  saved ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () {
                  setState(() {
                    saved = !saved;
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
          padding: const EdgeInsets.only(left: 16.0, top: 0),
          child: RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
              TextSpan(
                text: widget.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const WidgetSpan(
                child: SizedBox(
                  width: 5,
                ),
              ),
              const TextSpan(
                text: 'nice photo',
              )
            ]),
          ),
        ),
      ],
    );
  }
}
