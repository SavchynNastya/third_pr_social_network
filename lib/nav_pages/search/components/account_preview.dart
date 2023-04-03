import 'package:flutter/material.dart';

class AccountPreview extends StatelessWidget {
  final String username;
  final String photoUrl;

  const AccountPreview({super.key, required this.username, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(photoUrl),
            )
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
  }
}