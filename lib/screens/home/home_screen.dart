import 'package:flutter/material.dart';
import '../meeting/meeting_detail_screen.dart';
import '../meeting/meeting_create_screen.dart';
import '../mypage/mypage_screen.dart';
import '../chat/chat_list_screen.dart';
import '../location/location_setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // 밝은 배경
      body: SafeArea(
        child: _selectedIndex == 0
            ? Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildMeetingList()),
                ],
              )
            : _selectedIndex == 1
                ? const ChatListScreen()
                : const MyPageScreen(),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF4CD7D0), // 산뜻한 민트
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeetingCreateScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1E88E5), // 파란 포인트
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationSettingScreen(),
                ),
              );
            },
            child: Row(
              children: [
                const Text(
                  '서울 강남',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.tune, size: 24, color: Colors.black54),
            onPressed: () {
              // TODO: 필터 화면 표시
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildMeetingCard(context);
      },
    );
  }

  Widget _buildMeetingCard(BuildContext context) {
    return Card(
      color: const Color(0xFFFDFDFD),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MeetingDetailScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '책 제목이 들어갈 자리입니다',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '즉시',
                      style: TextStyle(color: Color(0xFF0288D1), fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('2024.04.20 19:00',
                      style: TextStyle(color: Colors.black54)),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('강남역 스타벅스', style: TextStyle(color: Colors.black54)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text('3/5명', style: TextStyle(color: Colors.black54)),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0288D1),
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeetingDetailScreen(),
                        ),
                      );
                    },
                    child: const Text('자세히 보기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
