import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/constants/server_const.dart';
import 'package:flutter_spotify_clone/core/failure/failure.dart';
import 'package:flutter_spotify_clone/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class HomeRemoteRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${ServerConstant.baseUrl}song/upload"),
      );
      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectThumbnail.path),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll({"x-auth-token": token});

      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSong({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${ServerConstant.baseUrl}song/song"),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
      );
      debugPrint(res.statusCode.toString());

      var resBodyMap = jsonDecode(res.body);
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;
      List<SongModel> songs = [];
      for (final song in resBodyMap) {
        songs.add(SongModel.fromMap(song));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstant.baseUrl}song/favorite'),
        headers: {"Content-Type": "application/json", "x-auth-token": token},
        body: jsonEncode({"song_id": songId}),
      );
      debugPrint(res.statusCode.toString());

      var resBody = jsonDecode(res.body);
      if (res.statusCode != 201) {
        return Left(AppFailure(resBody['detail']));
      }
      return Right(resBody['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // Future<Either<AppFailure, SongModel>> getFavSong({
  //   required String token,
  // }) async {
  //   try {
  //     final res = await http.get(
  //       Uri.parse('${ServerConstant.baseUrl}song/favorite'),
  //       headers: {"Content-Type": "application/json", "x-auth-token": token},
  //     );
  //     debugPrint(res.statusCode.toString());
  //     var resBody = jsonDecode(res.body);

  //   } catch (e) {
  //     return Left(AppFailure(e.toString()));
  //   }
  // }
}

final homeRemoteRepositoryProvider = Provider<HomeRemoteRepository>(
  (ref) => HomeRemoteRepository(),
);
