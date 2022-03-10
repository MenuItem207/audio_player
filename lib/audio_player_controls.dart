part of 'audio_player.dart';

/// widget for playing / pausing audio
class AudioPlayerControls extends StatelessWidget {
  final AudioController controller;
  final Icon playIcon;
  final Icon pauseIcon;
  const AudioPlayerControls(
      {Key? key,
      required this.controller,
      this.pauseIcon = _pauseIcon,
      this.playIcon = _playIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isPlayingNotifier,
      builder: (context, isPlaying, child) => BounceAnimator(
        onPressed: () => isPlaying ? controller.pause() : controller.play(),
        child: isPlaying ? pauseIcon : playIcon,
      ),
    );
  }
}

const Icon _pauseIcon = Icon(
  Icons.pause_rounded,
  size: 35,
);

const Icon _playIcon = Icon(
  Icons.play_arrow_rounded,
  size: 35,
);
