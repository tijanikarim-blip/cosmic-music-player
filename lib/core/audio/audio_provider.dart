import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<SongModel> _songs = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  bool _isShuffle = false;
  LoopMode _repeatMode = LoopMode.off;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  AudioPlayer get player => _player;
  List<SongModel> get songs => _songs;
  int get currentIndex => _currentIndex;
  SongModel? get currentSong => _currentIndex >= 0 && _currentIndex < _songs.length ? _songs[_currentIndex] : null;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  LoopMode get repeatMode => _repeatMode;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get hasSong => _currentIndex >= 0;

  AudioProvider() {
    _init();
  }

  void _init() {
    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });
    _player.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _onSongComplete();
      }
      notifyListeners();
    });
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('playlist_paths') ?? [];
    final songs = <SongModel>[];
    for (final path in paths) {
      if (File(path).existsSync()) {
        songs.add(SongModel(
          title: path.split('/').last.split('\\').last.replaceAll('.mp3', ''),
          artist: 'Unknown Artist',
          path: path,
        ));
      }
    }
    _songs = songs;
    notifyListeners();
  }

  Future<void> _savePlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('playlist_paths', _songs.map((s) => s.path).toList());
  }

  Future<void> addSongs(List<String> paths) async {
    for (final path in paths) {
      _songs.add(SongModel(
        title: path.split('/').last.split('\\').last.replaceAll('.mp3', ''),
        artist: 'Unknown Artist',
        path: path,
      ));
    }
    await _savePlaylist();
    notifyListeners();
  }

  Future<void> pickAndAddSongs() async {
    if (await Permission.storage.request().isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
        allowMultiple: true,
      );
      if (result != null) {
        await addSongs(result.files.map((f) => f.path!).toList());
      }
    }
  }

  Future<void> addSampleSong() async {
    final samplePath = 'assets/samples/sample.mp3';
    final file = File(samplePath);
    if (await file.exists() && !_songs.any((s) => s.path.contains('sample.mp3'))) {
      await addSongs([samplePath]);
    }
  }

  void playSong(int index) {
    if (index < 0 || index >= _songs.length) return;
    _currentIndex = index;
    _playCurrent();
  }

  Future<void> _playCurrent() async {
    if (_currentIndex < 0 || _currentIndex >= _songs.length) return;
    try {
      await _player.setFilePath(_songs[_currentIndex].path);
      await _player.play();
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  void togglePlay() {
    if (!hasSong) return;
    if (_isPlaying) {
      _player.pause();
    } else {
      if (_player.processingState == ProcessingState.idle) {
        _playCurrent();
      } else {
        _player.play();
      }
    }
  }

  void skipNext() {
    if (_songs.isEmpty) return;
    if (_isShuffle) {
      _currentIndex = (_currentIndex + 1) % _songs.length;
    } else {
      _currentIndex = (_currentIndex + 1) % _songs.length;
    }
    _playCurrent();
  }

  void skipPrevious() {
    if (_songs.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    _playCurrent();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    if (_repeatMode == LoopMode.off) {
      _repeatMode = LoopMode.all;
    } else if (_repeatMode == LoopMode.all) {
      _repeatMode = LoopMode.one;
    } else {
      _repeatMode = LoopMode.off;
    }
    _player.setLoopMode(_repeatMode);
    notifyListeners();
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  void removeSong(int index) {
    if (index < 0 || index >= _songs.length) return;
    if (index == _currentIndex && _isPlaying) {
      skipNext();
      if (_currentIndex > index) _currentIndex--;
    } else if (index < _currentIndex) {
      _currentIndex--;
    }
    _songs.removeAt(index);
    _savePlaylist();
    notifyListeners();
  }

  void _onSongComplete() {
    if (_repeatMode == LoopMode.one) {
      _playCurrent();
    } else {
      skipNext();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class SongModel {
  final String title;
  final String artist;
  final String album;
  final String path;
  final Duration duration;
  final Uint8List? albumArtBytes;

  SongModel({
    required this.title,
    required this.artist,
    required this.path,
    this.album = '',
    this.duration = Duration.zero,
    this.albumArtBytes,
  });

  String get durationText {
    if (duration == Duration.zero) return '0:00';
    final mins = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}
