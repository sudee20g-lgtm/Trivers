import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';

class Level2 extends StatefulWidget {
  final String language;
  const Level2({super.key, required this.language});
  @override
  State<Level2> createState() => _Level2State();
}

class _Level2State extends State<Level2> {
  int _stage = 1;
  final List<String> _s1Selection = [];
  final TextEditingController _s3Controller = TextEditingController();

  void _nextStage() {
    if (_stage < 3) {
      setState(() => _stage++);
    } else {
      _showVictory();
    }
  }

  void _showVictory() {
    GameData.unlockNextLevel(2);
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (c) => _victoryPopup());
  }

  Widget _victoryPopup() => Container(
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
        Text(AppTexts.get('l2_reward', widget.language),
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

  void _error() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppTexts.get('retry', widget.language)),
        backgroundColor: Colors.red));
    if (_stage == 1) setState(() => _s1Selection.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b0e17),
      appBar: AppBar(
          title: Text(
              "${AppTexts.get('l2_title', widget.language)} - STAGE $_stage/3",
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 14)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.cyanAccent)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20), child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (_stage == 1) return _stage1Order();
    if (_stage == 2) return _stage2DNA();
    return _stage3Math();
  }

  // STAGE 1: SIRALAMA
  Widget _stage1Order() {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(15),
          decoration: AppStyles.neonBox(color: Colors.green),
          child: Text(AppTexts.get('l2_s1_story', widget.language),
              style: AppStyles.storyStyle)),
      const SizedBox(height: 20),
      _item("D", AppTexts.get('l2_optD', widget.language)),
      _item("A", AppTexts.get('l2_optA', widget.language)),
      _item("C", AppTexts.get('l2_optC', widget.language)),
      _item("B", AppTexts.get('l2_optB', widget.language)),
      const SizedBox(height: 20),
      ElevatedButton(
          onPressed: () {
            if (_s1Selection.join() == "DACB") {
              _nextStage();
            } else {
              _error();
            }
          },
          child: Text(AppTexts.get('check', widget.language)))
    ]);
  }

  Widget _item(String id, String txt) {
    bool sel = _s1Selection.contains(id);
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
            onTap: () => setState(() {
                  if (!sel && _s1Selection.length < 4) _s1Selection.add(id);
                }),
            child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color:
                        sel ? Colors.green.withOpacity(0.3) : Colors.grey[900],
                    border: Border.all(color: sel ? Colors.green : Colors.grey),
                    borderRadius: BorderRadius.circular(8)),
                child: Text("$id: $txt",
                    style: const TextStyle(color: Colors.white)))));
  }

  // STAGE 2: DNA
  Widget _stage2DNA() {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(15),
          decoration: AppStyles.neonBox(color: Colors.blue),
          child: Text(AppTexts.get('l2_s2_story', widget.language),
              style: AppStyles.storyStyle)),
      const SizedBox(height: 30),
      Text(AppTexts.get('l2_s2_q', widget.language),
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
      const SizedBox(height: 30),
      _btn(AppTexts.get('l2_s2_opt1', widget.language), false),
      const SizedBox(height: 10),
      _btn(AppTexts.get('l2_s2_opt2', widget.language), true), // T (Timin)
    ]);
  }

  // STAGE 3: MATEMATİK
  Widget _stage3Math() {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(15),
          decoration: AppStyles.neonBox(color: Colors.orange),
          child: Text(AppTexts.get('l2_s3_story', widget.language),
              style: AppStyles.storyStyle)),
      const SizedBox(height: 20),
      TextField(
          controller: _s3Controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: AppTexts.get('l2_s3_input', widget.language),
              filled: true,
              fillColor: Colors.white10)),
      const SizedBox(height: 20),
      ElevatedButton(
          onPressed: () {
            if (_s3Controller.text == "60") {
              _nextStage();
            } else {
              _error();
            }
          },
          child: Text(AppTexts.get('check', widget.language)))
    ]);
  }

  Widget _btn(String t, bool c) => ElevatedButton(
      onPressed: () => c ? _nextStage() : _error(), child: Text(t));
}
