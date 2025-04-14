import 'package:flutter/material.dart';
import 'meeting_create_complete_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MeetingCreateScreen extends StatefulWidget {
  const MeetingCreateScreen({super.key});

  @override
  State<MeetingCreateScreen> createState() => _MeetingCreateScreenState();
}

class _MeetingCreateScreenState extends State<MeetingCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bookTitleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _maxParticipants = 5;
  String _joinType = '즉시';
  bool _isAM = true;
  int _selectedHour = 12;
  int _selectedMinute = 0;

  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _bookTitleController.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null &&
        _locationController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ko', 'KR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateTime() {
    final hour = _isAM ? _selectedHour : _selectedHour + 12;
    setState(() {
      _selectedTime = TimeOfDay(hour: hour, minute: _selectedMinute);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bookTitleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('모임 만들기')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '모임 이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '모임 이름을 입력해주세요';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bookTitleController,
                decoration: const InputDecoration(
                  labelText: '책 제목',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '책 제목을 입력해주세요';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectDate(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? '날짜 선택'
                            : '${_selectedDate!.year}.${_selectedDate!.month}.${_selectedDate!.day}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: 300,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text(
                                  '시간 선택',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // AM/PM 선택
                                      SizedBox(
                                        width: 80,
                                        child: ListWheelScrollView(
                                          itemExtent: 50,
                                          diameterRatio: 1.5,
                                          perspective: 0.01,
                                          children: const [
                                            Text('오전',
                                                style: TextStyle(fontSize: 20)),
                                            Text('오후',
                                                style: TextStyle(fontSize: 20)),
                                          ],
                                          onSelectedItemChanged: (index) {
                                            setState(() {
                                              _isAM = index == 0;
                                              _updateTime();
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // 시간 선택
                                      SizedBox(
                                        width: 80,
                                        child: ListWheelScrollView(
                                          itemExtent: 50,
                                          diameterRatio: 1.5,
                                          perspective: 0.01,
                                          children: List.generate(
                                            12,
                                            (index) => Text(
                                              '${index + 1}',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          onSelectedItemChanged: (index) {
                                            setState(() {
                                              _selectedHour = index + 1;
                                              _updateTime();
                                            });
                                          },
                                        ),
                                      ),
                                      const Text(':',
                                          style: TextStyle(fontSize: 20)),
                                      // 분 선택
                                      SizedBox(
                                        width: 80,
                                        child: ListWheelScrollView(
                                          itemExtent: 50,
                                          diameterRatio: 1.5,
                                          perspective: 0.01,
                                          children: List.generate(
                                            60,
                                            (index) => Text(
                                              index.toString().padLeft(2, '0'),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          onSelectedItemChanged: (index) {
                                            setState(() {
                                              _selectedMinute = index;
                                              _updateTime();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _selectedTime == null
                            ? '시간 선택'
                            : '${_isAM ? '오전' : '오후'} ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: '장소',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '장소를 입력해주세요';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16),
              const Text(
                '최대 인원',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_maxParticipants > 2) {
                        setState(() {
                          _maxParticipants--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$_maxParticipants명',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_maxParticipants < 10) {
                        setState(() {
                          _maxParticipants++;
                        });
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '참여 방식',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('즉시'),
                      value: '즉시',
                      groupValue: _joinType,
                      onChanged: (value) {
                        setState(() {
                          _joinType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('승인 필요'),
                      value: '승인',
                      groupValue: _joinType,
                      onChanged: (value) {
                        setState(() {
                          _joinType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: '소개글',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '소개글을 입력해주세요';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MeetingCreateCompleteScreen(),
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '모임 만들기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
