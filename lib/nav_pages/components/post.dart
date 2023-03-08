import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final String username;
  const Post({super.key, required this.username});
  
  @override
  State<Post> createState() => _Post();
}


class _Post extends State<Post>{
  bool liked = false;

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
        Container(
          height: 400,
          color: Colors.grey[400],
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
              const Icon(Icons.bookmark),
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
