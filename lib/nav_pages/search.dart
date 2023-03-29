import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/posts_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:social_network/models/posts_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_network/nav_pages/account.dart';
import 'package:social_network/nav_pages/components/account_preview.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search>{
  final TextEditingController _searchController = TextEditingController();
  bool showUsersList = false;

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserModel>(context);
    // user.fetchUser();
    // Provider.of<PostsModel>(context).fetchPosts(user.uid);

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
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Account(userId: (snapshot.data! as dynamic).docs[index]['uid']),
                  )
                );},
                child: AccountPreview(username: (snapshot.data! as dynamic).docs[index]['username'],
                          photoUrl: (snapshot.data! as dynamic).docs[index]['photoUrl']),
              );
            },
          );
        },
      )
      :
      FutureBuilder(
        future: FirebaseFirestore.instance
                .collection('posts')
                // .orderBy('datePublished')
                // .where('uid', isNotEqualTo: user.uid)
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
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Expanded(
      //       child: 
      //         SingleChildScrollView(
      //           child: PostsGrid(),
      //         )
      //     ),
      //   ],
      // )
    );
  }
}