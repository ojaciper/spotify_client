import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/features/home/models/song_model.dart';
import 'package:hive/hive.dart';

class HomeLocalRepository {
  final Box box = Hive.box();

  void uploadLocalSong(SongModel song) async {
    debugPrint(song.toString());
    box.put(song.id, song.toJson());
  }

  List<SongModel> loadSong() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key)));
    }
    return songs;
  }
}

final homeLocalRepositoryProvider = Provider<HomeLocalRepository>(
  (ref) => HomeLocalRepository(),
);
