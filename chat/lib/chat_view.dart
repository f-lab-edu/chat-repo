import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_view_model.dart';
import 'entity/chat_message.dart';

class ChatView extends StatelessWidget {
  final String chatId;
  final String currentUserId;

  const ChatView({
    super.key,
    required this.chatId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    // ViewModel 초기화는 외부에서 해주거나, 여기서 한 번만 호출
    final viewModel = Provider.of<ChatViewModel>(context, listen: false);


    // if (!viewModel.isLoaded || viewModel.chatId != chatId) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     viewModel.loadMessage(chatId, currentUserId);
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방'),
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: viewModel.messages.length,
                  itemBuilder: (context, index) {
                    // 최신 메시지가 아래로 오도록 reverse
                    final message = viewModel.messages.reversed.toList()[index];
                    final isMe = message.fromUid == currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(
                                message.fromUid.toString(),
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            Text(message.contents.toString()),
                            const SizedBox(height: 4),
                            Text(
                              '${message.timestamp?.toDate().hour}:${message.timestamp?.toDate().minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _MessageInput(chatId: chatId, currentUserId: currentUserId),
            ],
          );
        },
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  final String chatId;
  final String currentUserId;

  const _MessageInput({
    required this.chatId,
    required this.currentUserId,
  });

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '메시지 입력...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) => viewModel.sendMessage(_controller.text),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => viewModel.sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}
