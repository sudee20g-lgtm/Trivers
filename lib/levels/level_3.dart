import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../widgets/physical_card_widget.dart';

class Level3 extends StatefulWidget {
  final String language;
  const Level3({super.key, required this.language});

  @override
  State<Level3> createState() => _Level3State();
}

class _Level3State extends State<Level3> {
  int _step = 1;
  final TextEditingController _s1Ctrl = TextEditingController();
  final TextEditingController _s2Ctrl = TextEditingController();
  final TextEditingController _s3Ctrl = TextEditingController();

  final List<String> _puzzleLetters = [
    'U', 'K', 'X', 'Z', 'Q', 'W', 'E', 'R',
    'A', 'Y', 'T', 'Y', 'U', 'I', 'O', 'P',
    'Z', 'X', 'A', 'S', 'D', 'F', 'G', 'H',
    'L', 'K', 'J', 'N', 'B', 'V', 'C', 'M',
    'Q', 'W', 'E', 'R', 'D', 'T', 'Y', 'U',
    'O', 'P', 'Ğ', 'Ü', 'S', 'I', 'L', 'K',
    'Z', 'O', 'R', 'L', 'U', 'K', 'X', 'J',
    'V', 'B', 'O', 'N', 'L', 'A', 'R', 'M',
  ];

  void _next() {
    // 1: Şifre, 2: Kart, 3: Mors, 4: Gardiyan
    if (_step < 4) {
      setState(() => _step++);
      FocusScope.of(context).unfocus();
    } else {
      // Bitiş
    }
  }

  void _err() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.language == 'tr' ? "ERİŞİM REDDEDİLDİ." : "ACCESS DENIED.",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[900],
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("LEVEL 3 - ${widget.language == 'tr' ? 'OKYANUS' : 'OCEAN'}",
          style: const TextStyle(color: Colors.white, fontFamily: 'Courier', letterSpacing: 2)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _step / 4,
                backgroundColor: Colors.grey[900],
                valueColor: AlwaysStoppedAnimation<Color>(_step == 4 ? Colors.red : Colors.blueAccent),
                minHeight: 5,
              ),
              const SizedBox(height: 40),
              if (_step == 1) _s1(),
              if (_step == 2) _stageCard(), // YENİ
              if (_step == 3) _s2(),
              if (_step == 4) _s3(),
              if (_step >= 5) _endScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stageCard() {
    return PhysicalCardWidget(
      language: widget.language,
      cardNameKey: 'c3_name',
      questionKey: 'c3_q',
      optAKey: 'c3_a', // Doğru: Kas eti (Ciğer zehirli)
      optBKey: 'c3_b',
      correctIndex: 0,
      onCorrect: _next,
    );
  }

  // --- Orijinal _s1, _s2, _s3 kodları ---
  Widget _s1() {
    return Column(
      children: [
        Text(AppTexts.get('l3_s1_story', widget.language), style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(5),
          color: Colors.black,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: _puzzleLetters.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.grey[900],
                child: Text(_puzzleLetters[index],
                  style: TextStyle(color: Colors.greenAccent.withAlpha(230), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 25),
        TextField(
          controller: _s1Ctrl,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(filled: true, fillColor: Colors.white12),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            String input = _s1Ctrl.text.trim().toUpperCase();
            if (["ONLAR UYANDI", "THEY AWOKE"].contains(input)) {
              _next();
            } else {
              _err();
            }
          },
          child: Text(AppTexts.get('check', widget.language)),
        ),
      ],
    );
  }

  Widget _s2() {
    return Column(
      children: [
        Text(AppTexts.get('l3_s2_story', widget.language), style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 25),
        const Text("...-- | ..... | --...", style: TextStyle(color: Colors.white, fontSize: 24)),
        const SizedBox(height: 25),
        TextField(
          controller: _s2Ctrl,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(filled: true, fillColor: Colors.white12),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_s2Ctrl.text.trim() == "357") {
              _next();
            } else {
              _err();
            }
          },
          child: Text(AppTexts.get('check', widget.language)),
        ),
      ],
    );
  }

  Widget _s3() {
    return Column(
      children: [
        Text(AppTexts.get('l3_s3_story', widget.language), style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        TextField(
          controller: _s3Ctrl,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(filled: true, fillColor: Colors.white12),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_s3Ctrl.text.trim().toUpperCase() == "HADES") {
              _step++; // Ekranda endScreen görünmesi için
              setState(() {});
            } else {
              _err();
            }
          },
          child: Text(AppTexts.get('check', widget.language)),
        ),
      ],
    );
  }

  Widget _endScreen() {
    return Column(children: [
      const Icon(Icons.waves, color: Colors.blueAccent, size: 80),
      const SizedBox(height: 20),
      const Text("OKYANUS GEÇİLDİ", style: TextStyle(color: Colors.white, fontSize: 24)),
      const SizedBox(height: 30),
      ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("MENÜYE DÖN"))
    ]);
  }
}