import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/provider/current_user_notifier.dart';
import 'package:flutter_spotify_clone/features/auth/models/user_model.dart';
import 'package:flutter_spotify_clone/features/auth/repository/auth_local_repository.dart';
import 'package:flutter_spotify_clone/features/auth/repository/auth_remote_respository.dart';
import 'package:fpdart/fpdart.dart';

class AuthViewmodel extends AsyncNotifier<UserModel?> {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  FutureOr<UserModel?> build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authlocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signUp(
      name: name,
      email: email,
      password: password,
    );
    if (!ref.mounted) return;
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    // debugPrint(val.toString());
  }

  Future<void> login({required String email, required String password}) async {
    state = AsyncValue.loading();

    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    if (!ref.mounted) return;
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _loginSuccess(r),
    };
  }

  AsyncValue<UserModel?> _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getUserData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    debugPrint(token);

    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUser(token);
      debugPrint(res.toString());
      // if (!ref.mounted) return null;
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        Right(value: final r) => state = AsyncValue.data(r),
      };
      return val.value;
    }
    return null;
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewmodel, UserModel?>(
  AuthViewmodel.new,
);
