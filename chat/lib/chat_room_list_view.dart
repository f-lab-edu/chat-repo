import 'package:chat/auth/presentation/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_room_list_view_model.dart';
import 'chat_view.dart';

class ChatRoomListView extends StatelessWidget {
  final String currentUserId;
  const ChatRoomListView({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채팅방 목록')),
      drawer: ProfileDrawer(
        uid: currentUserId,
        // profileName, profileImageUrl은 필요에 따라 전달
      ),
      body: Consumer<ChatRoomListViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.chatRooms.isEmpty) {
            return const Center(child: Text('참여 중인 채팅방이 없습니다.'));
          }
          return ListView.builder(
            itemCount: viewModel.chatRooms.length,
            itemBuilder: (context, index) {
              final room = viewModel.chatRooms[index];
              return ListTile(
                title: Text(room.chatId!),
                subtitle: Text(
                  room.lastQueryTime != null
                      ? '최근 접속: ${room.lastQueryTime!.toDate()}'
                      : '',
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatView(
                      chatId: room.chatId!,
                      currentUserId: currentUserId,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
