
import 'dart:async';
import 'package:chat/entity/chat_message.dart';
import 'package:chat/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUseCase {
  final ChatRepository _repository;
  List<ChatMessage> messages = [];

  // 메시지 변경 감지를 위한 스트림 컨트롤러
  final _messageController = StreamController<List<ChatMessage>>.broadcast();
  Stream<List<ChatMessage>> get onMessage => _messageController.stream;

  ChatUseCase(this._repository);

  // 채팅방의 메시지 로드
  Future<void> loadMessages(String chatId, int limit, Timestamp time) async {
    _repository.getChatMessageStream(chatId, limit, time).listen((newMessages) {
      messages = newMessages;
      messages.addAll(newMessages);
      _messageController.add(messages);
    });
  }

  // 메시지 전송
  Future<void> sendMessage(String chatId, String fromUid, String message, {String messageType = 'text'}) async {
    await _repository.sendMessage(
      chatId: chatId,
      fromUid: fromUid,
      contents: message,
      messageType: messageType,
    );
  }

  // 리소스 해제
  void dispose() {
    _messageController.close();
  }
}
