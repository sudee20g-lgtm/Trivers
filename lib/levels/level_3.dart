import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../widgets/physical_card_widget.dart';
import '../widgets/triverse_ui.dart';
import '../utils/game_data.dart';

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
  final Color _themeColor = Colors.blueAccent;

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
    if (_step < 4) {
      setState(() => _step++);
      FocusScope.of(context).unfocus();
    } else {
      _showFinalDialog(); 
    }
  }

  void _err() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(widget.language == 'TR' ? "ERİŞİM REDDEDİLDİ." : "ACCESS DENIED.", style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red[900],
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: widget.language == 'TR' ? "OKYANUS" : "THE OCEAN",
      levelName: "SECTOR: DEEP-SEA",
      themeColor: _themeColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: KeyedSubtree(key: ValueKey(_step), child: _buildContent()),
      ),
    );
  }

  Widget _buildContent() {
    if (_step == 1) return _s1();
    if (_step == 2) return _stageCard();
    if (_step == 3) return _s2();
    return _s3();
  }

  Widget _stageCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: PhysicalCardWidget(
        language: widget.language,
        cardNameKey: 'c3_name',
        questionKey: 'c3_q',
        optAKey: 'c3_a',
        optBKey: 'c3_b',
        correctIndex: 0,
        onCorrect: _next,
      ),
    );
  }

  Widget _s1() {
    return MissionCard(
      color: _themeColor,
      header: "DECRYPT SIGNAL",
      story: AppTexts.get('l3_s1_story', widget.language),
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black,
            // Yükseklik sınırı kaldırıldı, shrinkWrap eklendi
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
                  color: Colors.blueGrey[900],
                  child: Text(_puzzleLetters[index],
                    style: TextStyle(color: _themeColor, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _s1Ctrl,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: true, fillColor: Colors.black,
              hintText: "???", hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(borderSide: BorderSide(color: _themeColor))
            ),
          ),
          const SizedBox(height: 15),
          _btn(AppTexts.get('check', widget.language), () {
             String input = _s1Ctrl.text.trim().toUpperCase();
             if (["ONLAR UYANDI", "THEY AWOKE"].contains(input)) _next(); else _err();
          }),
        ],
      ),
    );
  }

  Widget _s2() {
    return MissionCard(
      color: Colors.indigoAccent,
      header: "MORSE TRANSMISSION",
      story: AppTexts.get('l3_s2_story', widget.language),
      footerInfo: Row(
        children: [
          const Icon(Icons.waves, color: Colors.indigoAccent, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(
            widget.language == 'TR' ? "SİNYAL KAYNAĞI: 11.000m DERİNLİK" : "SIGNAL SOURCE: DEPTH 11,000m",
            style: const TextStyle(color: Colors.indigoAccent, fontSize: 11, fontFamily: 'Courier'),
          )),
        ],
      ),
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.indigoAccent)),
            child: const Text("...-- | ..... | --...", 
              style: TextStyle(color: Colors.greenAccent, fontSize: 28, letterSpacing: 3, fontFamily: 'Courier')
            ),
          ),
          TextButton.icon(
            onPressed: _showMorseGuide,
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            label: Text(widget.language == 'TR' ? "Rehber" : "Guide", style: const TextStyle(color: Colors.white70)),
          ),
          TextField(
            controller: _s2Ctrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
            decoration: InputDecoration(filled: true, fillColor: Colors.black, border: OutlineInputBorder(borderSide: BorderSide(color: Colors.indigoAccent))),
          ),
          const SizedBox(height: 15),
          _btn(AppTexts.get('check', widget.language), () {
            if (_s2Ctrl.text.trim() == "357") _next(); else _err();
          }, color: Colors.indigoAccent),
        ],
      ),
    );
  }

  Widget _s3() {
    return MissionCard(
      color: Colors.red,
      header: "THE GATEWAY",
      story: AppTexts.get('l3_s3_story', widget.language),
      content: Column(
        children: [
          TextField(
            controller: _s3Ctrl,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              filled: true, fillColor: Colors.black,
              hintText: "PASSWORD",
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
            ),
          ),
          const SizedBox(height: 20),
          _btn(AppTexts.get('check', widget.language), () {
            if (_s3Ctrl.text.trim().toUpperCase() == "HADES") _showFinalDialog(); else _err();
          }, color: Colors.red),
        ],
      ),
    );
  }

  void _showMorseGuide() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (c) => Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: const Center(child: Text("0: -----\n1: .----\n2: ..---\n3: ...--\n4: ....-\n5: .....\n6: -....\n7: --...\n8: ---..\n9: ----.", style: TextStyle(color: Colors.white, fontSize: 18, height: 1.5)))
      )
    );
  }

  void _showFinalDialog() {
    GameData.unlockNextLevel(3);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        decoration: BoxDecoration(
            color: const Color(0xFF100000),
            border: Border(top: BorderSide(color: Colors.red, width: 3)),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 60),
            const SizedBox(height: 15),
            Text(widget.language == 'TR' ? "HADES UYANDI" : "HADES AWAKENED",
               style: AppStyles.titleStyle(Colors.red)),
            const SizedBox(height: 15),
            Text(
              widget.language == 'TR'
                ? "Şifre doğru. Kapı açıldı ama zihnine bir şeyler sızıyor. Gerçeklik kırılıyor..."
                : "Password correct. The gate opens but something invades your mind. Reality is breaking...",
              textAlign: TextAlign.center,
              style: AppStyles.loreStyle(Colors.red),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.all(15)),
                  onPressed: () {
                    Navigator.pop(context); 
                    Navigator.pop(context); 
                  },
                  child: Text(
                     widget.language == 'TR' ? "ZİHİN KONTROLÜ (BÖLÜM 4)" : "MIND CONTROL (LEVEL 4)",
                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }

  Widget _btn(String t, VoidCallback p, {Color color = Colors.blueAccent}) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color.withValues(alpha: 0.2), side: BorderSide(color: color), padding: const EdgeInsets.all(15)),
      onPressed: p, 
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))
    ),
  );
}