import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/message.dart' as message_model;
import 'package:intl/intl.dart';

class Message extends StatelessWidget {
  final message_model.Message message;

  const Message({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: message.senderId == FirebaseAuth.instance.currentUser!.uid ?
          Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Text(message.messageText),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 2, left: 8, right: 8),
                  child: Text(
                    DateFormat.Hm().format(message.timestamp),
                    style: TextStyle(fontSize: 10, color: Theme.of(context).disabledColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}