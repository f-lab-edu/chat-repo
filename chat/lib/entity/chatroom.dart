
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String? chatId; // 채팅방 고유 식별자 (Firestore 문서 ID)
  Map<String, bool>? participants; // 채팅방에 참여 중인 사용자 uid 목록 (예: {'user1': true, 'user2': true})
  DateTime? createdAt; // 채팅방 생성 시각

  ChatRoom({
    this.chatId,
    this.participants,
    this.createdAt,
  });

  ChatRoom.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    participants = json['participants'];
    createdAt = (json['createdAt'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['participants'] = participants;
    data['createdAt'] = createdAt;
    return data;
  }
}
