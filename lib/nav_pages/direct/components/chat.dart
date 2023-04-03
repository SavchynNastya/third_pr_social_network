import 'package:flutter/material.dart';
import './message.dart';

class Chat extends StatefulWidget {
  final String chatId;
  const Chat({super.key, required this.chatId});

  @override
  State<Chat> createState() => _ChatState();

}

class _ChatState extends State<Chat>{

  late final FocusNode _focusNode;
  bool _showSuffixIcons = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _showSuffixIcons = !_focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Scaffold(
        extendBody: false,
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Text(widget.chatId, style: Theme.of(context).textTheme.headlineSmall),
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
                focusNode: _focusNode,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: (){},
                  ),
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                  filled: true,
                  fillColor: Theme.of(context).primaryColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 3),
                  suffixIcon: _showSuffixIcons ? 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: (){}, 
                        icon: const Icon(Icons.keyboard_voice_outlined),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.image_outlined),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.emoji_emotions_rounded),
                      ),
                    ],
                  )
                  : null
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}