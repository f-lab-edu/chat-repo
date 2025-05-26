class SendMessageParam {
  final String chatId;
  final String fromUid;
  final String contents;
  final String messageType;

  SendMessageParam({
    required this.chatId,
    required this.fromUid,
    required this.contents,
    required this.messageType,
  });
}
