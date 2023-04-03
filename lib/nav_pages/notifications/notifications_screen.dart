import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/notifications/components/notification.dart';

class Liked extends StatelessWidget {
  final List usernames;
  const Liked({super.key, required this.usernames});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text('New', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: usernames.length,
                itemBuilder: (context, index) {
                  return LikedNotification(
                    username: usernames[index],
                  );
                }
              ),
            ),
          ],
        ),
      )
    );
  }
}