import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/podcast_model.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _currentTitle;
  String? _currentSubtitle;
  String? _currentUrl;
  String? _currentSpeaker;
  String? _currentShowTitle;
  String? _currentIcon;
  String? _currentEpisodeId;
  bool _isLiveStream = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _playbackSpeed = 1.0;

  Timer? _sleepTimer;
  int? _sleepTimerMinutes;
  DateTime? _sleepTimerEndTime;

  final Set<String> _savedEpisodeIds = {};

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get hasTrack => _currentUrl != null;
  String? get currentTitle => _currentTitle;
  String? get currentSubtitle => _currentSubtitle;
  String? get currentSpeaker => _currentSpeaker;
  String? get currentShowTitle => _currentShowTitle;
  String? get currentIcon => _currentIcon;
  String? get currentEpisodeId => _currentEpisodeId;
  bool get isLiveStream => _isLiveStream;
  Duration get position => _position;
  Duration get duration => _duration;
  double get playbackSpeed => _playbackSpeed;
  int? get sleepTimerMinutes => _sleepTimerMinutes;
  DateTime? get sleepTimerEndTime => _sleepTimerEndTime;
  Set<String> get savedEpisodeIds => Set.unmodifiable(_savedEpisodeIds);

  double get progressFraction {
    if (_duration.inMilliseconds <= 0) return 0.0;
    return (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
  }

  String get formattedPosition => formatDuration(_position);
  String get formattedDuration => formatDuration(_duration);

  AudioService() {
    _initAudioListeners();
    _loadSavedEpisodes();
  }

  void _initAudioListeners() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      if (_isPlaying) _isLoading = false;
      notifyListeners();
    });

    _player.onPositionChanged.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.onDurationChanged.listen((dur) {
      _duration = dur;
      notifyListeners();
    });

    _player.onPlayerComplete.listen((_) {
      _position = Duration.zero;
      _isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> _loadSavedEpisodes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('saved_episodes') ?? [];
      _savedEpisodeIds.addAll(list);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleSaveEpisode(String episodeId) async {
    if (_savedEpisodeIds.contains(episodeId)) {
      _savedEpisodeIds.remove(episodeId);
    } else {
      _savedEpisodeIds.add(episodeId);
    }
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('saved_episodes', _savedEpisodeIds.toList());
    } catch (_) {}
  }

  bool isEpisodeSaved(String episodeId) => _savedEpisodeIds.contains(episodeId);

  Future<void> playStream(
    String url, {
    required String title,
    required String subtitle,
    String? speaker,
    String? showTitle,
    String? icon,
    bool isLiveStream = true,
  }) async {
    try {
      _isLoading = true;
      _currentUrl = url;
      _currentTitle = title;
      _currentSubtitle = subtitle;
      _currentSpeaker = speaker;
      _currentShowTitle = showTitle;
      _currentIcon = icon ?? (isLiveStream ? "📻" : "🎙️");
      _currentEpisodeId = null;
      _isLiveStream = isLiveStream;
      _position = Duration.zero;
      _duration = Duration.zero;
      notifyListeners();

      await _player.stop();
      await _player.setPlaybackRate(_playbackSpeed);
      await _player.play(UrlSource(url));
    } catch (e) {
      _isLoading = false;
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> playEpisode(PodcastEpisode episode) async {
    try {
      _isLoading = true;
      _currentUrl = episode.audioUrl;
      _currentTitle = episode.title;
      _currentSubtitle = episode.speaker;
      _currentSpeaker = episode.speaker;
      _currentShowTitle = episode.showTitle;
      _currentIcon = "🎙️";
      _currentEpisodeId = episode.id;
      _isLiveStream = false;
      _position = Duration.zero;
      _duration = episode.estimatedDuration;
      notifyListeners();

      await _player.stop();
      await _player.setPlaybackRate(_playbackSpeed);
      await _player.play(UrlSource(episode.audioUrl));
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

  Future<void> seek(Duration newPosition) async {
    await _player.seek(newPosition);
    _position = newPosition;
    notifyListeners();
  }

  Future<void> skipSeconds(int seconds) async {
    final target = _position + Duration(seconds: seconds);
    final clamped = target < Duration.zero
        ? Duration.zero
        : (_duration > Duration.zero && target > _duration ? _duration : target);
    await seek(clamped);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _player.setPlaybackRate(speed);
    notifyListeners();
  }

  void setSleepTimer(int? minutes) {
    _sleepTimer?.cancel();
    _sleepTimerMinutes = minutes;
    if (minutes == null) {
      _sleepTimerEndTime = null;
      notifyListeners();
      return;
    }

    _sleepTimerEndTime = DateTime.now().add(Duration(minutes: minutes));
    notifyListeners();

    _sleepTimer = Timer(Duration(minutes: minutes), () {
      _player.pause();
      _sleepTimerMinutes = null;
      _sleepTimerEndTime = null;
      notifyListeners();
    });
  }

  Future<void> stop() async {
    await _player.stop();
    _sleepTimer?.cancel();
    _currentUrl = null;
    _currentTitle = null;
    _currentSubtitle = null;
    _currentSpeaker = null;
    _currentShowTitle = null;
    _currentEpisodeId = null;
    _position = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    _isLoading = false;
    notifyListeners();
  }

  static String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return "${d.inHours}:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
