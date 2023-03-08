import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/posts_grid.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: 
          TextField(    
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
          ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          PostsGrid(),
        ],
      )
    );
  }
}