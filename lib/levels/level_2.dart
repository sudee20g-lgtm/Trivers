import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../utils/question_data.dart';
import '../widgets/triverse_ui.dart';

class Level2 extends StatefulWidget {
  final String language;
  const Level2({super.key, required this.language});
  @override
  State<Level2> createState() => _Level2State();
}

class _Level2State extends State<Level2> {
  int _stage = 1;
  final TextEditingController _inputCtrl = TextEditingController(); 
  final TextEditingController _cardInputCtrl = TextEditingController();
  Question? _currentCardQuestion;
  final Color _themeColor = Colors.greenAccent;

  // --- YENİ SIRALAMA BULMACASI DEĞİŞKENLERİ ---
  // Karışık liste
  List<String> _layers = ["Sanayi Devrimi", "Volkanik Patlama (MÖ)", "Buzul Çağı", "Dinozorlar"];
  // Doğru cevap (Günümüzden Geçmişe)
  final List<String> _correctOrder = ["Sanayi Devrimi", "Volkanik Patlama (MÖ)", "Buzul Çağı", "Dinozorlar"]; 

  void _nextStage() {
    setState(() {
      _stage++;
      _inputCtrl.clear();
      _cardInputCtrl.clear();
      _currentCardQuestion = null;
    });
    if (_stage > 9) _showVictory();
  }

