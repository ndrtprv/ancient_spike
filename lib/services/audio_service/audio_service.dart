import 'package:audioplayers/audioplayers.dart';

// Centralized audio manager
// Using singleton pattern
class AudioService {
  AudioService._privateConstructor();
  static final AudioService _instance = AudioService._privateConstructor();
  factory AudioService() {
    return _instance;
  }

  // Players
  // Music background player
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  // SFX player
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // Property used in all screens of app
  bool _isMuted = false;
  // Background track path
  String? _currentTrackPath;

  // Initialization of track players
  void init(bool isMuted) {
    _isMuted = isMuted;

    // Setting volume of music depending on the mute state
    _backgroundPlayer.setVolume(_isMuted ? 0 : 1);
    _sfxPlayer.setVolume(_isMuted ? 0 : 1);

    // Set the background track player
    _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
  }

  // Background music management
  // Plays in the menu or during level selection
  Future<void> playMenuMusic() async {
    const path = 'audio/menu.mp3';
    // If the music is playing, we don't reload
    if (_currentTrackPath == path) return; 

    // Otherwise we start background player
    await _backgroundPlayer.stop();
    await _backgroundPlayer.play(AssetSource(path));
    _currentTrackPath = path;
  }

  // Plays during the game
  Future<void> playGameMusic() async {
    const path = 'audio/background.mp3';
    // If the music is playing, we don't reload
    if (_currentTrackPath == path) return;

    // Otherwise we start background player
    await _backgroundPlayer.stop();
    await _backgroundPlayer.play(AssetSource(path));
    _currentTrackPath = path;
  }

  // SFX player
  // It will be triggered when the character
  // hit a spike
  Future<void> playSfx(String fileName) async {
    // If it's muted
    if (_isMuted) return;
    // Use `play` from 'assets' for SFX
    await _sfxPlayer.play(AssetSource('audio/$fileName'));
  }

  // Volume regulation
  // It'll be triggered when the user push mute button
  void setMute(bool mute) {
    _isMuted = mute;
    _backgroundPlayer.setVolume(_isMuted ? 0 : 1);
    _sfxPlayer.setVolume(_isMuted ? 0 : 1);
  }

  // Resource disposal
  void dispose() {
    _backgroundPlayer.dispose();
    _sfxPlayer.dispose();
  }
}