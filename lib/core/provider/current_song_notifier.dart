import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/features/home/models/song_model.dart';
import 'package:just_audio/just_audio.dart';

class CurrentSongNotifier extends Notifier<SongModel?> {
  AudioPlayer? audioPlayer;
  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(Uri.parse(song.songUrl));
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.play();
    state = song;
  }
}

final currentSongNotifierProvider =
    NotifierProvider<CurrentSongNotifier, SongModel?>(CurrentSongNotifier.new);
