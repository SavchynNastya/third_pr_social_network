import 'package:flutter/material.dart';

class StoryOpen extends StatelessWidget {
  final String username;
  const StoryOpen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Colors.grey[400],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 30, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
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
                        child: Text(
                          username,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child:  Row(
                children: [
                  SizedBox(
                    width: 295,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 221, 221, 221),
                        contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.favorite_border_rounded, color: Colors.white,)
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.send_outlined, color: Colors.white,)
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}