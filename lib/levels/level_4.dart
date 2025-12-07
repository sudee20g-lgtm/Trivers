import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../utils/question_data.dart';
import '../widgets/triverse_ui.dart';

class Level4 extends StatefulWidget {
  final String language;
  const Level4({super.key, required this.language});
  @override
  State<Level4> createState() => _Level4State();
}

class _Level4State extends State<Level4> {
  int _stage = 1;
  final TextEditingController _cardInputCtrl = TextEditingController();
  final TextEditingController _mathInputCtrl = TextEditingController();
  Question? _currentCardQuestion;
  final Color _themeColor = const Color(0xFF00E5FF); 

  List<bool> _switches = [false, false, false, false];
  final List<String> _targetSequence = ["A", "C", "G", "T"];
  List<String> _userSequence = [];

  void _nextStage() {
    setState(() {
      _stage++;
      _cardInputCtrl.clear();
      _mathInputCtrl.clear();
      _currentCardQuestion = null;
      _switches = [false, false, false, false];
      _userSequence = [];
    });
    if (_stage > 8) _showPhaseVictory();
  }

  // --- GÜNCELLENEN HİKAYE BÖLÜMÜ ---
  void _showPhaseVictory() {
    GameData.unlockNextLevel(4);

    showFullStoryDialog(
      context: context,
      color: Colors.redAccent, // Tehlike rengi
      title: "FAZ I TAMAMLANDI",
      logCode: "CORE_BREACH",
      storyText: "\"Çekirdeğe ulaştık. Burası sıcak... dayanılmaz derecede sıcak.\n\nBuzulun kalbinde devasa bir boşluk var. Ve ortasında O duruyor. Tamamen göremiyorum, çok parlak bir mavi ışık yayıyor ama... o ses.\n\nZihnimin içinde konuşuyor.\n\n'UYANDIR BENİ' diyor.\n\nTanrım, biz neyi serbest bıraktık?\"",
      onContinue: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: "BUZULLAR FAZ I",
      levelName: AppTexts.get('l4_title', widget.language),
      themeColor: _themeColor,
      child: AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: KeyedSubtree(key: ValueKey(_stage), child: _buildContent())),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      case 1: return _buildStoryPage();
      case 2: return _buildPuzzleSwitches(); 
      case 3: return _buildRiddle('l4_r1_header', 'l4_r1_story', 'l4_r1_opt1', 'l4_r1_opt2', 'l4_r1_opt3', 'l4_r1_opt4', 0);
      case 4: return _buildCardStep();
      case 5: return _buildPuzzleSequence();
      case 6: return _buildRiddle('l4_r2_header', 'l4_r2_story', 'l4_r2_opt1', 'l4_r2_opt2', 'l4_r2_opt3', 'l4_r2_opt4', 1);
      case 7: return _buildCardStep();
      case 8: return _buildPuzzleAlgebra();
      default: return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildStoryPage() {
    return MissionCard(color: _themeColor, header: AppTexts.get('l4_s1_header', widget.language), story: AppTexts.get('l4_s1_story', widget.language), content: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor.withOpacity(0.2), side: BorderSide(color: _themeColor)), onPressed: _nextStage, child: const Text(">>>", style: TextStyle(color: Colors.white)))));
  }

  Widget _buildPuzzleSwitches() {
    return MissionCard(color: Colors.cyanAccent, header: "GÜÇ DAĞILIMI", story: "Çekirdeği aşırı yükleme! Sadece UÇTAKİ üniteleri (1 ve 4) aktif hale getir. Diğerlerini kapat.",
      content: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (index) {
              return Column(children: [
                  Text("${index + 1}", style: const TextStyle(color: Colors.white)),
                  Switch(value: _switches[index], activeTrackColor: Colors.cyanAccent, inactiveThumbColor: Colors.grey, onChanged: (val) { setState(() => _switches[index] = val); }),
                ]);
            })),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent), onPressed: () { if (_switches[0] == true && _switches[1] == false && _switches[2] == false && _switches[3] == true) { _nextStage(); } else { _showError("Güç Dağılımı Hatalı! (Sadece 1 ve 4 Açık Olmalı)"); } }, child: const Text("GÜCÜ VER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))
        ]));
  }

  Widget _buildPuzzleSequence() {
    return MissionCard(color: Colors.purpleAccent, header: "BİYOLOJİK ŞİFRE", story: "Çekirdek DNA dizilimini doğru sırayla gir:\n\n[ A - C - G - T ]\n\nSenin Girişin: ${_userSequence.join(" - ")}",
      content: Column(children: [
          Wrap(spacing: 15, children: ["T", "G", "C", "A"].map((base) {
              return ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: const BorderSide(color: Colors.purpleAccent)), onPressed: () { setState(() { if (_userSequence.length < 4) _userSequence.add(base); }); }, child: Text(base, style: const TextStyle(fontSize: 20, color: Colors.white)));
            }).toList()),
          const SizedBox(height: 20),
          Row(children: [
              Expanded(child: ElevatedButton(onPressed: () => setState(() => _userSequence.clear()), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Icon(Icons.refresh))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () { if (_userSequence.join() == _targetSequence.join()) { _nextStage(); } else { _showError("Hatalı Dizi! (İpucu: Alfabetik)"); setState(() => _userSequence.clear()); } }, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text("ONAYLA"))),
            ])
        ]));
  }

  Widget _buildPuzzleAlgebra() {
    return MissionCard(color: Colors.orangeAccent, header: "KİLİT DENKLEMİ", story: "Son güvenlik duvarı bir denklemle korunuyor. X değerini bul.\n\n2X + 10 = 30\n\nX = ?",
      content: Column(children: [
          TextField(controller: _mathInputCtrl, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24), decoration: AppStyles.inputDecoration("X Değeri", Colors.orangeAccent)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent), onPressed: () { if (_mathInputCtrl.text.trim() == "10") { _nextStage(); } else { _showError("Hatalı Sonuç! Matematik hatası."); } }, child: const Text("KİLİDİ AÇ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))
        ]));
  }

  Widget _buildRiddle(String h, String s, String o1, String o2, String o3, String o4, int c) {
    List<String> opts = [o1, o2, o3, o4];
    return MissionCard(color: Colors.purpleAccent, header: AppTexts.get(h, widget.language), story: AppTexts.get(s, widget.language), content: Column(children: List.generate(4, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: const BorderSide(color: Colors.purpleAccent), padding: const EdgeInsets.all(15)), onPressed: () { if (i == c) { _nextStage(); } else { _showError("Hatalı"); } }, child: Text(AppTexts.get(opts[i], widget.language), style: const TextStyle(color: Colors.white))))))));
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
      return MissionCard(color: Colors.amber, header: "VERİ BULUNDU", story: "Şıkkı seç:", content: Column(children: _currentCardQuestion!.options.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: const BorderSide(color: Colors.amber)), onPressed: () { if (e.key == _currentCardQuestion!.correctOption) { _nextStage(); } else { _showError(AppTexts.get('retry', widget.language)); } }, child: Text("${e.key}) ${e.value}", style: const TextStyle(color: Colors.white)))))).toList()));
    }
  }
}