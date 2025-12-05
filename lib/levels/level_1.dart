import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../widgets/physical_card_widget.dart';
import '../widgets/triverse_ui.dart'; // YENİ TASARIM DOSYASI

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
  final Color _themeColor = Colors.cyanAccent;

  void _nextStage() {
    if (_stage < 4) {
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
      builder: (context) => _buildVictoryPopup(),
    );
  }

  Widget _buildVictoryPopup() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 400,
      decoration: BoxDecoration(
          color: const Color(0xFF050910),
          border: Border(top: BorderSide(color: _themeColor, width: 3)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: _themeColor.withOpacity(0.2), blurRadius: 20)]
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.radar, color: _themeColor, size: 60),
        const SizedBox(height: 15),
        Text(widget.language == 'TR' ? "İSTASYON AKTİF" : "STATION ONLINE",
             style: AppStyles.titleStyle(_themeColor)),
        const SizedBox(height: 15),
        Text(
            widget.language == 'TR'
                ? "Sistemler stabilize edildi. Ancak derinlerde bir enerji dalgalanması var. Aşağı inmeye hazırlan."
                : "Systems stabilized. But there is an energy fluctuation deep down. Prepare to descend.",
            textAlign: TextAlign.center,
            style: AppStyles.loreStyle(_themeColor)),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _themeColor, padding: const EdgeInsets.all(15)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                  widget.language == 'TR' ? "BUZULLARA İN" : "DESCEND TO ICE",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))),
        )
      ]),
    );
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppTexts.get('retry', widget.language), style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
    ));
    if (_stage == 4) setState(() => _selectedValves.clear());
  }

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: AppTexts.get('l1_title', widget.language),
      levelName: "SECTOR: ICE-01",
      themeColor: _themeColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: KeyedSubtree(
          key: ValueKey(_stage),
          child: _buildStageContent(),
        ),
      ),
    );
  }

  Widget _buildStageContent() {
    if (_stage == 1) return _stage1Matrix();
    if (_stage == 2) return _stageCard();
    if (_stage == 3) return _stage2Riddle();
    return _stage3Sequence();
  }

  Widget _stageCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: PhysicalCardWidget(
        language: widget.language,
        cardNameKey: 'c1_name',
        questionKey: 'c1_q',
        optAKey: 'c1_a',
        optBKey: 'c1_b',
        correctIndex: 1,
        onCorrect: _nextStage,
      ),
    );
  }

  Widget _stage1Matrix() {
    return MissionCard(
      color: _themeColor,
      header: "SYSTEM REBOOT: PHASE 1",
      story: AppTexts.get('l1_s1_story', widget.language),
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: _themeColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(children: [
              _row(["+5", "-3", "+2"]),
              Divider(color: _themeColor.withOpacity(0.2)),
              _row(["-8", "+4", "+1"]),
              Divider(color: _themeColor.withOpacity(0.2)),
              _row(["?", "-2", "+6"], isQ: true)
            ]),
          ),
          const SizedBox(height: 20),
          Text(AppTexts.get('l1_s1_task', widget.language),
              style: TextStyle(color: Colors.yellowAccent, fontFamily: 'Courier', fontSize: 13)),
          const SizedBox(height: 20),
          Wrap(spacing: 15, runSpacing: 15, alignment: WrapAlignment.center, children: [
            _btn("-2", false),
            _btn("-4", true),
            _btn("+4", false),
            _btn("0", false)
          ])
        ],
      ),
    );
  }

  Widget _stage2Riddle() {
    return MissionCard(
      color: Colors.purpleAccent, // Tehlike rengi
      header: "CRITICAL FAILURE DETECTED",
      story: AppTexts.get('l1_s2_story', widget.language),
      footerInfo: Row(
        children: [
          const Icon(Icons.thermostat, color: Colors.cyanAccent, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(
            widget.language == 'TR' ? "DIŞ SICAKLIK: -95°C. SİSTEMLER DONUYOR." : "EXT TEMP: -95°C. SYSTEMS FREEZING.",
            style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontFamily: 'Courier'),
          )),
        ],
      ),
      content: Column(
        children: [
          Text(AppTexts.get('l1_s2_riddle', widget.language),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
          const SizedBox(height: 30),
          _btn(AppTexts.get('l1_s2_opt1', widget.language), false, color: Colors.purpleAccent),
          const SizedBox(height: 10),
          _btn(AppTexts.get('l1_s2_opt2', widget.language), true, color: Colors.purpleAccent),
          const SizedBox(height: 10),
          _btn(AppTexts.get('l1_s2_opt3', widget.language), false, color: Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _stage3Sequence() {
    return MissionCard(
      color: Colors.redAccent,
      header: "MANUAL OVERRIDE REQUIRED",
      story: AppTexts.get('l1_s3_story', widget.language),
      content: Column(
        children: [
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: _valves.map((v) {
              bool isSelected = _selectedValves.contains(v);
              return GestureDetector(
                onTap: isSelected ? null : () {
                  setState(() {
                    _selectedValves.add(v);
                    _checkSequence();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.grey[900],
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? Colors.greenAccent : Colors.redAccent),
                    boxShadow: [if(isSelected) BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 10)]
                  ),
                  child: Center(child: Text("$v", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                ),
              );
            }).toList()
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: Text("SEQUENCE: ${_selectedValves.join(' - ')}", style: const TextStyle(color: Colors.redAccent, fontFamily: 'Courier')),
          )
        ],
      ),
    );
  }

  void _checkSequence() {
    List<int> correct = [2, 3, 5, 7];
    if (_selectedValves.length > correct.length) { _showError(); return; }
    for (int i = 0; i < _selectedValves.length; i++) {
      if (_selectedValves[i] != correct[i]) { _showError(); return; }
    }
    if (_selectedValves.length == 4) _nextStage();
  }

  Widget _btn(String txt, bool ok, {Color color = Colors.cyanAccent}) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
      ),
      onPressed: () => ok ? _nextStage() : _showError(), 
      child: Text(txt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
    ),
  );

  Widget _row(List<String> s, {bool isQ = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: s.map((e) => Text(e, style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: e == "?" ? Colors.red : Colors.white
          ))).toList()));
}