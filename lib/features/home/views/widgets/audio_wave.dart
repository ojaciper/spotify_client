import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({required this.path, super.key});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();
  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioFileWaveforms(
      size: const Size(double.infinity, 100),
      playerController: playerController,
    );
  }
}
