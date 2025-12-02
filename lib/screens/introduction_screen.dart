import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/app_texts.dart';
import 'level_selection_screen.dart';

class IntroductionScreen extends StatefulWidget {
  final Future<void> Function() onResumeMusic;
  final String language; // EKLENDİ: Artık dil verisini alıyor

  const IntroductionScreen(
      {super.key,
      required this.onResumeMusic,
      required this.language // ZORUNLU KILINDI
      });

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  late String _story;
  String _displayed = "";
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Metni seçilen dile göre AppTexts'ten çekiyoruz
    _story = AppTexts.get('intro_story', widget.language);

    // Daktilo efekti
    _timer = Timer.periodic(const Duration(milliseconds: 40), (t) {
      if (_index < _story.length) {
        setState(() => _displayed += _story[_index++]);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                child: Text(
                  _displayed,
                  style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontFamily: 'Courier',
                      height: 1.5),
                ),
              ),
            ),
            // Yazı bitince buton görünür
            if (_index == _story.length)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15)),
                onPressed: () {
                  // Bölüm seçimine geçerken dili de aktarıyoruz
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LevelSelectionScreen(
                                onResumeMusic: widget.onResumeMusic,
                                language:
                                    widget.language, // Dil bilgisini aktar
                              )));
                },
                child: Text(AppTexts.get('start_link', widget.language),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              )
          ],
        ),
      ),
    );
  }
}
