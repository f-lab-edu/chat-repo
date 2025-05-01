
import 'package:cloud_firestore/cloud_firestore.dart';

// 추가: 채팅방 정보 모델 클래스
class UserChatInfo {
  String? chatId; // 채팅방 고유 식별자
  DateTime? lastQueryTime; // 사용자가 마지막으로 이 채팅방 정보를 조회한 시각

  UserChatInfo({
    this.chatId,
    this.lastQueryTime,
  });

  UserChatInfo.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    lastQueryTime = (json['lastQueryTime'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatId'] = chatId;
    data['lastQueryTime'] = lastQueryTime;
    return data;
  }
}