import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/cubit/chat_cubit.dart';
import './message.dart';
import 'package:provider/provider.dart';
import 'package:social_network/providers/user_provider.dart';
import 'package:social_network/models/message.dart' as message_model;

class Chat extends StatefulWidget {
  final dynamic chat;
  const Chat({super.key, required this.chat});

  @override
  State<Chat> createState() => _ChatState();

}

class _ChatState extends State<Chat>{
  final TextEditingController _messageController = TextEditingController();
  late final recipientUser;
  bool _loading = false;

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

    setState(() {
      _loading = true;
    });

    recipientUser = Provider.of<UserProvider>(context, listen: false);
    recipientUser.fetchUserById(widget.chat.members[0]).then((_) {
      setState(() {
        _loading = false;
      });
    });
    
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _focusNode.unfocus();
  }

  void deleteMessage(BuildContext parentContext, message_model.Message message) async{
    // final ChatCubit chatCubit =
    //     BlocProvider.of<ChatCubit>(parentContext, listen: false);
      return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Delete a message?'),
            children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Yes'),
                onPressed: () async {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context, listen: false)
                      .deleteMessage(
                          widget.chat.id, message);
                  // chatCubit.deleteMessage(widget.chat.id, message);
                  setState(() {});
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return _loading ?
    const Center(child: CircularProgressIndicator(),)
    :
    GestureDetector(
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
                Text(recipientUser.username, style: Theme.of(context).textTheme.headlineSmall),
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
            // StreamBuilder<List<message_model.Message>>(
            //   stream: context.watch<ChatCubit>().messagesStream(widget.chat.id),
            //   builder: (BuildContext context, AsyncSnapshot<List<message_model.Message>> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     }

            //     if (!snapshot.hasData) {
            //       return const CircularProgressIndicator();
            //     }

            //     List<message_model.Message> messages = snapshot.data!;
            //     print(messages);

            Expanded(
              child: ListView.builder(
                itemCount: widget.chat.messages.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () => deleteMessage(context, widget.chat.messages[index]),
                    child: Message(
                      message: widget.chat.messages[index],
                    ),
                  );
                },
              ),
            ),
            BottomAppBar(
              child: TextField(
                focusNode: _focusNode,
                controller: _messageController,
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
                  : IconButton(
                    onPressed: () {
                      BlocProvider.of<ChatCubit>(context, listen: false)
                        .sendMessage(widget.chat.id, _messageController.text, recipientUser.uid);
                      _messageController.clear();
                      _focusNode.unfocus();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}