  void _showVictory() {
    GameData.unlockNextLevel(2);
    showFullStoryDialog(
      context: context,
      color: _themeColor,
      title: "ANOMALİ TESPİTİ",
      logCode: "BIO_HAZARD_LV3",
      storyText: "\"Bulduğumuz numuneyi inceledim. Bu bir fosil değil. Bu donmuş bir taş değil.\n\nBu, kopmuş bir uzuv parçası. Ve en korkunç kısmı: Hücreleri hala canlı.\n\n30 milyon yıldır buzun altında olmasına rağmen hücreler bölünüyor ve ısıya tepki veriyor. Bu parça neye aitse, geri kalanını arıyor.\"",
      onContinue: () { Navigator.pop(context); Navigator.pop(context); },
    );
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade900));

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: "BUZULLAR FAZ I",
      levelName: AppTexts.get('l2_title', widget.language),
      themeColor: _themeColor,
      child: AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: KeyedSubtree(key: ValueKey(_stage), child: _buildContent())),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      case 1: return _buildDiscovery('l2_s1_header', 'l2_s1_story', 'l2_btn_process');
      case 2: return _buildPuzzleDNA(); 
      case 3: return _buildCardStep(); 
      
      // YENİ: SIRALAMA BULMACASI
      case 4: return _buildLayerSortPuzzle(); 
      
      case 5: return _buildMathInput('l2_p2_header', 'l2_p2_story', "60");
      case 6: return _buildCardStep(); 
      case 7: return _buildDiscovery('l2_s1_header', 'l2_s1_story', 'continue');
      case 8: return _buildMultipleChoiceRiddle('l2_r2_header', 'l2_r2_story', ['l2_r2_opt1', 'l2_r2_opt2', 'l2_r2_opt3', 'l2_r2_opt4'], 1);
      case 9: return _buildMultipleChoiceRiddle('l2_p3_header', 'l2_p3_story', ['l2_p3_opt1', 'l2_p3_opt2', 'l2_p3_opt3'], 0);
      default: return Container();
    }
  }

  // --- YENİ KATMAN SIRALAMA WIDGETI ---
  Widget _buildLayerSortPuzzle() {
    return MissionCard(
      color: Colors.blueGrey,
      header: "JEOLOJİK KATMANLAR",
      story: "Buzuldan aldığın karot örneğindeki katmanları analiz et.\n\nGörevin: Bu olayları GÜNÜMÜZDEN -> GEÇMİŞE (Yukarıdan Aşağıya) doğru sırala.",
      content: Column(
        children: [
          // Basit yer değiştirme mantığı (Yukarı/Aşağı butonları)
          ..._layers.asMap().entries.map((entry) {
            int idx = entry.key;
            String text = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white24)),
              child: Row(
                children: [
                  Text("${idx + 1}.", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
                  // YUKARI BUTONU
                  if (idx > 0)
                    IconButton(icon: const Icon(Icons.arrow_upward, color: Colors.white70), onPressed: () {
                      setState(() {
                        var temp = _layers[idx];
                        _layers[idx] = _layers[idx - 1];
                        _layers[idx - 1] = temp;
                      });
                    }),
                  // AŞAĞI BUTONU
                  if (idx < _layers.length - 1)
                    IconButton(icon: const Icon(Icons.arrow_downward, color: Colors.white70), onPressed: () {
                      setState(() {
                        var temp = _layers[idx];
                        _layers[idx] = _layers[idx + 1];
                        _layers[idx + 1] = temp;
                      });
                    }),
                ],
              ),
            );
          }),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () {
                // KONTROL
                if (_layers[0] == _correctOrder[0] && _layers[1] == _correctOrder[1] && _layers[3] == _correctOrder[3]) {
                  _showInfoPopup(); // Doğruysa bilgi ekranını aç
                } else {
                  _showError("Sıralama Yanlış! (İpucu: En üstte en yeni olay olmalı)");
                }
              },
              child: const Text("ANALİZİ TAMAMLA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // SIRALAMA SONRASI BİLGİ EKRANI
  void _showInfoPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.cyanAccent)),
        title: const Text("KATMAN ANALİZİ BAŞARILI", style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Courier')),
        content: const Text(
          "Mükemmel sıralama.\n\n1. Sanayi Devrimi: Atmosferdeki karbon izleri.\n2. Volkanik Kül: MÖ 1600'deki Theran patlamasının izleri.\n3. Buzul Çağı: Oksijen izotoplarındaki ani düşüş.\n4. Dinozorlar: 66 milyon yıl öncesine ait iridyum tabakası.\n\nBu veriler, yaratığın hangi çağda donduğunu anlamamıza yardımcı olacak.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _nextStage();
            },
            child: const Text("KAPAT VE DEVAM ET >", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // ... Diğer standart widgetlar (Discovery, Riddle vb.) buraya gelecek ...
  Widget _buildDiscovery(String t, String s, String b) { return MissionCard(color: _themeColor, header: AppTexts.get(t, widget.language), story: AppTexts.get(s, widget.language), content: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor.withOpacity(0.2), side: BorderSide(color: _themeColor)), onPressed: _nextStage, child: Text(AppTexts.get(b, widget.language), style: const TextStyle(color: Colors.white))))); }
  Widget _buildMultipleChoiceRiddle(String h, String s, List<String> o, int c) { return MissionCard(color: _themeColor, header: AppTexts.get(h, widget.language), story: AppTexts.get(s, widget.language), content: Column(children: List.generate(o.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(color: _themeColor), padding: const EdgeInsets.symmetric(vertical: 15)), onPressed: () => i == c ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text(AppTexts.get(o[i], widget.language), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))))); }
  Widget _buildMathInput(String h, String s, String a) { return MissionCard(color: _themeColor, header: AppTexts.get(h, widget.language), story: AppTexts.get(s, widget.language), content: Column(children: [ TextField(controller: _inputCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center, decoration: AppStyles.inputDecoration("...", _themeColor)), const SizedBox(height: 15), SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor), onPressed: () { if (_inputCtrl.text.trim() == a) { _nextStage(); } else { _showError(AppTexts.get('retry', widget.language)); } }, child: const Text("HESAPLA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))) ])); }
  Widget _buildCardStep() { if (_currentCardQuestion == null) { return MissionCard(color: _themeColor, header: AppTexts.get('card_alert_title', widget.language), story: AppTexts.get('card_instruction', widget.language), content: Column(children: [ TextField(controller: _cardInputCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center, decoration: AppStyles.inputDecoration(AppTexts.get('card_input_hint', widget.language), _themeColor)), const SizedBox(height: 15), SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor), onPressed: () { int? id = int.tryParse(_cardInputCtrl.text); var q = QuestionData.getById(id ?? -1); if (q != null) { setState(() => _currentCardQuestion = q); } else { _showError(AppTexts.get('retry', widget.language)); } }, child: Text(AppTexts.get('card_scan_btn', widget.language), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))) ])); } else { return MissionCard(color: _themeColor, header: "VERİ ÇÖZÜMLENDİ", story: "Doğru şıkkı seç:", content: Column(children: _currentCardQuestion!.options.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(color: _themeColor)), onPressed: () => e.key == _currentCardQuestion!.correctOption ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text("${e.key}) ${e.value}", style: const TextStyle(color: Colors.white)))))).toList())); } }
  Widget _buildPuzzleDNA() { return MissionCard(color: _themeColor, header: AppTexts.get('l2_p1_header', widget.language), story: AppTexts.get('l2_p1_story', widget.language), content: Column(children: [ const Text("G - C", style: TextStyle(color: Colors.grey, fontSize: 16)), Text("A - ?", style: TextStyle(color: _themeColor, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: ["A", "T", "C", "G"].map((e) => ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(color: _themeColor)), onPressed: () => e == "T" ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text(e, style: TextStyle(color: _themeColor)))).toList()) ])); }
}