import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/chat_message.dart';
import 'session.dart';

/// One socket per open chat thread (see server/README.md's WebSocket
/// section) — simplest client pattern, and it means every inbound message
/// on this channel is unambiguously for the room we joined.
class ChatSocket {
  ChatSocket._(this._channel);

  final WebSocketChannel _channel;
  final _controller = StreamController<ChatMessage>.broadcast();

  Stream<ChatMessage> get messages => _controller.stream;

  static ChatSocket connect(Session session, {required String matchId}) {
    final base = session.wsUrl;
    if (base == null) throw StateError('No server configured yet.');
    final uri = Uri.parse('$base/ws').replace(queryParameters: {'token': session.token});
    final channel = WebSocketChannel.connect(uri);
    final socket = ChatSocket._(channel);
    socket._listen();
    channel.sink.add(jsonEncode({'type': 'join', 'matchId': matchId}));
    socket._matchId = matchId;
    return socket;
  }

  late final String _matchId;

  void _listen() {
    _channel.stream.listen(
      (raw) {
        final data = jsonDecode(raw as String) as Map<String, dynamic>;
        if (data['type'] == 'message') {
          _controller.add(ChatMessage.fromJson(data['message'] as Map<String, dynamic>));
        }
      },
      onError: (_) {},
      onDone: () {},
    );
  }

  void send(String text) {
    _channel.sink.add(jsonEncode({'type': 'message', 'matchId': _matchId, 'text': text}));
  }

  void dispose() {
    _controller.close();
    _channel.sink.close();
  }
}
