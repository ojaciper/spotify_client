import "dart:convert";

import "package:flutter/material.dart" show debugPrint;
import "package:flutter_spotify_clone/core/constants/server_const.dart";
import "package:flutter_spotify_clone/core/failure/failure.dart";
import "package:flutter_spotify_clone/features/auth/models/user_model.dart";
import "package:fpdart/fpdart.dart";
import "package:http/http.dart" as http;

class AuthRemoteRespository {
  // regisger user
  Future<Either<AppFailure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // 192.168.1.174
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.baseUrl}auth/signup"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      debugPrint(response.statusCode.toString());
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        // handle error
        return Left(AppFailure(resBody['detail']));
      }
      return Right(UserModel.fromJson(response.body));
    } catch (e) {
      print("there is exception: ${e.toString()}");
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    // 192.168.1.174
    try {
      final response = await http.post(
        Uri.parse("${ServerConstant.baseUrl}auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      final resBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(resBody["detail"]));
      }
      return Right(UserModel.fromMap(resBody['user']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
