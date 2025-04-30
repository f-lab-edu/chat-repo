import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String? messageId; // 메시지 고유 식별자 (Firestore 문서 ID)
  String? fromUid; // 메시지 보낸 사용자 uid
  String? contents; // 메시지 내용
  String? messageType; // 메시지 타입 (예: 'text', 'image', 'file' 등)
  int? readCount; // 이 메시지를 읽은 사람 수
  DateTime? timestamp; // 메시지 전송 시각

  ChatMessage({
    this.messageId,
    this.fromUid,
    this.contents,
    this.messageType,
    this.readCount,
    this.timestamp,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'];
    fromUid = json['fromUid'];
    contents = json['contents'];
    messageType = json['messageType'];
    readCount = json['readCount'];
    timestamp =  (json['timestamp'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messageId'] = messageId;
    data['fromUid'] = fromUid;
    data['contents'] = contents;
    data['messageType'] = messageType;
    data['readCount'] = readCount;
    data['timestamp'] = timestamp;
    return data;
  }
}
