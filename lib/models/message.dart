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

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
      messageId: snapshot['messageId'],
      senderId: snapshot['senderId'],
      recipientId: snapshot['recipientId'],
      messageText: snapshot['messageText'],
      timestamp: snapshot['timestamp'].toDate(),
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
