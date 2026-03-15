import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/provider/current_user_notifier.dart';
import 'package:flutter_spotify_clone/core/themes/theme.dart';
import 'package:flutter_spotify_clone/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter_spotify_clone/features/auth/views/screens/signup.dart';
import 'package:flutter_spotify_clone/features/home/views/screen/home_screen.dart';
import 'package:hive/hive.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getUserData();
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,

      home: currentUser == null ? const SignupScreen() : HomeScreen(),
    );
  }
}
