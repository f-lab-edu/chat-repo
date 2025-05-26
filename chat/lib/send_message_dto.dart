import 'package:chat/send_message_param.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageDTO {
  final String fromUid;
  final String contents;
  final String messageType;
  final int readCount;
  final Timestamp timestamp;

  ChatMessageDTO({
    required this.fromUid,
    required this.contents,
    required this.messageType,
    required this.readCount,
    required this.timestamp,
  });

  factory ChatMessageDTO.fromParam(SendMessageParam param)
  => ChatMessageDTO(
    fromUid: param.fromUid,
    contents: param.contents,
    messageType: param.messageType,
    readCount: 0,
    timestamp: Timestamp.now(),
  );

  Map<String, dynamic> toJson() => {
    'fromUid': fromUid,
    'contents': contents,
    'messageType': messageType,
    'readCount': readCount,
    'timestamp': timestamp,
  };
}
