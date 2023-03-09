import 'package:flutter/material.dart';

class Story extends StatelessWidget {

  final String username;

  const Story({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.centerLeft, 
              end: Alignment.centerRight,
              colors: [Colors.purple.shade800, Colors.orange.shade600],
            ), 
          ),
          child: Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(username),
      ],),
    );
  }
}