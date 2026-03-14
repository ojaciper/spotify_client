import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spotify_clone/features/home/models/song_model.dart';
import 'package:just_audio/just_audio.dart';

class CurrentSongNotifier extends Notifier<SongModel?> {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    await audioPlayer?.dispose();
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(Uri.parse(song.songUrl));
    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        final currentSong = this.state;
        this.state = null;
        this.state = currentSong;
      }
    });
    audioPlayer!.play();
    isPlaying = true;
    state = song;
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
      isPlaying = false;
    } else {
      audioPlayer?.play();
      isPlaying = true;
    }
    final currentSong = state;
    state = null;
    state = currentSong;
  }

  void seek(double value) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (value * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}

final currentSongNotifierProvider =
    NotifierProvider<CurrentSongNotifier, SongModel?>(CurrentSongNotifier.new);
