import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;

class LocationScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const LocationScreen({
    super.key,
    required this.userData,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = true;
  String _statusMessage = '위치 정보를 가져오는 중입니다...';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      // 위치 권한 요청
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          developer.log('위치 권한이 거부되었습니다.', name: 'LocationScreen');
          _navigateToHome();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        developer.log('위치 권한이 영구적으로 거부되었습니다.', name: 'LocationScreen');
        _navigateToHome();
        return;
      }

      // 위치 정보 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      developer.log(
        '위치 정보 수집 성공: 위도 ${position.latitude}, 경도 ${position.longitude}',
        name: 'LocationScreen',
      );

      if (mounted) {
        final userData = {
          ...widget.userData,
          'location': '${position.latitude}, ${position.longitude}',
        };
        Navigator.pushNamed(
          context,
          '/profile',
          arguments: userData,
        );
      }
    } catch (e) {
      developer.log(
        '위치 정보 수집 실패: ${e.toString()}',
        name: 'LocationScreen',
        error: e,
      );
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
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
          '위치 기반 서비스',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CD7D0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '위치 정보를 가져오고 있습니다',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CD7D0),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CD7D0)),
              ),
              const SizedBox(height: 24),
              const Text(
                '잠시만 기다려주세요...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
