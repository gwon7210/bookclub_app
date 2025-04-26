import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'meeting_create_complete_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';

class MeetingCreateScreen extends StatefulWidget {
  const MeetingCreateScreen({super.key});

  @override
  State<MeetingCreateScreen> createState() => _MeetingCreateScreenState();
}

class _MeetingCreateScreenState extends State<MeetingCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bookController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxMembersController = TextEditingController(text: '5');

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isAM = true;
  int _selectedHour = 12;
  int _selectedMinute = 0;
  String _participationType = 'instant';

  @override
  void dispose() {
    _titleController.dispose();
    _bookController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('취소'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: const Text('확인'),
                  onPressed: () => Navigator.pop(context, _selectedDate ?? now),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate ?? now,
                mode: CupertinoDatePickerMode.date,
                minimumDate: now,
                maximumDate: DateTime(now.year + 1, 12, 31),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _selectedDate = newDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('취소'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: const Text('확인'),
                  onPressed: () {
                    setState(() {
                      _selectedTime = TimeOfDay(
                        hour: _selectedHour,
                        minute: _selectedMinute,
                      );
                      _isAM = _selectedHour < 12;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() => _isAM = index == 0);
                      },
                      children: const [
                        Text('오전', style: TextStyle(fontSize: 20)),
                        Text('오후', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _selectedHour = _isAM ? index + 1 : index + 13;
                          if (_selectedHour > 12) _selectedHour -= 12;
                        });
                      },
                      children: List.generate(12, (index) {
                        return Text(
                          '${index + 1}',
                          style: const TextStyle(fontSize: 20),
                        );
                      }),
                    ),
                  ),
                  const Text(':', style: TextStyle(fontSize: 20)),
                  SizedBox(
                    width: 80,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() => _selectedMinute = index * 5);
                      },
                      children: List.generate(12, (index) {
                        return Text(
                          '${(index * 5).toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 20),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '모임 만들기',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildInputField(
              controller: _titleController,
              label: '모임 제목',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '모임 제목을 입력해주세요';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _bookController,
              label: '책 제목',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '책 제목을 입력해주세요';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _descriptionController,
              label: '모임 설명',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '모임 설명을 입력해주세요';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => _selectDate(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.calendar,
                          color: Colors.black54,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedDate == null
                              ? '날짜 선택'
                              : '${_selectedDate!.year}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CupertinoButton(
                    onPressed: () => _selectTime(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          color: Colors.black54,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedTime == null
                              ? '시간 선택'
                              : '${_isAM ? '오전' : '오후'} ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _locationController,
              label: '장소',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '장소를 입력해주세요';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _maxMembersController,
              label: '최대 인원',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '최대 인원을 입력해주세요';
                }
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E5EA),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '참여 유형',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CupertinoSlidingSegmentedControl<String>(
                      groupValue: _participationType,
                      children: const {
                        'instant': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('즉시 참여'),
                        ),
                        'approval': Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('승인 필요'),
                        ),
                      },
                      onValueChanged: (value) {
                        setState(() => _participationType = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final token = context.read<UserProvider>().token;
                    final response = await ApiService.post(
                      '/meetings',
                      {
                        'title': _titleController.text,
                        'book_title': _bookController.text,
                        'date':
                            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                        'time':
                            '${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
                        'location': _locationController.text,
                        'max_participants':
                            int.parse(_maxMembersController.text),
                        'description': _descriptionController.text,
                        'participation_type': _participationType,
                      },
                      token: token,
                    );

                    if (response['success'] == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MeetingCreateCompleteScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response['message'] ?? '모임 생성에 실패했습니다'),
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
              },
              color: const Color(0xFF4CD7D0),
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                '모임 만들기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
