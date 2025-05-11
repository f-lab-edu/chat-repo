import 'package:chat/entity/chat_message.dart';
import 'package:chat/entity/chatroom.dart';
import 'package:chat/entity/user_chat_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRepository {
  final chatRoomKey = "ChatRoom";
  final messages = 'messages';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 채팅방 생성, chatroom 타입 필요
  Future<String> createChatRoom(ChatRoom chatRoom) async {
    try {

      final chatRoomRef = await _firestore.collection(chatRoomKey).add({
        'participants': chatRoom.participants,
        'createdAt': FieldValue.serverTimestamp(),
      });

      chatRoom.chatId = chatRoomRef.id;

      return chatRoomRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // 메시지 전송
  Future<void> sendMessage({
    required String chatId,
    required String fromUid,
    required String contents,
    required String messageType,
  }) async {
    try {

      final message = ChatMessage(
        fromUid: fromUid,
        contents: contents,
        messageType: messageType,
        readCount: 0,
        timestamp: Timestamp.now(),
      );

      await _firestore
          .collection(chatRoomKey)
          .doc(chatId)
          .collection(messages)
          .add(message as Map<String, dynamic>)
          .then((documentSnapshot) =>
          debugPrint("Added Data with ID: ${documentSnapshot.id}"));

    } catch (e) {
      rethrow;
    }
  }

  // 실시간 메시지 스트림 (모델 변환 추가), 타입으로 limit과 timestamp를 불러올 수 있도록 변경
  Stream<List<ChatMessage>> getChatMessageStream(String chatId, int limit, Timestamp time) {

    return _firestore
        .collection(chatRoomKey)
        .doc(chatId)
        .collection(messages)
        .orderBy('timestamp', descending: true)
        .startAt([time])
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data()))
          .toList();
      return messages;
    }
    );
  }

  // 사용자 채팅방 정보 스트림
  Stream<List<UserChatInfo>> getUserChatRooms(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('user_chat_info')
        .orderBy('last_query_time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserChatInfo.fromJson(doc.data()))
        .toList());
  }

  // 채팅방 나가기
  Future<void> leaveChatRoom(String chatId, String uid) async {
    await _firestore.collection('ChatRoom').doc(chatId).update({
      'participants.$uid': FieldValue.delete(),
    });
  }

}


