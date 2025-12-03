import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../widgets/physical_card_widget.dart';

class Level1 extends StatefulWidget {
  final String language;
  const Level1({super.key, required this.language});
  @override
  State<Level1> createState() => _Level1State();
}

class _Level1State extends State<Level1> {
  int _stage = 1;
  final List<int> _valves = [1, 2, 3, 4, 5, 6, 7];
  final List<int> _selectedValves = [];

  void _nextStage() {
    if (_stage < 4) { // Artık 4 aşama var
      setState(() => _stage++);
    } else {
      _showVictory();
    }
  }

  void _showVictory() {
    GameData.unlockNextLevel(1);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
          Text(AppTexts.get('l1_reward', widget.language),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(AppTexts.get('continue', widget.language),
                  style: const TextStyle(color: Colors.black)))
        ]),
      ),
    );
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppTexts.get('retry', widget.language)),
        backgroundColor: Colors.red));
    if (_stage == 4) {
      setState(() => _selectedValves.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b0e17),
      appBar: AppBar(
          title: Text(
              "${AppTexts.get('l1_title', widget.language)} - ${AppTexts.get('stage_prefix', widget.language)} $_stage/4",
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 14)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.cyanAccent)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20), child: _buildStageContent()),
    );
  }

  Widget _buildStageContent() {
    if (_stage == 1) return _stage1Matrix();
    if (_stage == 2) return _stageCard(); // YENİ
    if (_stage == 3) return _stage2Riddle();
    return _stage3Sequence();
  }

  Widget _stageCard() {
    return PhysicalCardWidget(
      language: widget.language,
      cardNameKey: 'c1_name',
      questionKey: 'c1_q',
      optAKey: 'c1_a',
      optBKey: 'c1_b', // Doğru: Kar çukuru
      correctIndex: 1,
      onCorrect: _nextStage,
    );
  }

  Widget _stage1Matrix() {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(15),
          decoration: AppStyles.neonBox(color: Colors.blue),
          child: Text(AppTexts.get('l1_s1_story', widget.language),
              style: AppStyles.storyStyle)),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(children: [
          _row(["+5", "-3", "+2"]),
          const Divider(color: Colors.grey),
          _row(["-8", "+4", "+1"]),
          const Divider(color: Colors.grey),
          _row(["?", "-2", "+6"], isQ: true)
        ]),
      ),
      const SizedBox(height: 20),
      Text(AppTexts.get('l1_s1_task', widget.language),
          style: const TextStyle(color: Colors.yellowAccent)),
      const SizedBox(height: 20),
      Wrap(spacing: 20, children: [
        _btn("-2", false),
        _btn("-4", true),
        _btn("+4", false),
        _btn("0", false)
      ])
    ]);
  }

  Widget _stage2Riddle() {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(15),
          decoration: AppStyles.neonBox(color: Colors.purple),
          child: Text(AppTexts.get('l1_s2_story', widget.language),
              style: AppStyles.storyStyle)),
      const SizedBox(height: 30),
      Text(AppTexts.get('l1_s2_riddle', widget.language),
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic)),
      const SizedBox(height: 30),
      _btn(AppTexts.get('l1_s2_opt1', widget.language), false),
      const SizedBox(height: 10),
      _btn(AppTexts.get('l1_s2_opt2', widget.language), true),
      const SizedBox(height: 10),
      _btn(AppTexts.get('l1_s2_opt3', widget.language), false),
    ]);
  }

  Widget _stage3Sequence() {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(15),
          decoration: AppStyles.neonBox(color: Colors.red),
          child: Text(AppTexts.get('l1_s3_story', widget.language),
              style: AppStyles.storyStyle)),
      const SizedBox(height: 20),
      Wrap(
          spacing: 15,
          runSpacing: 15,
          children: _valves.map((v) {
            bool isSelected = _selectedValves.contains(v);
            return GestureDetector(
              onTap: isSelected
                  ? null
                  : () {
                      setState(() {
                        _selectedValves.add(v);
                        List<int> correct = [2, 3, 5, 7];
                        if (_selectedValves.length > correct.length) {
                          _showError();
                          return;
                        }
                        for (int i = 0; i < _selectedValves.length; i++) {
                          if (_selectedValves[i] != correct[i]) {
                            _showError();
                            return;
                          }
                        }
                        if (_selectedValves.length == 4) _nextStage();
                      });
                    },
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: isSelected ? Colors.green : Colors.grey[800],
                  child: Text("$v",
                      style: const TextStyle(color: Colors.white, fontSize: 20))),
            );
          }).toList()),
      const SizedBox(height: 20),
      Text("SEÇİLEN: ${_selectedValves.join('-')}",
          style: const TextStyle(color: Colors.white))
    ]);
  }

  Widget _btn(String txt, bool ok) => ElevatedButton(
      onPressed: () => ok ? _nextStage() : _showError(), child: Text(txt));
  Widget _row(List<String> s, {bool isQ = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: s.map((e) => Text(e, style: TextStyle(fontSize: 24, color: e == "?" ? Colors.red : Colors.white))).toList()));
}