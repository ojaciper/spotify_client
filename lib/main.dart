import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/themes/theme.dart';
import 'package:flutter_spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_spotify_clone/features/auth/views/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  final userData = await container
      .read(authViewModelProvider.notifier)
      .getUserData();
  debugPrint("user model: ${userData.toString()}");
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
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
