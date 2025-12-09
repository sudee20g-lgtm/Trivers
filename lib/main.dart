import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'screens/main_menu_screen.dart';
import 'utils/game_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameData.loadProgress();
  runApp(const TriVerseApp());
}

class TriVerseApp extends StatefulWidget {
  const TriVerseApp({super.key});

  @override
  State<TriVerseApp> createState() => _TriVerseAppState();
}

class _TriVerseAppState extends State<TriVerseApp> {
  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isMuted = false;
  String _language = 'TR';

  @override
  void initState() {
    super.initState();
    // DÜZELTME: Burada sadece müziği hazırlıyoruz, OYNATMIYORUZ.
    // Oynatma işini kullanıcı ekrana dokununca yapacağız.
    _initializeMusic();
  }

  // Müziği sadece hafızaya yükler ve ayarlarını yapar
  Future<void> _initializeMusic() async {
    try {
      await _musicPlayer.setAsset('assets/audio/background.mp3');
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _musicPlayer.setVolume(0.5);
      debugPrint("Müzik başarıyla yüklendi ve hazır.");
    } catch (e) {
      debugPrint("Müzik yükleme hatası: $e");
    }
  }

  // Müziği durdurur
  Future<void> stopMusic() async {
    await _musicPlayer.pause();
  }

  // Müziği başlatır (Bunu menüden tetikleyeceğiz)
  Future<void> resumeMusic() async {
    if (!_isMuted) {
      try {
        // Eğer zaten çalıyorsa tekrar başlatma
        if (!_musicPlayer.playing) {
          await _musicPlayer.play();
        }
      } catch (e) {
        debugPrint("Müzik çalma hatası: $e");
      }
    }
  }

  void toggleMute() {
    setState(() => _isMuted = !_isMuted);
    if (_isMuted) {
      _musicPlayer.pause();
    } else {
      _musicPlayer.play();
    }
  }

  void changeLanguage(String lang) {
    setState(() {
      _language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Courier',
      ),
      home: MainMenuScreen(
        isMuted: _isMuted,
        language: _language,
        onChangeLanguage: changeLanguage,
        onToggleMute: toggleMute,
        onStopMusic: stopMusic,
        onResumeMusic: resumeMusic,
      ),
    );
  }
}