import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/themes/theme.dart';
import 'package:flutter_spotify_clone/features/auth/views/screens/login_screen.dart';
import 'package:flutter_spotify_clone/features/auth/views/screens/signup.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: const SignupScreen(),
    );
  }
}
