import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './components/dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../providers/user_provider.dart';
import 'package:social_network/models/chat.dart' as chat_structure;
import 'package:social_network/cubit/chat_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './components/chat.dart';

class Direct extends StatefulWidget {
  Direct({super.key});

  @override
  State<Direct> createState() => _DirectState();

}

class _DirectState extends State<Direct>{
  final TextEditingController _searchController = TextEditingController();
  bool showSearchedChats = false;

  @override
  void dispose(){
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.fetchUser();

    return Scaffold(
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
              Text(user.username, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
          if(details.delta.dx > 0){
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
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 221, 221, 221),
                    contentPadding: const EdgeInsets.symmetric(vertical: 3),
                  ),
                  controller: _searchController,
                  onFieldSubmitted: (String _) {
                    print(_);
                    showSearchedChats = true;
                  },
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Messages', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 20)),
                  Text('Requests',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.blue,
                      fontSize: 18
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: 
                showSearchedChats ?
                FutureBuilder(
                  future: FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'username',
                            isGreaterThanOrEqualTo: _searchController.text,
                          )
                          .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No chats found.'));
                    } else {
                      final docs = snapshot.data!.docs;
                      final data = docs.map((doc) => doc.data()).toList();
                      print('$data DataDATAAAAAAAAA');
                      final ids = docs.map((doc) => doc.id).toList();
                      return BlocConsumer<ChatCubit, List<ChatState>>(
                       listener: (context, state) {
                        context.read<ChatCubit>().fetchChatsForFollowedUsers(ids);
                       },
                       builder: (contex, state){
                        
                        final chats = state.map((chatState) => chatState.chat).toList();
                        return ListView.builder(
                          itemCount: (snapshot.data as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            // final data = docs[index].data();
                            // final hasUsername = data.containsKey('username');
                            // final hasPhotoUrl = data.containsKey('photoUrl');
                            // if (hasUsername && hasPhotoUrl) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        Chat(chatId: chats[index].id),
                                  ));
                                },
                                child: NewDialog(
                                  chatId: chats[index].id,
                                ),
                              );
                            // }
                          },
                        );
                       }
                      );
                      
                    }
                  },
                )
                :
                
                ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return NewDialog(
                      chatId: 'jdhg',
                    );
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }
}