import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/reel.dart';

class Reels extends StatelessWidget{
  final List usernames;
  Reels({super.key, required this.usernames});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    final List<Widget> reels = List.generate(usernames.length, (index) {
      return Reel(username: usernames[index]);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Reels', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              Icon(Icons.camera_alt_outlined, color: Colors.white,),
            ],
          ),
        ),
      ),
      body: Expanded(
        child: PageView(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          padEnds: false,
          children: reels,
        ),
      ),
    );
  }
}