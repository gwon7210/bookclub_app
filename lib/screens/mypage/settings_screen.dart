import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          // 알림 설정
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('알림 설정'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          const Divider(),

          // 계정 설정
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('비밀번호 변경'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: 비밀번호 변경 화면으로 이동
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('전화번호 변경'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: 전화번호 변경 화면으로 이동
            },
          ),
          const Divider(),

          // 로그아웃
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('정말 로그아웃 하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text('로그아웃'),
                    ),
                  ],
                ),
              );
            },
          ),

          // 회원 탈퇴
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('회원 탈퇴', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: 회원 탈퇴 확인 다이얼로그
            },
          ),
          const Divider(),

          // 앱 정보
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '앱 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('버전 1.0.0'),
                SizedBox(height: 4),
                Text('고객센터: 1234-5678'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
