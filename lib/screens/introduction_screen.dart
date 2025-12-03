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

  @override
  void initState() {
    super.initState();
    _story = AppTexts.get('intro_story', widget.language);

    // HATA DÜZELTİLDİ: (t) async kaldırıldı
    _timer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (_index < _story.length) {
        
        // Ses çalma işlemi asenkron bekletilmeden (await olmadan) yapılıyor
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

  // Sesi çalmak için yardımcı, beklemesiz fonksiyon
  void _playTypeSound() {
    _audioPlayer.stop().then((_) {
      _audioPlayer.play(AssetSource('audio/typewriter_key.mp3'), volume: 0.3);
    });
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LevelSelectionScreen(
                                onResumeMusic: widget.onResumeMusic,
                                language: widget.language,
                              )));
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