import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/auth/start_screen.dart';
import 'screens/auth/phone_screen.dart';
import 'screens/auth/verify_screen.dart';
import 'screens/profile/profile_register_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '북클럽',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko', 'KR'),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/phone': (context) => const PhoneScreen(),
        '/verify': (context) => const VerifyScreen(),
        '/profile': (context) => const ProfileRegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
