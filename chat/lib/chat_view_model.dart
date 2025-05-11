

import 'package:chat/chat_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'entity/chat_message.dart';

// 메세지 관리방법 두가지
// 1. firebase에서 주는 스트림을 Stream 으로 변형해서 위로 전달한다
// 2. Usecase가 관리한다.
// 3. view model이 관리한다.

class ChatViewModel with ChangeNotifier {
    // action: 메세지 보내기, 메세지 로드
    // data: 현재 상태(로딩 여부), 메세지들 
    bool isLoaded = false;


    // 생성자에서만 할당
    final String chatId;
    final String currentUserId; // fromUid

    List<ChatMessage> get messages => usecase.messages;

    final ChatUseCase usecase;
    
    ChatViewModel({
        required this.usecase,
        required this.chatId,
        required this.currentUserId,
    }) {
        usecase.onMessage.listen((event) {
                notifyListeners();
            },
        );
    }

    Future<void> sendMessage(String message) async {

        if (message.trim().isEmpty) return;

        try {
            await usecase.sendMessage(chatId, currentUserId, message);
        } catch(e) {
            debugPrint('error : ${e.toString()}');
        }
    }

    Future<void> loadMessage(String chatId, int limit, Timestamp time) async {
        try {
           await usecase.loadMessages(chatId, limit, time);
           isLoaded = true;
        } catch(e) {
            debugPrint('error : ${e.toString()}');
        }
    }
}