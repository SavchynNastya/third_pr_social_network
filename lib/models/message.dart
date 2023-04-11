import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String senderId;
  final String recipientId;
  final String messageText;
  final DateTime timestamp;

  Message({
    required this.messageId,
    required this.senderId,
    required this.recipientId,
    required this.messageText,
    required this.timestamp,
  });

  static Message fromSnap(snap) {
    if (snap.runtimeType == DocumentSnapshot){
      snap = snap.data() as Map<String, dynamic>;
    }

    return Message(
      messageId: snap['messageId'],
      senderId: snap['senderId'],
      recipientId: snap['recipientId'],
      messageText: snap['messageText'],
      timestamp: snap['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'senderId': senderId,
    'recipientId': recipientId,
    'messageText': messageText,
    'timestamp': timestamp,
  };

}
