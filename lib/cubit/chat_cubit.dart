import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/models/chat.dart';
import 'package:social_network/models/message.dart';

class ChatState {
  final Chat chat;

  const ChatState(this.chat);

  ChatState copyWith({
    Chat? chat,
  }) {
    return ChatState(chat ?? this.chat);
  }
}

// abstract class ChatEvent {}

// class SendMessageEvent extends ChatEvent {
//   final Message message;

//   SendMessageEvent(this.message);
// }

// class DeleteMessageEvent extends ChatEvent {
//   final Message message;

//   DeleteMessageEvent(this.message);
// }

class ChatCubit extends Cubit<List<ChatState>> {
  final List<String> chatIds;

  ChatCubit({required this.chatIds}) : super([]);

  void sendMessage(String chatId, Message message) {
    final index = state.indexWhere((chatState) => chatState.chat.id == chatId);
    if (index == -1) {
      throw Exception('Chat with id $chatId not found');
    }
    final newChat = state[index].chat.copyWith();
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

  void loadChat(String chatId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .listen((snapshot) {
      final chat = Chat.fromSnap(snapshot);
      final index =
          state.indexWhere((chatState) => chatState.chat.id == chatId);
      if (index == -1) {
        final newChatStateList = List.of(state);
        newChatStateList.add(ChatState(chat));
        emit(newChatStateList);
      } else {
        final newChatStateList = List.of(state);
        newChatStateList[index] = ChatState(chat);
        emit(newChatStateList);
      }
    });
  }

  Future<void> fetchChatsForFollowedUsers(List<String> followedUserIds) async {
    final List<Chat> chats = [];

    for (final userId in followedUserIds) {
      final chatSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('members', arrayContains: userId)
          .get();

      if (chatSnapshot.docs.isNotEmpty) {
        final chat = Chat.fromSnap(chatSnapshot.docs[0]);
        chats.add(chat);
      } else {
        final emptyChat = Chat(
          messages: [],
          members: [userId],
          id: '',
        );
        chats.add(emptyChat);
      }
    }

    final chatStateList = chats.map((chat) => ChatState(chat)).toList();
    emit(chatStateList);
  }
}

  // @override
  // void onChange(Change<ChatState> change) {
  //   debugPrint(change.toString());
  //   super.onChange(change);
  // }

  // @override
  // void onEvent(ChatEvent event) {
  //   debugPrint(event.toString());
  //   super.onEvent(event);
  // }

  // @override
  // void onError(Object error, StackTrace stackTrace) {
  //   debugPrint(error.toString());
  //   super.onError(error, stackTrace);
  // }
