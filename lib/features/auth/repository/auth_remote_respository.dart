import "dart:convert";

import "package:flutter/material.dart" show debugPrint;
import "package:flutter_spotify_clone/core/themes/failure/failure.dart";
import "package:flutter_spotify_clone/features/auth/models/user_model.dart";
import "package:fpdart/fpdart.dart";
import "package:http/http.dart" as http;

class AuthRemoteRespository {
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // 192.168.1.174
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.174:8000/auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        // handle error
        return Left(AppFailure(resBody['detail']));
      }

      return Right(UserModel(email: email, name: name, id: resBody['id']));
    } catch (e) {
      throw Left(AppFailure(e.toString()));
    }
  }

  Future<Either<String, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    // 192.168.1.174
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.174:8000/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode != 200) {
        return Left(response.body);
      }
      final res = jsonDecode(response.body) as Map<String, dynamic>;
      return Right(res);
    } catch (e) {
      throw Left(e.toString());
    }
  }
}
