import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../utils/question_data.dart';
import '../widgets/triverse_ui.dart';

class Level3 extends StatefulWidget {
  final String language;
  const Level3({super.key, required this.language});
  @override
  State<Level3> createState() => _Level3State();
}

class _Level3State extends State<Level3> {
  int _stage = 1;
  final TextEditingController _cardInputCtrl = TextEditingController();
  final TextEditingController _puzzleInputCtrl = TextEditingController();
  Question? _currentCardQuestion;
  
  // Puzzle Variables
  int _currentPressure = 0;
  final int _targetPressure = 100;
  double _drillProgress = 0.0;
  bool _drillMoving = true;
  Timer? _drillTimer;

  final Color _themeColor = const Color(0xFF2979FF); 

  @override
  void dispose() {
    _drillTimer?.cancel();
    _cardInputCtrl.dispose();
    _puzzleInputCtrl.dispose();
    super.dispose();
  }

  void _nextStage() {
    _drillTimer?.cancel(); 
    setState(() {
      _stage++;
      _cardInputCtrl.clear();
      _puzzleInputCtrl.clear();
      _currentCardQuestion = null;
      _currentPressure = 0;
      _drillProgress = 0.0;
      _drillMoving = true;
    });
    if (_stage > 8) _showVictory();
  }

