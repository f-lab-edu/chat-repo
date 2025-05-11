import 'package:flutter/material.dart';
import 'package:chat/chat_room_list_use_case.dart';
import 'package:chat/entity/user_chat_info.dart';

class ChatRoomListViewModel with ChangeNotifier {
  List<UserChatInfo> _chatRooms = [];
  bool _isLoading = false;
  String? _error;

  List<UserChatInfo> get chatRooms => _chatRooms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ChatRoomListUseCase useCase;

  ChatRoomListViewModel(this.useCase) {
    useCase.onChatRoomsUpdated.listen((rooms) {
      _chatRooms = rooms;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> loadChatRooms(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await useCase.loadChatRooms(uid);
    } catch (e) {
      _error = '채팅방 목록을 불러오지 못했습니다';
      notifyListeners();
    }
  }

  Future<void> leaveChatRoom(String chatId, String uid) async {
    await useCase.leaveRoom(chatId, uid);
  }

  @override
  void dispose() {
    useCase.dispose();
    super.dispose();
  }
}
