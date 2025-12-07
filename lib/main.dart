import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'screens/main_menu_screen.dart'; // Dosya yapına göre bu yolun doğruluğundan emin ol (örn: lib/screens/...)
import 'utils/game_data.dart'; // GameData importu

void main() async {
  // Flutter motorunun ve async işlemlerin hazır olduğundan emin ol
  WidgetsFlutterBinding.ensureInitialized();
  
  // Kayıtlı oyun verilerini yükle (Shared Preferences'dan okur)
  // Bu işlem bitmeden uygulama ekranını çizmeye başlamaz, böylece doğru seviye ile açılır.
  await GameData.loadProgress();

  runApp(const TriVerseApp());
}

class TriVerseApp extends StatefulWidget {
  const TriVerseApp({super.key});

  @override
  State<TriVerseApp> createState() => _TriVerseAppState();
}

class _TriVerseAppState extends State<TriVerseApp> {
  final AudioPlayer _musicPlayer = AudioPlayer(); // Menü Müziği Oynatıcısı
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
      // Müzik dosyasının 'pubspec.yaml' dosyasında assets altına ekli olduğundan emin ol.
      // Örn: assets/audio/background.mp3
      await _musicPlayer.setAsset('assets/audio/background.mp3');
      await _musicPlayer.setLoopMode(LoopMode.one); // Müziği döngüye al
      await _musicPlayer.setVolume(0.5); // Ses seviyesi %50
      
      if (!_isMuted) {
        _musicPlayer.play();
      }
    } catch (e) {
      debugPrint("Müzik yükleme hatası: $e");
    }
  }

  // Oyuna girince (Play'e basınca) müziği durdur
  Future<void> stopMusic() async {
    await _musicPlayer.pause();
  }

  // Menüye geri dönünce müziği tekrar başlat
  Future<void> resumeMusic() async {
    if (!_isMuted) await _musicPlayer.play();
  }

  // Sesi aç/kapa (Mute butonu için)
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
      debugShowCheckedModeBanner: false, // Sağ üstteki "Debug" bandını kaldırır
      theme: ThemeData(
        brightness: Brightness.dark, // Genel karanlık tema
        fontFamily: 'Courier', // Terminal/Hacker tarzı font
      ),
      // Ana Menü Ekranını Başlat
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