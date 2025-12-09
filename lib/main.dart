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
    _playMenuMusic();
  }

  Future<void> _playMenuMusic() async {
    try {
      await _musicPlayer.setAsset('assets/audio/background.mp3');
      await _musicPlayer.setLoopMode(LoopMode.one);
      await _musicPlayer.setVolume(0.5);
      
      if (!_isMuted) {
        // DÜZELTME BURADA: 'await' eklendi.
        // Bu sayede tarayıcı otomatik oynatmayı engellerse hata 'catch' bloğuna düşer
        // ve uygulama durdurulmaz.
        await _musicPlayer.play();
      }
    } catch (e) {
      // Web'de kullanıcı etkileşimi olmadan ses çalınamadığı için buraya düşebilir.
      // Bu normaldir, debugPrint ile hatayı günlüğe basıp geçiyoruz.
      debugPrint("Müzik başlatılamadı (Autoplay engeli olabilir): $e");
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (!_isMuted) {
      try {
        await _musicPlayer.play();
      } catch (e) {
        debugPrint("Müzik devam ettirilemedi: $e");
      }
    }
  }

  void toggleMute() {
    setState(() => _isMuted = !_isMuted);
    if (_isMuted) {
      _musicPlayer.pause();
    } else {
      // Burada da await eklemek ve hatayı yakalamak iyi bir pratiktir
      _musicPlayer.play().catchError((e) => debugPrint("Sessiz mod kapatılırken hata: $e"));
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