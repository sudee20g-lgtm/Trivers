import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';

class Level4 extends StatefulWidget {
  final String language;
  const Level4({super.key, required this.language});
  @override
  State<Level4> createState() => _Level4State();
}

class _Level4State extends State<Level4> {
  int _stage = 1;
  String? _gridSel;

  void _next() {
    if (_stage < 3) {
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
      height: 350,
      decoration: const BoxDecoration(
          color: Color(0xFF0b0e17),
          border: Border(top: BorderSide(color: Colors.purpleAccent, width: 3)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.star, color: Colors.purpleAccent, size: 80),
        Text(AppTexts.get('success', widget.language),
            style: AppStyles.titleStyle(Colors.purpleAccent)),
        const SizedBox(height: 10),
        Text(AppTexts.get('l4_reward', widget.language),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("ZONE COMPLETE",
                style: TextStyle(color: Colors.white)))
      ]));
  void _err() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppTexts.get('retry', widget.language)),
      backgroundColor: Colors.red));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b0e17),
      appBar: AppBar(
          title: Text(
              "${AppTexts.get('l4_title', widget.language)} - STAGE $_stage/3",
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 14)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.cyanAccent)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20), child: _content()),
    );
  }

  Widget _content() {
    if (_stage == 1) return _s1();
    if (_stage == 2) return _s2();
    return _s3();
  }

  // STAGE 1: GRID
  Widget _s1() {
    return Column(children: [
      Text(AppTexts.get('l4_s1_story', widget.language),
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 20),
      Wrap(spacing: 10, children: [
        _gBtn("A1", false),
        _gBtn("C7", false),
        _gBtn("F4", true),
        _gBtn("D6", false)
      ]), // F4 Doğru
      ElevatedButton(
          onPressed: () {
            if (_gridSel == "F4") {
              _next();
            } else {
              _err();
            }
          },
          child: Text(AppTexts.get('check', widget.language)))
    ]);
  }

  // STAGE 2: KİMYA
  Widget _s2() {
    return Column(children: [
      Text(AppTexts.get('l4_s2_story', widget.language),
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 20),
      _btn(AppTexts.get('l4_s2_opt1', widget.language), true), // 1:8
      const SizedBox(height: 10),
      _btn(AppTexts.get('l4_s2_opt2', widget.language), false),
    ]);
  }

  // STAGE 3: RENKLİ BUTONLAR
  Widget _s3() {
    return Column(children: [
      Text(AppTexts.get('l4_s3_story', widget.language),
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _cBtn(Colors.blue, false),
        _cBtn(Colors.red, false),
        _cBtn(Colors.green, true), // Yeşil doğru
      ])
    ]);
  }

  Widget _btn(String t, bool c) =>
      ElevatedButton(onPressed: () => c ? _next() : _err(), child: Text(t));
  Widget _cBtn(Color c, bool ok) => GestureDetector(
      onTap: () => ok ? _next() : _err(),
      child: Container(width: 80, height: 80, color: c));
  Widget _gBtn(String t, bool ok) => GestureDetector(
      onTap: () => setState(() => _gridSel = t),
      child: Container(
          width: 60,
          height: 60,
          color: _gridSel == t ? Colors.purple : Colors.grey,
          child: Center(child: Text(t))));
}
