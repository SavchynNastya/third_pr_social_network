import 'package:flutter/material.dart';

class Reel extends StatelessWidget {
  final String username;

  const Reel({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height - 60,
      color: Colors.grey[400],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: 
              Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 124, 124, 124),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent, 
                  side: const BorderSide(width: 1, color: Colors.white),
                  padding: const EdgeInsets.only(left: 7, right: 7),
                ),
                onPressed: () {},
                child: const Text(
                  'Follow',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.favorite_outline, color: Colors.white,),
                    SizedBox(height: 5,),
                    Text('54', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.mode_comment_outlined, color: Colors.white,),
                    SizedBox(height: 5,),
                    Text('10', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.navigation_outlined, color: Colors.white,),
              ),
            ],
          )
        ],
      ),
    );
  }
}