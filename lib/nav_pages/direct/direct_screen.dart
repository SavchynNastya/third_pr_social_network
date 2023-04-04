import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './components/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/cubit/chat_cubit.dart';
import './components/chat.dart';

class Direct extends StatefulWidget {
  final dynamic user;
  const Direct({super.key, required this.user});

  @override
  State<Direct> createState() => _DirectState();
}

class _DirectState extends State<Direct> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearchedChats = false;

  // @override
  // void dispose() {
  //   // user.clear();
  //   _searchController.dispose();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   user = Provider.of<UserProvider>(context, listen: false);
  //   user.clear();
  //   print(FirebaseAuth.instance.currentUser!.uid);
  //   user.fetchUser();
  //   print(FirebaseAuth.instance.currentUser!.uid);
  //   print(user.uid);
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.user.username, style: Theme.of(context).textTheme.headlineSmall),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.video_call),
              ),
              Icon(Icons.add),
            ],
          ),
        ]),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            Navigator.pop(context);
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Form(
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).disabledColor,
                    ),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: Theme.of(context).textTheme.labelLarge,
                    filled: false,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 3),
                  ),
                  controller: _searchController,
                  onFieldSubmitted: (String _) {
                    setState(() {
                      showSearchedChats = true;
                    });
                    print(_);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Messages',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text('Requests',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.blue,
                          fontSize: 20)),
                ],
              ),
            ),
            Expanded(
                child: showSearchedChats
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where(
                              'username',
                              isGreaterThanOrEqualTo: _searchController.text,
                            )
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return const Center(child: Text('No chats found.'));
                          } else {
                            final docs = snapshot.data!.docs;
                            final ids = docs.map((doc) => doc.id).toList();
                            return BlocConsumer<ChatCubit, List<ChatState>>(
                                listener: (context, state){},
                                builder: (contex, state) {
                              context
                                  .read<ChatCubit>()
                                  .fetchChatsForFollowedUsers(ids);
                              final chats = state
                                  .map((chatState) => chatState.chat)
                                  .toList();
                              return ListView.builder(
                                itemCount: chats.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            Chat(chat: chats[index]),
                                      ));
                                    },
                                    child: DialogLabel(
                                      chat: chats[index],
                                    ),
                                  );
                                  // }
                                },
                              );
                            });
                          }
                        },
                      )
                    : FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('followers', arrayContains: widget.user.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return const Center(child: Text('No chats found.'));
                          } else {
                            final docs = snapshot.data!.docs;
                            final ids = docs.map((doc) => doc.id).toList();
                            return BlocBuilder<ChatCubit, List<ChatState>>(
                                builder: (contex, state) {
                              context
                                  .read<ChatCubit>()
                                  .fetchChatsForFollowedUsers(ids);
                              final chats = state
                                  .map((chatState) => chatState.chat)
                                  .toList();
                              // print(chats);
                              return ListView.builder(
                                itemCount: chats.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            Chat(chat: chats[index]),
                                      ));
                                    },
                                    child: DialogLabel(
                                      chat: chats[index]
                                    )
                                  );
                                },
                              );
                            });
                          }
                        },
                      )),
          ],
        ),
      ),
    );
  }
}
