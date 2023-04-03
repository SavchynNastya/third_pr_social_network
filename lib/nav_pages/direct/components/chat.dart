import 'package:flutter/material.dart';
import './message.dart';

class Chat extends StatelessWidget {
  final String chatId;
  const Chat({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Text(chatId, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              Row(
                children: const [
                  Icon(Icons.phone_outlined),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Icon(Icons.video_call),
                  ),
                ],
              ),
            ]
          ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder( 
              itemCount: 3,
              itemBuilder: (context, index){
                return const Message();
              }
            ),
          ),
          BottomAppBar(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: const IconButton(
                  icon: Icon(Icons.camera_alt),
                  color: Colors.black, 
                  onPressed: null,
                ),
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color.fromARGB(255, 221, 221, 221),
                contentPadding: const EdgeInsets.symmetric(vertical: 3),
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    IconButton(
                      onPressed: null, 
                      icon: Icon(Icons.keyboard_voice_outlined),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.image_outlined),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.emoji_emotions_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}