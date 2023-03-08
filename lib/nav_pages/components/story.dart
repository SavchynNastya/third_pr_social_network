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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
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