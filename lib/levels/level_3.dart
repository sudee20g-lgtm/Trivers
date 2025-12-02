import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';

class Level3 extends StatefulWidget {
  final String language;
  const Level3({super.key, required this.language});
  @override
  State<Level3> createState() => _Level3State();
}

class _Level3State extends State<Level3> {
  int _stage = 1;
  final TextEditingController _s1Ctrl = TextEditingController();
  double _freq = 100;

  void _next() {
    if (_stage < 3) {
      setState(() => _stage++);
    } else {
      _win();
    }
  }

  void _win() {
    GameData.unlockNextLevel(3);
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (c) => _popup());
  }

  Widget _popup() => Container(
      height: 300,
      decoration: const BoxDecoration(
          color: Color(0xFF0b0e17),
          border: Border(top: BorderSide(color: Colors.greenAccent, width: 3)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
        Text(AppTexts.get('success', widget.language),
            style: AppStyles.titleStyle(Colors.greenAccent)),
        const SizedBox(height: 10),
        Text(AppTexts.get('l3_reward', widget.language),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(AppTexts.get('continue', widget.language),
                style: const TextStyle(color: Colors.black)))
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
              "${AppTexts.get('l3_title', widget.language)} - STAGE $_stage/3",
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

  // STAGE 1: ŞİFRE
  Widget _s1() {
    return Column(children: [
      Text(AppTexts.get('l3_s1_story', widget.language),
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 20),
      const Text("J - K - N - G - T",
          style: TextStyle(color: Colors.red, fontSize: 30, letterSpacing: 5)),
      TextField(
          controller: _s1Ctrl,
          decoration: InputDecoration(
              hintText: AppTexts.get('l3_s1_input', widget.language),
              filled: true,
              fillColor: Colors.white10)),
      ElevatedButton(
          onPressed: () {
            String t = _s1Ctrl.text.toUpperCase().trim();
            if (t == "ONLAR UYANDI" || t == "THEY AWOKE") {
              _next();
            } else {
              _err();
            }
          },
          child: Text(AppTexts.get('check', widget.language)))
    ]);
  }

  // STAGE 2: MORS
  Widget _s2() {
    return Column(children: [
      Text(AppTexts.get('l3_s2_story', widget.language),
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 30),
      const Text("... --- ...",
          style: TextStyle(
              color: Colors.yellow, fontSize: 40, fontWeight: FontWeight.bold)),
      const SizedBox(height: 30),
      _btn(AppTexts.get('l3_s2_opt1', widget.language), false),
      const SizedBox(height: 10),
      _btn(AppTexts.get('l3_s2_opt2', widget.language), true), // SOS
    ]);
  }

  // STAGE 3: FREKANS
  Widget _s3() {
    return Column(children: [
      Text(AppTexts.get('l3_s3_story', widget.language),
          style: const TextStyle(color: Colors.white)),
      const SizedBox(height: 30),
      Text("${_freq.toInt()} Hz",
          style: const TextStyle(color: Colors.greenAccent, fontSize: 40)),
      Slider(
          value: _freq,
          min: 100,
          max: 600,
          onChanged: (v) => setState(() => _freq = v)),
      ElevatedButton(
          onPressed: () {
            if ((_freq - 440).abs() < 10) {
              _next();
            } else {
              _err();
            }
          },
          child: Text(AppTexts.get('check', widget.language)))
    ]);
  }

  Widget _btn(String t, bool c) =>
      ElevatedButton(onPressed: () => c ? _next() : _err(), child: Text(t));
}
