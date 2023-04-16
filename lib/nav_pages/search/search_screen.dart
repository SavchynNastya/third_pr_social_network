import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/search/components/posts_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/nav_pages/account/account_screen.dart';
import 'package:social_network/nav_pages/search/components/account_preview.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search>{
  final TextEditingController _searchController = TextEditingController();
  bool showUsersList = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Form(
          child: TextFormField(    
            textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white,),
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
              onFieldSubmitted: (String _){
                setState(() {
                  showUsersList = true;
                });
                print(_);
              },
          ),
        ),
      ),
      body: showUsersList ?
      FutureBuilder(
        future: FirebaseFirestore.instance
                .collection('users')
                .where(
                  'username',
                  isGreaterThanOrEqualTo: _searchController.text,
                )
                .get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: (snapshot.data as dynamic).docs.length,
            itemBuilder: (context, index){
              final data = docs[index].data();
              final hasUsername = data.containsKey('username');
              final hasPhotoUrl = data.containsKey('photoUrl');
              if(hasUsername && hasPhotoUrl){
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Account(userId: docs[index]['uid']),
                    ));
                    // Navigator.pushNamed(context, '/account', arguments: docs[index]['uid']);
                  },
                  child: AccountPreview(
                      username: docs[index]['username'],
                      photoUrl: docs[index]['photoUrl']),
                );
              }
            },
          );
        },
      )
      :
      FutureBuilder(
        future: FirebaseFirestore.instance
                .collection('posts')
                .get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return PostsGrid(postsSnapshot: snapshot,);
        },
      
      )
    );
  }
}