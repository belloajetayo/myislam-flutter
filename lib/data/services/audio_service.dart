import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _currentTitle;
  String? _currentSubtitle;
  String? _currentUrl;

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get hasTrack => _currentUrl != null;
  String? get currentTitle => _currentTitle;
  String? get currentSubtitle => _currentSubtitle;

  AudioService() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> playStream(String url, {required String title, required String subtitle}) async {
    try {
      _isLoading = true;
      _currentUrl = url;
      _currentTitle = title;
      _currentSubtitle = subtitle;
      notifyListeners();

      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else if (_currentUrl != null) {
      await _player.resume();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentUrl = null;
    _currentTitle = null;
    _currentSubtitle = null;
    _isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
