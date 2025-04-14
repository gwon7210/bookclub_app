import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'my_meetings_screen.dart';
import 'settings_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지'), elevation: 0),
      body: ListView(
        children: [
          // 프로필 카드
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 30,
                child: Icon(Icons.person, size: 30),
              ),
              title: const Text('홍길동'),
              subtitle: const Text('서울 마포'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),
          ),

          // 내 모임 목록
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('내 모임'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyMeetingsScreen(),
                ),
              );
            },
          ),

          // 설정
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
