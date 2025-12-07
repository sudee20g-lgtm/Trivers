import 'package:flutter/material.dart';
// Döndürme için gerekli
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../utils/question_data.dart';
import '../widgets/triverse_ui.dart';

class Level1 extends StatefulWidget {
  final String language;
  const Level1({super.key, required this.language});
  @override
  State<Level1> createState() => _Level1State();
}

class _Level1State extends State<Level1> {
  int _stage = 1;
  final TextEditingController _cardInputCtrl = TextEditingController();
  Question? _currentCardQuestion;
  final Color _themeColor = Colors.cyanAccent;

  // --- YENİ VANA SİSTEMİ DEĞİŞKENLERİ ---
  // 3 Vana: Açılar (0=Doğru, 90, 180, 270)
  List<double> _valveAngles = [90.0, 270.0, 180.0]; 

  void _nextStage() {
    setState(() {
      _stage++;
      _cardInputCtrl.clear();
      _currentCardQuestion = null;
      // Vanaları bir sonraki oyun için sıfırla (gerekirse)
      _valveAngles = [90.0, 270.0, 180.0];
    });
    if (_stage > 12) _showVictory();
  }

  // --- VANA DÖNDÜRME MANTIĞI (ZOR) ---
  void _rotateValve(int index) {
    setState(() {
      // Tıklanan vanayı 90 derece çevir
      _valveAngles[index] = (_valveAngles[index] + 90) % 360;

      // ZORLUK: Bir vanayı çevirmek yanındakini de etkiler!
      if (index == 0) {
        // 1. Vana, 2. Vanayı ters yöne çevirir
        _valveAngles[1] = (_valveAngles[1] - 90) % 360;
        if(_valveAngles[1] < 0) _valveAngles[1] += 360;
      } 
      else if (index == 1) {
        // 2. Vana, 3. Vanayı etkiler
        _valveAngles[2] = (_valveAngles[2] + 90) % 360;
      }
      else if (index == 2) {
        // 3. Vana, 1. Vanayı etkiler (Döngü)
        _valveAngles[0] = (_valveAngles[0] + 90) % 360;
      }

      // KONTROL: Hepsi 0 (Yukarı) oldu mu?
      if (_valveAngles[0] == 0 && _valveAngles[1] == 0 && _valveAngles[2] == 0) {
        Future.delayed(const Duration(milliseconds: 500), _nextStage);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("BASINÇ STABİLİZE EDİLDİ!"), backgroundColor: Colors.green));
      }
    });
  }

  void _showVictory() {
    GameData.unlockNextLevel(1);
    showFullStoryDialog(
      context: context,
      color: _themeColor,
      title: "GÜNLÜK NO: 104",
      logCode: "SES_KAYDI_X72",
      storyText: "\"Jeneratörler çalışıyor ama bu beni rahatlatmadı.\n\nIşıklar geri geldiğinde koridorun sonunda buzun içine hapsolmuş bir 'şey' gördüm. İnsan değil. Ve vanaları açtığımızda... o şeyin göz kapakları titredi.\n\nSinyal, istasyonun altındaki sondaj kuyusundan geliyor. Onu biz uyandırdık.\"",
      onContinue: () {
        Navigator.pop(context); Navigator.pop(context);
      },
    );
  }
  
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red.shade900));
  }

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: "BUZULLAR FAZ I",
      levelName: AppTexts.get('l1_title', widget.language),
      themeColor: _themeColor,
      child: AnimatedSwitcher(duration: const Duration(milliseconds: 600), child: KeyedSubtree(key: ValueKey(_stage), child: _buildContent())),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      // Hikaye ve bulmaca akışı (Textler güncellendi)
      case 1: return _buildDiscovery("SİNYAL TESPİTİ", "Sensörler, 3000 metre derinlikte 'ritmik' bir sismik aktivite algıladı. Bu doğal değil. Bu bir kalp atışı.\n\nÖnce istasyonun ana gücünü geri getirmeliyiz.");
      case 2: return _buildPuzzleMatrix(); // Voltaj (Aynı kaldı)
      case 3: return _buildStoryLog("SİSTEM AKTİF", "Güç geri geldi ama vanalar donmuş durumda. Borulardaki basınç kritik seviyede. Patlamayı önlemek için hidrolik akışı dengele.");
      
      // YENİ VANA BULMACASI
      case 4: return _buildPuzzleValves(); 
      
      case 5: return _buildCardStep(); 
      case 6: return _buildRiddle("Soğuk nefes alır ama canlı değildir. Beyaz bir örtü örter ama üşümez. Ben neyim?", "BUZUL (GLACIER)", 1);
      case 7: return _buildStoryLog("DERİN TİTREŞİM", "Vanalardan geçen sıcak su, alt katmanlardaki buzu eritiyor. Aşağıdan metalik gıcırtılar geliyor. Bir kapı açılıyor olmalı.");
      case 8: return _buildCardStep(); 
      case 9: return _buildDiscovery("TERK EDİLMİŞ GÜNLÜK", "Eski şefin notu: 'Okyanustan gelen fısıltıları duyuyor musunuz? Buzun içinden geçiyorlar. Bizi aşağı çağırıyorlar.'");
      case 10: return _buildRiddle("Işığım mavidir ama gökyüzü değilim. Derinim ama deniz değilim.", "BUZ MAĞARASI (ICE CAVE)", 2);
      case 11: return _buildPuzzleWiring();
      case 12: return _buildStoryLog("SON HAZIRLIK", "Asansör boşluğu temizlendi. Aşağıya inen halatlar sağlam görünüyor. Derinliklere iniyoruz. Tanrı yardımcımız olsun.");
      default: return Container();
    }
  }

  // --- YENİ VANA WIDGET ---
  Widget _buildPuzzleValves() {
    return MissionCard(
      color: Colors.orangeAccent,
      header: "HİDROLİK KİLİT",
      story: "Vanalar paslanmış ve birbirine bağlı. Birini çevirmek diğerlerini de etkiliyor. Tüm göstergeleri YUKARI (Yeşil) konuma getir.",
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              bool isCorrect = _valveAngles[index] == 0;
              return GestureDetector(
                onTap: () => _rotateValve(index),
                child: Column(
                  children: [
                    // DÖNEN VANA İKONU
                    AnimatedRotation(
                      turns: _valveAngles[index] / 360,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 3),
                          color: Colors.white10,
                        ),
                        child: Icon(Icons.settings, size: 40, color: isCorrect ? Colors.green : Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("VANA ${index+1}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text("DURUM: KRİTİK", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 2)),
        ],
      ),
    );
  }

  // ... Diğer standart widgetlar (CardStep, Riddle vb.) buraya gelecek ...
  // (Önceki kodlardakiyle aynı, sadece _buildContent içinde sıraları değişti)
  Widget _buildStoryLog(String title, String text) {
    return MissionCard(color: Colors.white, isLog: true, header: title, story: text, content: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white10, side: const BorderSide(color: Colors.white54), padding: const EdgeInsets.symmetric(vertical: 15)), onPressed: _nextStage, child: const Text("DEVAM ET", style: TextStyle(color: Colors.white, letterSpacing: 2)))));
  }
  
  Widget _buildDiscovery(String title, String text) { return MissionCard(color: _themeColor, header: title, story: text, content: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor.withOpacity(0.2), side: BorderSide(color: _themeColor)), onPressed: _nextStage, child: const Text("VERİYİ İŞLE", style: TextStyle(color: Colors.white))))); }
  Widget _buildPuzzleMatrix() { return MissionCard(color: _themeColor, header: "GÜÇ KALİBRASYONU", story: "Sistemin voltaj dengesi bozulmuş. Mantığı çöz ve eksik değeri gir.", content: Column(children: [ Container(padding: const EdgeInsets.all(10), color: Colors.black, child: const Column(children: [Text("+5  -3  +2", style: TextStyle(color: Colors.white, fontSize: 18)), Divider(color: Colors.grey), Text("-8  +4  +1", style: TextStyle(color: Colors.white, fontSize: 18)), Divider(color: Colors.grey), Text("?   -2  +6", style: TextStyle(color: Colors.red, fontSize: 18))])), const SizedBox(height: 20), Wrap(spacing: 10, children: ["-2", "-4", "+4", "0"].map((e) => ElevatedButton(onPressed: () => e=="-4" ? _nextStage() : _showError("Voltaj Hatası"), child: Text(e))).toList())])); }
  Widget _buildPuzzleWiring() { return MissionCard(color: Colors.greenAccent, header: "ANA SİSTEM BAĞLANTISI", story: "Tüm sistemler hazır. 'BAŞLAT' komutunu onaylamak için Mavi ve Kırmızı kabloyu aynı anda kes (Butona bas).", content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), onPressed: () => _showError("Tek başına olmaz!"), child: const Text("MAVİ")), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white10), onPressed: () => _nextStage(), child: const Text("İKİSİ DE", style: TextStyle(color: Colors.white))), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => _showError("Tek başına olmaz!"), child: const Text("KIRMIZI"))])); }
  Widget _buildCardStep() { if (_currentCardQuestion == null) { return MissionCard(color: Colors.amber, header: AppTexts.get('card_alert_title', widget.language), story: AppTexts.get('card_instruction', widget.language), content: Column(children: [ TextField(controller: _cardInputCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center, decoration: AppStyles.inputDecoration(AppTexts.get('card_input_hint', widget.language), Colors.amber)), const SizedBox(height: 15), SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber), onPressed: () { int? id = int.tryParse(_cardInputCtrl.text); var q = QuestionData.getById(id ?? -1); if (q != null) { setState(() => _currentCardQuestion = q); } else { _showError(AppTexts.get('try_again', widget.language)); } }, child: Text(AppTexts.get('card_scan_btn', widget.language), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))) ])); } else { return MissionCard(color: Colors.amber, header: "VERİ ÇÖZÜMLENDİ", story: "Doğru şıkkı seç:", content: Column(children: _currentCardQuestion!.options.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(color: Colors.amber.withOpacity(0.5)), padding: const EdgeInsets.all(15)), onPressed: () => e.key == _currentCardQuestion!.correctOption ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text("${e.key}) ${e.value}", style: const TextStyle(color: Colors.white)))))).toList())); } }
  Widget _buildRiddle(String riddle, String correctText, int correctIndex) { List<String> options = []; if(correctIndex == 1) options = ["KAR (SNOW)", "BUZUL (GLACIER)", "RÜZGAR (WIND)", "AYI (BEAR)"]; if(correctIndex == 2) options = ["OKYANUS (OCEAN)", "GÖKYÜZÜ (SKY)", "BUZ MAĞARASI (ICE CAVE)", "AYNA (MIRROR)"]; return MissionCard(color: Colors.purpleAccent, header: "ŞİFRELİ MESAJ", story: riddle, content: Column(children: List.generate(options.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: const BorderSide(color: Colors.purpleAccent), padding: const EdgeInsets.symmetric(vertical: 15)), onPressed: () => i == (options.contains(correctText) ? options.indexOf(correctText) : correctIndex) ? _nextStage() : _showError("Hatalı Çözüm"), child: Text(options[i], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))))); }
}