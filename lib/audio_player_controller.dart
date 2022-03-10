part of 'audio_player.dart';

/// this controller handles the state of the audio player
class AudioController {
  /// the audio file's data
  final Uint8List byteData;

  /// the audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioController({required this.byteData}) {
    _audioPlayer.setAudioSource(_BufferAudioSource(byteData));

    // setup stream to update isPlayingNotifier
    _isPlayingSubscription = _audioPlayer.playingStream.listen((event) {
      isPlayingNotifier.value = event;
    });
  }

  /// stream subscripting for playingStream
  late StreamSubscription _isPlayingSubscription;

  /// the current state of the audio player
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);

  /// whether or not the audio is playing
  bool get isPlaying => isPlayingNotifier.value;

  /// the duration of the current audio
  Duration? get duration => _audioPlayer.duration;

  /// starts playing the audio
  void play() => _audioPlayer.play();

  /// pauses the audio
  void pause() => _audioPlayer.pause();

  /// stops the audio
  void stop() async => await _audioPlayer.stop();

  /// releases the audio player
  void dispose() {
    _isPlayingSubscription.cancel();
    _audioPlayer.dispose();
  }
}

/// provides a way to play audio files (byteData)
class _BufferAudioSource extends StreamAudioSource {
  Uint8List _buffer;

  _BufferAudioSource(this._buffer);

  @override
  Future<StreamAudioResponse> request([
    int? start,
    int? end,
  ]) {
    start = start ?? 0;
    end = end ?? _buffer.length;

    return Future.value(
      StreamAudioResponse(
        sourceLength: _buffer.length,
        contentLength: end - start,
        offset: start,
        contentType: 'audio/mpeg',
        stream:
            Stream.value(List<int>.from(_buffer.skip(start).take(end - start))),
      ),
    );
  }
}
