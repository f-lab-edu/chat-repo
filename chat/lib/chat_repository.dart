import 'package:chat/entity/chat_message.dart';
import 'package:chat/entity/user_chat_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final chatRoomKey = "ChatRoom";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 채팅방 생성
  Future<String> createChatRoom(List<String> participants) async {
    try {
      final participantsMap = {for (final uid in participants) uid: true};

      final chatRoomRef = await _firestore.collection(chatRoomKey).add({
        'participants': participantsMap,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return chatRoomRef.id;
    } catch (e) {
      print('채팅방 생성 오류: $e');
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
      final messageId = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

      final message = ChatMessage(
        messageId: messageId,
        fromUid: fromUid,
        contents: contents,
        messageType: messageType,
        readCount: 0,
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection(chatRoomKey)
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(message.toJson());
    } catch (e) {
      print('메시지 전송 오류: $e');
      rethrow;
    }
  }

  // 실시간 메시지 스트림 (모델 변환 추가)
  Stream<List<ChatMessage>> getChatMessageStream(String chatId) {
    print("dbg getChatMessageStream $chatId");
    return _firestore
        .collection(chatRoomKey)
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          final messages = snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data()))
            .toList();
            print("map snapshot $messages");
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

}


