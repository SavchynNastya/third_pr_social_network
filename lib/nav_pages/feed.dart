import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post.dart';
import 'package:social_network/nav_pages/components/story.dart';
import 'package:social_network/nav_pages/direct.dart';
import 'package:social_network/nav_pages/liked.dart';

class Feeds extends StatelessWidget{
  const Feeds({Key? key, required this.usernames, required this.currentUsername}) : super(key: key);

  final List usernames;
  final String currentUsername;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Instagram', style: TextStyle(color: Colors.black)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Liked(usernames: usernames)
                      ),
                    );
                  },
                  icon: const Icon(Icons.favorite_outline),
                ),
                ),
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Direct(currentUsername: currentUsername, usernames: usernames)),
                    );
                  },
                  icon: const Icon(Icons.messenger_outline),
                ),
              ],
            )
          ]
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 130,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: usernames.length,
              
              itemBuilder: (context, index){
                return Story(username: usernames[index]);
              }
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: usernames.length,
              itemBuilder: (context, index){
                return Post(username: usernames[index],
                );
              }
            ),
          )
        ],
      ),
    );
  }
}