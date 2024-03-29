import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/message.dart';

class Chat {
  final String id;
  final List<String> members;
  final List<dynamic> messages;

  Chat({required this.id, required this.members, required this.messages});

   Chat copyWith({
    String? id,
    List<String>? members,
    List<Message>? messages,
  }) {
    return Chat(
      id: id ?? this.id,
      members: members ?? this.members,
      messages: messages ?? this.messages,
    );
  }

  static Chat fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    var messageDocs = snap['messages'];
    // print(messageDocs);
    
    // print(messageDocs.length);
    // print(messageDocs.map((doc) => print("DOC $doc ${doc.runtimeType}")));
    var messages =
        messageDocs.map((doc) => Message.fromSnap(doc)).toList();

    return Chat(
      id: snapshot['id'],
      members: List<String>.from(snapshot['members']),
      messages: messages,
    );
  }

  Map<String, dynamic> toJson(){
    List<dynamic> messageMaps =
        messages.map((message) => message.toJson()).toList();

    return {
      'id': id,
      'members': members,
      'messages': messageMaps,
    };
  }

  void sendMessage(Message message) {
    messages.add(message);
    FirebaseFirestore.instance.collection('chats').doc(id).update({
      'messages': FieldValue.arrayUnion([message.toJson()])
    });
  }

  void deleteMessage(Message message) {
    messages.remove(message);
    FirebaseFirestore.instance.collection('chats').doc(id).update({
      'messages': FieldValue.arrayRemove([message.toJson()])
    });
  }
}
