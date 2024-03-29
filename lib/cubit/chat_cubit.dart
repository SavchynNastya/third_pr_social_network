import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/chat.dart';
import 'package:social_network/models/message.dart';
import 'package:uuid/uuid.dart';

class ChatState {
  final Chat chat;

  const ChatState(this.chat);

  ChatState copyWith({
    Chat? chat,
  }) {
    return ChatState(chat ?? this.chat);
  }
}

class ChatCubit extends Cubit<List<ChatState>> {
  final List<String> chatIds;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatCubit({required this.chatIds}) : super([]);

  void sendMessage(String chatId, String messageText, String recipientId) {
    final index = state.indexWhere((chatState) => chatState.chat.id == chatId);
    if (index == -1) {
      throw Exception('Chat with id $chatId not found');
    }
    final newChat = state[index].chat.copyWith();

    String messageId = const Uuid().v1();
    String senderId = newChat.members.firstWhere((element) => element != recipientId);

    Message message = Message(
      messageId: messageId, 
      senderId: senderId, 
      recipientId: recipientId, 
      messageText: messageText, 
      timestamp: DateTime.now(),
    );

    newChat.sendMessage(message);
    final newChatStateList = List.of(state);
    newChatStateList[index] = ChatState(newChat);

    emit(newChatStateList);
  }

  void deleteMessage(String chatId, Message message) {
    final index = state.indexWhere((chatState) => chatState.chat.id == chatId);
    if (index == -1) {
      throw Exception('Chat with id $chatId not found');
    }

    final newChat = state[index].chat.copyWith();
    newChat.deleteMessage(message);
    final newChatStateList = List.of(state);
    newChatStateList[index] = ChatState(newChat);

    emit(newChatStateList);
  }

  Stream<List<ChatState>> fetchChatsForFollowedUsers(
    List<String> followedUserIds,
  ) {
    final List<Chat> chats = [];

    for (final userId in followedUserIds) {
      final chatStream = FirebaseFirestore.instance
          .collection('chats')
          .where('members', arrayContains: userId)
          .snapshots();

      chatStream.listen((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          final chat = Chat.fromSnap(querySnapshot.docs[0]);
          final index = chats.indexWhere((c) => c.id == chat.id);
          if (index != -1) {
            // Chat with the same ID already exists in the list, remove it
            chats.removeAt(index);
          }
          chats.add(chat);
        } else {
          String chatId = const Uuid().v1();
          final emptyChat = Chat(
            messages: [],
            members: [userId, FirebaseAuth.instance.currentUser!.uid],
            id: chatId,
          );
          _firestore.collection('chats').doc(chatId).set(emptyChat.toJson());
          chats.add(emptyChat);
        }

        final chatStateList = chats.map((chat) => ChatState(chat)).toList();
        emit(chatStateList);
      });
    }

    if (followedUserIds.isEmpty) {
      return Stream.value([]);
    }

    return stream;
  }

}