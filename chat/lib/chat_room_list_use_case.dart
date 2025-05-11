import 'dart:async';

import 'package:chat/entity/user_chat_info.dart';
import 'package:chat/chat_repository.dart';

class ChatRoomListUseCase {
  final ChatRepository _repository;
  final _chatRoomController = StreamController<List<UserChatInfo>>.broadcast();

  Stream<List<UserChatInfo>> get onChatRoomsUpdated => _chatRoomController.stream;

  ChatRoomListUseCase(this._repository);

  Future<void> loadChatRooms(String uid) async {
    _repository.getUserChatRooms(uid).listen((chatRooms) {
      _chatRoomController.add(chatRooms);
    });
  }

  Future<void> leaveRoom(String chatId, String uid) async {
    await _repository.leaveChatRoom(chatId, uid);
  }

  void dispose() => _chatRoomController.close();
}
