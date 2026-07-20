class ChatMessage {
  const ChatMessage({required this.id, required this.fromUserId, required this.text, required this.ts});

  final String id;
  final String fromUserId;
  final String text;
  final int ts;

  bool isFromMe(String myUserId) => fromUserId == myUserId;

  factory ChatMessage.fromJson(Map<String, dynamic> j) {
    return ChatMessage(
      id: j['id'] as String,
      fromUserId: j['fromUserId'] as String,
      text: j['text'] as String,
      ts: j['ts'] as int,
    );
  }
}
