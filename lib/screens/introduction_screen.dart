import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/app_texts.dart';
import '../utils/game_data.dart';
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

  @override
  void initState() {
    super.initState();
    _story = AppTexts.get('intro_story', widget.language);

    _timer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (_index < _story.length) {
        setState(() {
          _displayed += _story[_index];
          _index++;
        });
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
                onPressed: () async {
                  // Kullanıcı introyu bitirdi, kaydediyoruz.
                  await GameData.markIntroAsSeen();

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