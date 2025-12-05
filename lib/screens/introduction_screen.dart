import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../utils/app_texts.dart';
import 'level_selection_screen.dart';

class IntroductionScreen extends StatefulWidget {
  final Future<void> Function() onResumeMusic;
  final String language;

  const IntroductionScreen({
    super.key,
    required this.onResumeMusic,
    required this.language,
  });

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  late String _story;
  String _displayed = "";
  int _index = 0;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Sesin üst üste binip çökmesini önlemek için basit bir kontrol bayrağı
  bool _isPlayingSound = false; 

  @override
  void initState() {
    super.initState();
    _story = AppTexts.get('intro_story', widget.language);

    _timer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      // ÖNEMLİ DÜZELTME: Widget ekranda değilse işlemi durdur (Çökme Engellendi)
      if (!mounted) {
        t.cancel();
        return;
      }

      if (_index < _story.length) {
        // Boşluk karakterlerinde ses çalma
        if (_story[_index] != ' ') {
          _playTypeSound();
        }

        setState(() {
          _displayed += _story[_index];
          _index++;
        });
      } else {
        t.cancel();
      }
    });
  }

  // Güvenli Ses Çalma Fonksiyonu
  Future<void> _playTypeSound() async {
    // Eğer zaten bir ses işleniyorsa veya widget yoksa atla
    if (_isPlayingSound || !mounted) return;

    _isPlayingSound = true;
    try {
      // stop() çağrısı bazen gecikme yaratabilir, doğrudan çalmayı dene
      // Veya kısa sesler için stop'a gerek olmayabilir.
      await _audioPlayer.stop(); 
      await _audioPlayer.play(AssetSource('audio/typewriter_key.mp3'), volume: 0.3);
    } catch (e) {
      // Ses dosyası yoksa veya hata olursa uygulamanın çökmesini engelle
      debugPrint("Ses hatası: $e");
    } finally {
      _isPlayingSound = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Text(
                  _displayed,
                  style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontFamily: 'Courier',
                      height: 1.5),
                ),
              ),
            ),
            // Hikaye bittiğinde butonu göster
            if (_index >= _story.length)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent),
                onPressed: () {
                  // Sayfa geçişinde hata olmaması için mounted kontrolü
                  if (context.mounted) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => LevelSelectionScreen(
                                  onResumeMusic: widget.onResumeMusic,
                                  language: widget.language,
                                )));
                  }
                },
                child: Text(AppTexts.get('start_link', widget.language),
                    style: const TextStyle(color: Colors.black)),
              )
          ],
        ),
      ),
    );
  }
}