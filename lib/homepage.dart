import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'nav_pages/feed/feed_screen.dart';
import 'nav_pages/account/account_screen.dart';
import 'nav_pages/search/search_screen.dart';
import 'nav_pages/add_photo/add_photo_screen.dart';
import 'nav_pages/reels/reels_screen.dart';
import 'nav_pages/feed/components/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedItem = 0;

  List<PostCard> likedPosts = [];
  List<PostCard> savedPosts = [];
  final List<Widget> _children = [];

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // static const List usernames = [
  //   'lyboff',
  //   'yulicccka',
  //   'slava_aysa',
  //   'marineet_',
  //   'lbundzyak',
  //   'bondziakigor',
  //   'https.v_d'
  // ];


  @override
  void initState() {
    super.initState();

    _children.addAll([
      const Feed(),
      const Search(),
      const AddPhoto(),
      const Reels(),
      Account(
        userId: FirebaseAuth.instance.currentUser!.uid,
      ),
    ]);

  }

  void _navigateBottomNavBar(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          final NavigatorState navigator =
              _navigatorKeys[_selectedItem].currentState!;
          if (navigator.canPop()) {
            navigator.pop();
            return false;
          }
          return true;
        },
        child: IndexedStack(
          index: _selectedItem,
          children: _children
              .asMap()
              .map((i, page) => MapEntry(
                  i,
                  Navigator(
                    key: _navigatorKeys[i],
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => page,
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
      // _children[_selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedItem,
        onTap: _navigateBottomNavBar,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: 'feed',
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color.fromARGB(255, 149, 56, 206), Colors.orange.shade600],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255),),
            ),
            icon: const Icon(Icons.home, color: Colors.grey),
          ),
          BottomNavigationBarItem(
            label: 'feed',
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color.fromARGB(255, 149, 56, 206), Colors.orange.shade600],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.search, color: Color.fromARGB(255, 255, 255, 255),),
            ),
            icon: const Icon(Icons.search, color: Colors.grey),
          ),
          BottomNavigationBarItem(
            label: 'feed',
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color.fromARGB(255, 149, 56, 206), Colors.orange.shade600],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255),),
            ),
            icon: const Icon(Icons.add, color: Colors.grey),
          ),
          BottomNavigationBarItem(
            label: 'feed',
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color.fromARGB(255, 149, 56, 206), Colors.orange.shade600],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.video_collection_outlined, color: Color.fromARGB(255, 255, 255, 255),),
            ),
            icon: const Icon(Icons.video_collection_outlined, color: Colors.grey),
          ),
          BottomNavigationBarItem(
            label: 'feed',
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color.fromARGB(255, 149, 56, 206), Colors.orange.shade600],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.person, color: Color.fromARGB(255, 255, 255, 255),),
            ),
            icon: const Icon(Icons.person, color: Colors.grey),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // void _onTap(int val, BuildContext context) {
  //   if (_selectedItem == val) {
  //     switch (val) {
  //       case 0:
  //         _feedScreen.currentState?.popUntil((route) => route.isFirst);
  //         break;
  //       case 1:
  //         _searchScreen.currentState?.popUntil((route) => route.isFirst);
  //         break;
  //       case 2:
  //         _addScreen.currentState?.popUntil((route) => route.isFirst);
  //         break;
  //       case 3:
  //         _reelsScreen.currentState?.popUntil((route) => route.isFirst);
  //         break;
  //       case 4:
  //         _accountScreen.currentState?.popUntil((route) => route.isFirst);
  //         break;
  //       default:
  //     }
  //   } else {
  //     if (mounted) {
  //       setState(() {
  //         _selectedItem = val;
  //       });
  //     }
  //   }
  // }
}
