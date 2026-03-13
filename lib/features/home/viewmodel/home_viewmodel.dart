import 'dart:io';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/core/provider/current_user_notifier.dart';
import 'package:flutter_spotify_clone/core/utils.dart';
import 'package:flutter_spotify_clone/features/home/models/song_model.dart';
import 'package:flutter_spotify_clone/features/home/repository/home_remote_repository.dart';
import 'package:fpdart/fpdart.dart';

final getAllSongsProvider = FutureProvider.autoDispose<List<SongModel>>((
  ref,
) async {
  final token = ref.watch(currentUserNotifierProvider)!.token;
  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .getAllSong(token: token);

  final val = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
  return val;
});

class HomeViewmodel extends AsyncNotifier<void> {
  late HomeRemoteRepository _homeRemoteRepository;
  @override
  AsyncValue? build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRemoteRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectThumbnail: selectThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}

final homeViewmodelProvider = AsyncNotifierProvider<HomeViewmodel, void>(
  HomeViewmodel.new,
);
