import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/post_preview.dart';
import 'package:social_network/nav_pages/posts_viewer.dart';
import 'package:social_network/nav_pages/direct.dart';

class Account extends StatefulWidget {
  final String currentUsername;
  final List usernames;

  const Account({super.key, required this.currentUsername, required this.usernames});

  @override
  State<Account> createState() => _Account();
}

class _Account extends State<Account>{

  bool _isTapped = false;

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black26,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    )
  );

  // final posts = Post()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Text(widget.currentUsername, style: const TextStyle(color: Colors.black)),
              const Icon(Icons.add_box_outlined, color: Colors.black),
            ],
          ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text('Profile Menu', style: TextStyle(color: Colors.white),),
            ),
            ListTile(
              leading: const Icon(
                Icons.messenger_outline_sharp,
                color: Colors.grey,
              ),
              title: const Text('Direct'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Direct(
                          currentUsername: widget.currentUsername,
                          usernames: widget.usernames)),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: const [
                  Text(
                    '17',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Posts',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    '234',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Followers',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    '100',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Following',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              onPressed: null,
              style: elevatedButtonStyle,
              child: const Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text('Edit profile',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            ElevatedButton(
              onPressed: null,
              style: elevatedButtonStyle,
              child: const Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Text('Share profile',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            ElevatedButton(
              onPressed: null,
              style: elevatedButtonStyle,
              child: const Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Icon(
                  Icons.group_add_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black54, width: 1),
                        ),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.add),
                        ),
                      ),
                      const Text(
                        'Create',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
            ],
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.black45, width: 1)
                ),
              ),
              child:FractionallySizedBox(
                widthFactor: 1,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isTapped = !_isTapped;
                    });
                  },
                  icon: const Icon(
                    Icons.grid_on,
                    color: Colors.black,
                  ),
                ),
              ),
            )),
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isTapped = !_isTapped;
                    });
                  },
                  icon: Icon(
                    _isTapped ? Icons.person_pin_rounded : Icons.person_pin_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            children: 
              _isTapped ? 
                List.generate(2, (index) {
                  index += 17;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostsViewer(widget.currentUsername, index, 2)),
                      );
                    },
                    child: Hero(
                      tag: 'post$index',
                      child: Material(
                        type: MaterialType.transparency,
                        child: PostPreview(id: index),
                      ),
                    ),
                  );
                }) :
                List.generate(17, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostsViewer(widget.currentUsername, index, 17)),
                      );
                    },
                    child: Hero(
                      tag: 'post$index',
                      child: Material(
                        type: MaterialType.transparency,
                        child: PostPreview(id: index),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Direct(
                    currentUsername: widget.currentUsername, usernames: widget.usernames)),
          );
        },
        child: const Icon(Icons.message, color: Colors.black),
      ),
    );
  }
}