import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/features/auth/models/user_model.dart';
import 'package:flutter_spotify_clone/features/auth/repository/auth_remote_respository.dart';
import 'package:fpdart/fpdart.dart';

class AuthViewmodel extends AsyncNotifier<UserModel?> {
  final AuthRemoteRespository _authRemoteRespository = AuthRemoteRespository();
  @override
  FutureOr<UserModel?> build() {
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRespository.signUp(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> login({required String email, required String password}) async {
    state = AsyncValue.loading();

    final res = await _authRemoteRespository.login(
      email: email,
      password: password,
    );
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }
}

final authViewModelProvider =
    AsyncNotifierProvider.autoDispose<AuthViewmodel, UserModel?>(
      AuthViewmodel.new,
    );
