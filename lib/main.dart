import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'screens/main_menu_screen.dart'; // Menü ekranını import et

void main() {
  runApp(const TriVerseApp());
}

class TriVerseApp extends StatefulWidget {
  const TriVerseApp({super.key});

  @override
  State<TriVerseApp> createState() => _TriVerseAppState();
}

class _TriVerseAppState extends State<TriVerseApp> {
  final AudioPlayer _musicPlayer = AudioPlayer(); // Menü Müziği
  bool _isMuted = false;
  String _language = 'TR'; // Varsayılan Dil

  @override
  void initState() {
    super.initState();
    _playMenuMusic();
  }

  // Menü Müziğini Başlat
  Future<void> _playMenuMusic() async {
    try {
      if (await _musicPlayer.setAsset('assets/audio/background.mp3') != null) {
        await _musicPlayer.setLoopMode(LoopMode.one);
        await _musicPlayer.setVolume(0.5);
        if (!_isMuted) _musicPlayer.play();
      }
    } catch (e) {
      debugPrint("Müzik hatası: $e");
    }
  }

  // Oyuna girince müziği durdur
  Future<void> stopMusic() async {
    await _musicPlayer.pause();
  }

  // Menüye dönünce müziği aç
  Future<void> resumeMusic() async {
    if (!_isMuted) await _musicPlayer.play();
  }

  void toggleMute() {
    setState(() => _isMuted = !_isMuted);
    if (_isMuted) {
      _musicPlayer.pause();
    } else {
      _musicPlayer.play();
    }
  }

  // Dil Değiştirme Fonksiyonu
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
      // HATANIN ÇÖZÜLDÜĞÜ YER: Parametreleri buraya ekledik
      home: MainMenuScreen(
        isMuted: _isMuted,
        language: _language, // EKLENDİ
        onChangeLanguage: changeLanguage, // EKLENDİ
        onToggleMute: toggleMute,
        onStopMusic: stopMusic,
        onResumeMusic: resumeMusic,
      ),
    );
  }
}
