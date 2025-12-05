import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../widgets/physical_card_widget.dart';
import '../widgets/triverse_ui.dart';

class Level4 extends StatefulWidget {
  final String language;
  const Level4({super.key, required this.language});
  @override
  State<Level4> createState() => _Level4State();
}

class _Level4State extends State<Level4> {
  int _stage = 1;
  String? _gridSel;
  final Color _themeColor = Colors.purpleAccent;

  void _next() {
    if (_stage < 4) {
      setState(() => _stage++);
    } else {
      _win();
    }
  }

  void _win() {
    GameData.unlockNextLevel(4);
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (c) => _popup());
  }

  Widget _popup() => Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFF100010),
          border: Border(top: BorderSide(color: _themeColor, width: 3)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.psychology, color: _themeColor, size: 60),
        const SizedBox(height: 10),
        Text(
           widget.language == 'TR' ? "ZİHİN KONTROLÜ SAĞLANDI" : "MIND CONTROL RESTORED",
           style: AppStyles.titleStyle(_themeColor)),
        const SizedBox(height: 15),
        Text(
            widget.language == 'TR'
                ? "Renkler normale döndü. O yaratıkla iletişim kurdun. Artık gerçeklik senin elinde. Triverse'in sırrını çözdün."
                : "Colors normalized. You communicated with the entity. Reality is yours now. You solved Triverse.",
            textAlign: TextAlign.center,
            style: AppStyles.loreStyle(_themeColor)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _themeColor, padding: const EdgeInsets.all(15)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("BÖLÜMÜ TAMAMLA",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        )
      ]));

  void _err() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppTexts.get('retry', widget.language), style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.purple.shade900, behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: widget.language == 'TR' ? "ZİHİN" : "THE MIND",
      levelName: "SECTOR: UNKNOWN",
      themeColor: _themeColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: KeyedSubtree(key: ValueKey(_stage), child: _content()),
      ),
    );
  }

  Widget _content() {
    if (_stage == 1) return _s1();
    if (_stage == 2) return _stageCard();
    if (_stage == 3) return _s2();
    return _s3();
  }

  Widget _stageCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: PhysicalCardWidget(
        language: widget.language,
        cardNameKey: 'c4_name',
        questionKey: 'c4_q',
        optAKey: 'c4_a',
        optBKey: 'c4_b',
        correctIndex: 1,
        onCorrect: _next,
      ),
    );
  }

  Widget _s1() {
    return MissionCard(
      color: _themeColor,
      header: "NEURAL GRID MAPPING",
      story: AppTexts.get('l4_s1_story', widget.language),
      content: Column(
        children: [
          Wrap(spacing: 15, runSpacing: 15, alignment: WrapAlignment.center, children: [
            _gBtn("A1", false),
            _gBtn("C7", false),
            _gBtn("F4", true),
            _gBtn("D6", false)
          ]),
          const SizedBox(height: 30),
          _btn(AppTexts.get('check', widget.language), () {
            if (_gridSel == "F4") _next(); else _err();
          })
        ],
      ),
    );
  }

  Widget _s2() {
    return MissionCard(
      color: Colors.deepPurpleAccent,
      header: "HALLUCINATION TEST",
      story: AppTexts.get('l4_s2_story', widget.language),
      footerInfo: Row(
        children: [
          const Icon(Icons.remove_red_eye, color: Colors.purpleAccent, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(
            widget.language == 'TR' ? "GERÇEKLİK BÜTÜNLÜĞÜ: %12" : "REALITY INTEGRITY: 12%",
            style: const TextStyle(color: Colors.purpleAccent, fontSize: 11, fontFamily: 'Courier'),
          )),
        ],
      ),
      content: Column(
        children: [
           Container(
             padding: const EdgeInsets.all(10),
             margin: const EdgeInsets.only(bottom: 20),
             decoration: BoxDecoration(border: Border.all(color: Colors.purple.withOpacity(0.5)), borderRadius: BorderRadius.circular(8)),
             child: const Text("👁️", style: TextStyle(fontSize: 40)),
           ),
          _btn(AppTexts.get('l4_s2_opt1', widget.language), () => _next()), // Doğru
          const SizedBox(height: 10),
          _btn(AppTexts.get('l4_s2_opt2', widget.language), () => _err()),
        ],
      ),
    );
  }

  Widget _s3() {
    return MissionCard(
      color: Colors.pinkAccent,
      header: "STABILIZE VISION",
      story: AppTexts.get('l4_s3_story', widget.language),
      content: Column(children: [
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _cBtn(Colors.blue, false),
          _cBtn(Colors.red, false),
          _cBtn(Colors.green, true),
        ])
      ]),
    );
  }

  Widget _btn(String t, VoidCallback p) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _themeColor.withOpacity(0.1),
        foregroundColor: _themeColor,
        side: BorderSide(color: _themeColor),
        padding: const EdgeInsets.symmetric(vertical: 16)
      ),
      onPressed: p, child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
  );

  Widget _cBtn(Color c, bool ok) => GestureDetector(
      onTap: () => ok ? _next() : _err(),
      child: Container(
        width: 80, height: 80, 
        decoration: BoxDecoration(
          color: c, 
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: c.withOpacity(0.6), blurRadius: 15)]
        )
      ));

  Widget _gBtn(String t, bool ok) => GestureDetector(
      onTap: () => setState(() => _gridSel = t),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 70, height: 70,
          decoration: BoxDecoration(
            color: _gridSel == t ? _themeColor : Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _gridSel == t ? Colors.white : Colors.grey)
          ),
          child: Center(child: Text(t, style: TextStyle(
            color: _gridSel == t ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold
          )))));
}