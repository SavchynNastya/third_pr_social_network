import 'package:flutter/material.dart';
import 'nav_pages/feed.dart';
import 'nav_pages/account.dart';
import 'nav_pages/search.dart';
import 'nav_pages/add_photo.dart';
import 'nav_pages/reels.dart';

class HomePage extends StatefulWidget{
  const HomePage ({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  int _selectedItem = 0;

  static const List usernames = [
    'tatasiyka',
    'lyboff',
    'yulicccka',
    'slava_aysa',
    'marineet_',
    'lbundzyak',
    'bondziakigor',
    'https.v_d'
  ];
  static const String currentUsername = 'tatasiyka';

  void _navigateBottomNavBar(int index){
    setState(() {
      _selectedItem = index;
    });
  }

  final List<Widget> _children = [
    const Feeds(usernames: usernames, currentUsername: currentUsername),
    const Search(),
    const AddPhoto(),
    Reels(usernames: usernames),
    const Account(currentUsername: currentUsername),
  ];


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _children[_selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(color: Colors.black),
        currentIndex: _selectedItem,
        onTap: _navigateBottomNavBar,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'add photo'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection_outlined), label: 'reels'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'account'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}