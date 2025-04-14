import 'package:flutter/material.dart';

class MyMeetingsScreen extends StatefulWidget {
  const MyMeetingsScreen({super.key});

  @override
  State<MyMeetingsScreen> createState() => _MyMeetingsScreenState();
}

class _MyMeetingsScreenState extends State<MyMeetingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 모임'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '참여한 모임'), Tab(text: '만든 모임')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMeetingList(isParticipated: true),
          _buildMeetingList(isParticipated: false),
        ],
      ),
    );
  }

  Widget _buildMeetingList({required bool isParticipated}) {
    // 임시 데이터
    final meetings = List.generate(
      5,
      (index) => {
        'title': '${isParticipated ? "참여" : "생성"}한 모임 ${index + 1}',
        'date': '2024.04.${11 + index}',
        'location': '서울 마포',
        'currentMembers': 3 + index,
        'maxMembers': 8,
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting['title'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(meeting['date'] as String),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(meeting['location'] as String),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '참여자 ${meeting['currentMembers']}/${meeting['maxMembers']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 채팅방 입장
                      },
                      child: const Text('채팅방 입장'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
