import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'meeting_join_screen.dart';
import 'meeting_join_complete_screen.dart';

class MeetingDetailScreen extends StatefulWidget {
  final String meetingId;

  const MeetingDetailScreen({
    super.key,
    required this.meetingId,
  });

  @override
  State<MeetingDetailScreen> createState() => _MeetingDetailScreenState();
}

class _MeetingDetailScreenState extends State<MeetingDetailScreen> {
  Map<String, dynamic>? _meeting;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMeetingDetail();
  }

  Future<void> _fetchMeetingDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = context.read<UserProvider>().token;
      final response = await ApiService.get(
        '/meetings/${widget.meetingId}',
        token: token,
      );

      if (response['success'] == true) {
        setState(() {
          _meeting = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['message'] ?? '모임 정보를 불러오는데 실패했습니다';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = '서버 연결에 실패했습니다';
        _isLoading = false;
      });
      print('Error fetching meeting detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '모임 상세',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CD7D0)),
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchMeetingDetail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CD7D0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchMeetingDetail,
                  color: const Color(0xFF4CD7D0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(),
                        const SizedBox(height: 24),
                        _buildMeetingInfo(),
                        const SizedBox(height: 24),
                        _buildDescription(),
                        const SizedBox(height: 24),
                        _buildHostInfo(),
                        const SizedBox(height: 24),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _meeting!['book_title'] ?? '책 제목 없음',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _meeting!['title'] ?? '모임 제목 없음',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _meeting!['status'] == 'active'
                    ? const Color(0xFFE3F2FD)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: _meeting!['status'] == 'active'
                        ? Colors.blue[400]
                        : Colors.grey[400],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _meeting!['status'] == 'active' ? '모집중' : '마감',
                    style: TextStyle(
                      color: _meeting!['status'] == 'active'
                          ? Colors.blue[700]
                          : Colors.grey[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_meeting!['current_participants'] ?? 0}/${_meeting!['max_participants']}명',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeetingInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '모임 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: '날짜',
            value: '${_meeting!['date']} ${_meeting!['time']}',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.location_on,
            label: '장소',
            value: _meeting!['location'] ?? '장소 미정',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.group,
            label: '참여 방식',
            value: _meeting!['participation_type'] == 'instant'
                ? '즉시 참여'
                : '승인 필요',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF4CD7D0),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '모임 설명',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _meeting!['description'] ?? '설명 없음',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '모임장 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _meeting?['host']?['nickname'] ?? '이름 없음',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _meeting?['host']?['location'] ?? '지역 정보 없음',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final bool isParticipated = _meeting?['is_participated'] ?? false;
    final bool isApprovalRequired =
        _meeting?['participation_type'] == 'approval';

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isParticipated
                ? null
                : () async {
                    if (isApprovalRequired) {
                      // 승인 필요 모임의 경우 메시지 입력 화면으로 이동
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeetingJoinScreen(),
                        ),
                      );

                      if (result != null && result is String) {
                        // 메시지가 입력된 경우 API 호출
                        await _joinMeeting(message: result);
                      }
                    } else {
                      // 즉시 참여 모임의 경우 바로 API 호출
                      await _joinMeeting();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CD7D0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isParticipated ? '참여 완료' : '모임 참여',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: 채팅방 입장 로직 구현
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Color(0xFF4CD7D0)),
            ),
            child: const Text(
              '채팅방 입장',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CD7D0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _joinMeeting({String? message}) async {
    try {
      final token = context.read<UserProvider>().token;
      final response = await ApiService.post(
        '/meetings/${widget.meetingId}/join',
        message != null ? {'message': message} : {},
        token: token,
      );

      if (response['success'] == true) {
        // 참여 성공 시 모임 정보 다시 불러오기
        await _fetchMeetingDetail();

        // 참여 완료 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MeetingJoinCompleteScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? '모임 참여에 실패했습니다'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('서버 연결에 실패했습니다'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
