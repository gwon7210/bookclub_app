import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
      ),
      body: ListView.builder(
        itemCount: 5, // 임시 데이터
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.group),
            ),
            title: Text('북클럽 모임 ${index + 1}'),
            subtitle: const Text('마지막 메시지 내용...'),
            trailing: const Text('오후 2:30'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatRoomScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