  // --- GÜNCELLENEN HİKAYE BÖLÜMÜ ---
  void _showVictory() {
    GameData.unlockNextLevel(3);

    showFullStoryDialog(
      context: context,
      color: Colors.blueAccent,
      title: "DERİNLİK: -4000M",
      logCode: "PSYCH_EVAL_FAIL",
      storyText: "\"Buzul yarığından aşağı indikçe basınç artmalıydı. Ama azaldı.\n\nBurada fizik kuralları işlemiyor. Pusulalar çıldırmış durumda. Ekipteki herkes aynı rüyayı gördüğünü söylüyor: 'Mavi gözlü dev bir gölge.'\n\nDuvarlardaki buz şeffaflaşıyor. Arkasında devasa siluetler hareket ediyor. Bizi izliyorlar. Aşağı inmeye devam ediyoruz ama sanırım onlar bizi çağırıyor.\"",
      onContinue: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      duration: const Duration(milliseconds: 800),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: "BUZULLAR FAZ I",
      levelName: AppTexts.get('l3_title', widget.language),
      themeColor: _themeColor,
      child: AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: KeyedSubtree(key: ValueKey(_stage), child: _buildContent())),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      case 1: return _buildStoryPage();
      case 2: return _buildPuzzlePressure(); 
      case 3: return _buildRiddle('l3_r1_header', 'l3_r1_story', 'l3_r1_opt1', 'l3_r1_opt2', 'l3_r1_opt3', 'l3_r1_opt4', 1);
      case 4: return _buildCardStep();
      case 5: return _buildPuzzleMath();
      case 6: return _buildRiddle('l3_r2_header', 'l3_r2_story', 'l3_r2_opt1', 'l3_r2_opt2', 'l3_r2_opt3', 'l3_r2_opt4', 1);
      case 7: return _buildCardStep();
      case 8: return _buildPuzzleReflex(); 
      default: return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildStoryPage() {
    return MissionCard(
      color: _themeColor,
      header: AppTexts.get('l3_s1_header', widget.language),
      story: AppTexts.get('l3_s1_story', widget.language),
      content: SizedBox(width: double.infinity, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: _themeColor.withOpacity(0.2), side: BorderSide(color: _themeColor)),
        onPressed: _nextStage,
        child: const Text(">>>", style: TextStyle(color: Colors.white, fontSize: 20))
      )),
    );
  }

  Widget _buildPuzzlePressure() {
    return MissionCard(
      color: Colors.blueAccent,
      header: "HİDROLİK BASINÇ",
      story: "Sistemi başlatmak için basıncı tam olarak $_targetPressure PSI seviyesine getir.\nŞu anki Basınç: $_currentPressure PSI",
      content: Column(
        children: [
          LinearProgressIndicator(
            value: _currentPressure / 150, 
            backgroundColor: Colors.black, 
            color: _currentPressure == _targetPressure ? Colors.green : (_currentPressure > _targetPressure ? Colors.red : Colors.blue),
            minHeight: 10,
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _pressureBtn("+25", 25, Colors.blue),
            _pressureBtn("+10", 10, Colors.cyan),
            _pressureBtn("-5", -5, Colors.orange),
          ]),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () => setState(() => _currentPressure = 0), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("SIFIRLA"))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(
                onPressed: () { if (_currentPressure == _targetPressure) { _nextStage(); } else { _showError("Basınç Hatalı! Hedef: $_targetPressure"); } }, 
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green), 
                child: const Text("ONAYLA")
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _pressureBtn(String label, int val, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(20), backgroundColor: color.withOpacity(0.3), side: BorderSide(color: color)),
      onPressed: () => setState(() => _currentPressure += val),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPuzzleMath() {
    return MissionCard(
      color: Colors.indigoAccent, header: "NAVİGASYON HATASI", story: "Konum verileri bozuldu. Manuel hesaplama gerekli.\n\nFORMÜL: (X * Y) - Z\n\nVERİLER:\n[X = 15]  [Y = 4]  [Z = 10]",
      content: Column(children: [
          TextField(controller: _puzzleInputCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 3), decoration: AppStyles.inputDecoration("SONUÇ ?", Colors.indigoAccent)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent), onPressed: () { if (_puzzleInputCtrl.text.trim() == "50") { _nextStage(); } else { _showError("Hatalı Hesaplama!"); } }, child: const Text("KOORDİNATI GİR", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))
      ]),
    );
  }

  Widget _buildPuzzleReflex() {
    if (_drillTimer == null && _drillMoving) {
      _drillTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (mounted) { setState(() { _drillProgress += 0.05; if (_drillProgress >= 1.0) _drillProgress = 0.0; }); }
      });
    }

    return MissionCard(
      color: Colors.redAccent, header: "SİSMİK KİLİT", story: "Mağara girişi mühürlü. Kırıcı iğneyi YEŞİL ALAN içindeyken durdur.",
      content: Column(children: [
          Container(height: 30, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
            child: Stack(children: [
                Positioned(left: MediaQuery.of(context).size.width * 0.3, width: MediaQuery.of(context).size.width * 0.2, top: 0, bottom: 0, child: Container(color: Colors.green.withOpacity(0.5))),
                LayoutBuilder(builder: (ctx, constraints) { return Positioned(left: constraints.maxWidth * _drillProgress, child: Container(width: 5, height: 30, decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.white, blurRadius: 5)]))); })
            ]),
          ),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(vertical: 20)),
            onPressed: () { _drillTimer?.cancel(); setState(() => _drillMoving = false); if (_drillProgress > 0.35 && _drillProgress < 0.65) { _showError("BAŞARILI! KİLİT KIRILIYOR..."); Future.delayed(const Duration(seconds: 1), _nextStage); } else { _showError("ISKA! Tekrar dene."); Future.delayed(const Duration(milliseconds: 500), () { setState(() { _drillProgress = 0.0; _drillMoving = true; _drillTimer = null; }); }); } },
            child: const Text("KİLİDİ KIR (DURDUR)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))))
      ]),
    );
  }

  Widget _buildRiddle(String h, String s, String o1, String o2, String o3, String o4, int c) {
    List<String> opts = [o1, o2, o3, o4];
    return MissionCard(color: Colors.purpleAccent, header: AppTexts.get(h, widget.language), story: AppTexts.get(s, widget.language), content: Column(children: List.generate(4, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: const BorderSide(color: Colors.purpleAccent), padding: const EdgeInsets.all(15)), onPressed: () => i == c ? _nextStage() : _showError("Hatalı Seçim"), child: Text(AppTexts.get(opts[i], widget.language), style: const TextStyle(color: Colors.white))))))));
  }

  Widget _buildCardStep() {
    if (_currentCardQuestion == null) {
      return MissionCard(color: Colors.amber, header: AppTexts.get('card_alert_title', widget.language), story: AppTexts.get('card_instruction', widget.language), content: Column(children: [
        TextField(controller: _cardInputCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center, decoration: AppStyles.inputDecoration(AppTexts.get('card_input_hint', widget.language), Colors.amber)),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), onPressed: () {
          int? id = int.tryParse(_cardInputCtrl.text);
          var q = QuestionData.getById(id ?? -1);
          if (q != null) { setState(() => _currentCardQuestion = q); } else { _showError(AppTexts.get('try_again', widget.language)); }
        }, child: Text(AppTexts.get('card_scan_btn', widget.language), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))
      ]));
    } else {
      return MissionCard(color: Colors.amber, header: "VERİ ÇÖZÜMLENDİ", story: "Doğru şıkkı seç:", content: Column(children: _currentCardQuestion!.options.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: const BorderSide(color: Colors.amber)), onPressed: () => e.key == _currentCardQuestion!.correctOption ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text("${e.key}) ${e.value}", style: const TextStyle(color: Colors.white)))))).toList()));
    }
  }
}