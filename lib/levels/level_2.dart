import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async'; // Timer için
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

  // --- KATMAN SIRALAMA BULMACASI DEĞİŞKENLERİ ---
  final List<String> _layers = ["Sanayi Devrimi", "Volkanik Patlama (MÖ)", "Buzul Çağı", "Dinozorlar"];
  final List<String> _correctOrder = ["Sanayi Devrimi", "Volkanik Patlama (MÖ)", "Buzul Çağı", "Dinozorlar"]; 

  void _nextStage() {
    setState(() {
      _stage++;
      _inputCtrl.clear();
      _cardInputCtrl.clear();
      _currentCardQuestion = null;
    });
    // Stage sayısı arttığı için oyun sonu kontrolü güncellendi
    if (_stage > 11) _showVictory();
  }

  void _showVictory() {
    GameData.unlockNextLevel(2);
    showFullStoryDialog(
      context: context,
      color: _themeColor,
      title: "ANOMALİ TESPİTİ",
      logCode: "BIO_HAZARD_LV3",
      storyText: "\"Bulduğumuz numuneyi inceledim. Bu bir fosil değil. Bu donmuş bir taş değil.\n\nBu, kopmuş bir uzuv parçası. Ve en korkunç kısmı: Hücreleri hala canlı.\n\n30 milyon yıldır buzun altında olmasına rağmen hücreler bölünüyor ve ısıya tepki veriyor. Bu parça neye aitse, geri kalanını arıyor.\n\nDerinlerden gelen o sesi duyuyor musun? Cevap veriyorlar.\"",
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600), 
        child: KeyedSubtree(key: ValueKey(_stage), child: SingleChildScrollView(child: _buildContent()))
      ),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      // 1. GİRİŞ HİKAYESİ
      case 1: return _buildDiscovery(
        'BİYOLOJİK SİNYAL', 
        "Buz duvarının arkasında organik bir yapı tespit ettik. Sanki buzun içine hapsolmuş devasa bir damar ağı gibi.\n\nMatkap ucu biyolojik bir engele çarptı. Numune alıp laboratuvar analizine başlamalıyız.", 
        'l2_btn_process'
      );
      
      // 2. BULMACA: DNA
      case 2: return _buildPuzzleDNA(); 
      
      // 3. ARA HİKAYE (DNA SONRASI)
      case 3: return _buildStoryInterlude(
        "GENETİK UYUMSUZLUK",
        "Bu imkansız... DNA dizilimi Dünya üzerindeki hiçbir canlıyla eşleşmiyor. Sarmal yapısı ikili değil, üçlü.\n\nVe daha kötüsü: Numune uyanıyor. Hücreler hızla bölünüyor. Onu stabilize etmemiz lazım yoksa tüpü patlatacak!",
        "STABİLİZASYONU BAŞLAT"
      );

      // 4. YENİ OYUN: HÜCRESEL STABİLİZASYON (Refleks Oyunu)
      case 4: return BioInjectionGame(onSuccess: _nextStage);

      // 5. ARA HİKAYE (OYUN SONRASI)
      case 5: return _buildStoryInterlude(
        "NUMUNE SAKİNLEŞTİ",
        "Güzel refleksler. Serum işe yaradı, hücre bölünmesi yavaşladı.\n\nŞimdi bu şeyin ne kadar süredir burada olduğunu anlamamız lazım. Karot örneğindeki jeolojik katmanları incele.",
        "KATMAN ANALİZİNE GEÇ"
      );

      // 6. BULMACA: KATMAN SIRALAMA
      case 6: return _buildLayerSortPuzzle(); 
      
      // 7. ARA HİKAYE (TARİH SONRASI)
      case 7: return _buildStoryInterlude(
        "TARİH ÖNCESİ DEHŞET",
        "Analiz sonuçları hatalı olmalı... Katman verilerine göre bu yaratık Dinozorlar çağından bile önce buradaydı.\n\nBuzul çağını, volkanik kışları, meteorları... Hepsini uykusunda atlatmış. O beklemiş.",
        "VERİLERİ DOĞRULA"
      );

      // 8. BULMACA: MATEMATİK (ERİME)
      case 8: return _buildMathInput('l2_p2_header', 'l2_p2_story', "60");
      
      // 9. BULMACA: FİZİKİ KART
      case 9: return _buildCardStep(); 
      
      // 10. BULMACA: RIDDLE (HÜCRE)
      case 10: return _buildMultipleChoiceRiddle('l2_r2_header', 'l2_r2_story', ['l2_r2_opt1', 'l2_r2_opt2', 'l2_r2_opt3', 'l2_r2_opt4'], 1);
      
      // 11. BULMACA: RIDDLE (TEHLİKE SEVİYESİ)
      case 11: return _buildMultipleChoiceRiddle('l2_p3_header', 'l2_p3_story', ['l2_p3_opt1', 'l2_p3_opt2', 'l2_p3_opt3'], 0);
      
      default: return Container();
    }
  }

  // --- MEVCUT WIDGETLAR ---
  Widget _buildLayerSortPuzzle() {
    return MissionCard(
      color: Colors.blueGrey,
      header: "JEOLOJİK KATMANLAR",
      story: "Buzuldan aldığın karot örneğindeki katmanları analiz et.\n\nGörevin: Bu olayları GÜNÜMÜZDEN -> GEÇMİŞE (Yukarıdan Aşağıya) doğru sırala.",
      content: Column(
        children: [
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
                  if (idx > 0) IconButton(icon: const Icon(Icons.arrow_upward, color: Colors.white70), onPressed: () { setState(() { var temp = _layers[idx]; _layers[idx] = _layers[idx - 1]; _layers[idx - 1] = temp; }); }),
                  if (idx < _layers.length - 1) IconButton(icon: const Icon(Icons.arrow_downward, color: Colors.white70), onPressed: () { setState(() { var temp = _layers[idx]; _layers[idx] = _layers[idx + 1]; _layers[idx + 1] = temp; }); }),
                ],
              ),
            );
          }),
          const SizedBox(height: 15),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey), onPressed: () {
            if (_layers[0] == _correctOrder[0] && _layers[1] == _correctOrder[1] && _layers[3] == _correctOrder[3]) { _showInfoPopup(); } else { _showError("Sıralama Yanlış! (İpucu: En üstte en yeni olay olmalı)"); }
          }, child: const Text("ANALİZİ TAMAMLA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))
        ],
      ),
    );
  }

  void _showInfoPopup() {
    showDialog(context: context, barrierDismissible: false, builder: (ctx) => AlertDialog(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.cyanAccent)), title: const Text("KATMAN ANALİZİ BAŞARILI", style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Courier')), content: const Text("Mükemmel sıralama.\n\n1. Sanayi Devrimi: Karbon izleri.\n2. Volkanik Kül: MÖ 1600.\n3. Buzul Çağı: İzotop düşüşü.\n4. Dinozorlar: İridyum tabakası.\n\nVeriler işleniyor...", style: TextStyle(color: Colors.white70)), actions: [TextButton(onPressed: () { Navigator.pop(ctx); _nextStage(); }, child: const Text("DEVAM ET >", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)))]));
  }

  Widget _buildStoryInterlude(String title, String story, String btnText) {
    return MissionCard(
      color: _themeColor,
      header: title,
      story: story,
      content: SizedBox(width: double.infinity, child: ElevatedButton(
        // DÜZELTME: withValues kullanıldı
        style: ElevatedButton.styleFrom(backgroundColor: _themeColor.withValues(alpha: 0.2), side: BorderSide(color: _themeColor), padding: const EdgeInsets.symmetric(vertical: 15)),
        onPressed: _nextStage,
        child: Text(btnText, style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 1.2))
      )),
    );
  }

  // DÜZELTME: withValues kullanıldı
  Widget _buildDiscovery(String t, String s, String b) { return MissionCard(color: _themeColor, header: t.contains("l2") ? AppTexts.get(t, widget.language) : t, story: s.contains("l2") ? AppTexts.get(s, widget.language) : s, content: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor.withValues(alpha: 0.2), side: BorderSide(color: _themeColor)), onPressed: _nextStage, child: Text(AppTexts.get(b, widget.language), style: const TextStyle(color: Colors.white))))); }
  
  Widget _buildMultipleChoiceRiddle(String h, String s, List<String> o, int c) { return MissionCard(color: _themeColor, header: AppTexts.get(h, widget.language), story: AppTexts.get(s, widget.language), content: Column(children: List.generate(o.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(color: _themeColor), padding: const EdgeInsets.symmetric(vertical: 15)), onPressed: () => i == c ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text(AppTexts.get(o[i], widget.language), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))))))); }
  Widget _buildMathInput(String h, String s, String a) { return MissionCard(color: _themeColor, header: AppTexts.get(h, widget.language), story: AppTexts.get(s, widget.language), content: Column(children: [ TextField(controller: _inputCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center, decoration: AppStyles.inputDecoration("...", _themeColor)), const SizedBox(height: 15), SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor), onPressed: () { if (_inputCtrl.text.trim() == a) { _nextStage(); } else { _showError(AppTexts.get('retry', widget.language)); } }, child: const Text("HESAPLA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))) ])); }
  Widget _buildCardStep() { if (_currentCardQuestion == null) { return MissionCard(color: _themeColor, header: AppTexts.get('card_alert_title', widget.language), story: AppTexts.get('card_instruction', widget.language), content: Column(children: [ TextField(controller: _cardInputCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center, decoration: AppStyles.inputDecoration(AppTexts.get('card_input_hint', widget.language), _themeColor)), const SizedBox(height: 15), SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _themeColor), onPressed: () { int? id = int.tryParse(_cardInputCtrl.text); var q = QuestionData.getById(id ?? -1); if (q != null) { setState(() => _currentCardQuestion = q); } else { _showError(AppTexts.get('retry', widget.language)); } }, child: Text(AppTexts.get('card_scan_btn', widget.language), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))) ])); } else { return MissionCard(color: _themeColor, header: "VERİ ÇÖZÜMLENDİ", story: "Doğru şıkkı seç:", content: Column(children: _currentCardQuestion!.options.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(color: _themeColor)), onPressed: () => e.key == _currentCardQuestion!.correctOption ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text("${e.key}) ${e.value}", style: const TextStyle(color: Colors.white)))))).toList())); } }
  Widget _buildPuzzleDNA() { return MissionCard(color: _themeColor, header: AppTexts.get('l2_p1_header', widget.language), story: AppTexts.get('l2_p1_story', widget.language), content: Column(children: [ const Text("G - C", style: TextStyle(color: Colors.grey, fontSize: 16)), Text("A - ?", style: TextStyle(color: _themeColor, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: ["A", "T", "C", "G"].map((e) => ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: BorderSide(color: _themeColor)), onPressed: () => e == "T" ? _nextStage() : _showError(AppTexts.get('retry', widget.language)), child: Text(e, style: TextStyle(color: _themeColor)))).toList()) ])); }
}

// ============================================================================
// YENİ OYUN: HÜCRESEL STABİLİZASYON (Bio Injection Game)
// ============================================================================
class BioInjectionGame extends StatefulWidget {
  final VoidCallback onSuccess;
  const BioInjectionGame({super.key, required this.onSuccess});
  @override
  State<BioInjectionGame> createState() => _BioInjectionGameState();
}

class _BioInjectionGameState extends State<BioInjectionGame> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  final List<double> _injectedAngles = []; // Radyan cinsinden saplanmış iğnelerin açıları
  int _needlesLeft = 8; // Toplam atılması gereken iğne
  bool _isGameOver = false;
  bool _isSuccess = false;
  
  // Zorluk Ayarları
  final double _rotationSpeed = 4.0; // Saniye cinsinden tam tur süresi (Daha düşük = Daha hızlı)
  final double _collisionThreshold = 0.35; // Radyan cinsinden çarpışma toleransı (Daha yüksek = Daha zor)

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(vsync: this, duration: Duration(milliseconds: (_rotationSpeed * 1000).toInt()))..repeat();
    
    // Başlangıçta halihazırda saplanmış birkaç iğne olsun (Zorluk için)
    _injectedAngles.add(0.5);
    _injectedAngles.add(2.5);
    _injectedAngles.add(4.0);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _injectNeedle() {
    if (_isGameOver || _isSuccess) return;

    // Şu anki dönüş açısını al (0 - 2PI arası)
    double currentRotation = _rotationController.value * 2 * math.pi;
    
    // İğne daima alttan (PI/2 veya 3PI/2 pozisyonundan) gelir. 
    double impactAngle = (math.pi / 2 - currentRotation);
    // Açıyı 0-2PI arasına normalizasyon
    while (impactAngle < 0) {
      impactAngle += 2 * math.pi;
    }
    while (impactAngle > 2 * math.pi) {
      impactAngle -= 2 * math.pi;
    }

    // Çarpışma Kontrolü
    bool collision = false;
    for (double angle in _injectedAngles) {
      double diff = (angle - impactAngle).abs();
      if (diff > math.pi) diff = 2 * math.pi - diff; // Dairesel en kısa mesafe
      
      if (diff < _collisionThreshold) {
        collision = true;
        break;
      }
    }

    if (collision) {
      _handleFail();
    } else {
      setState(() {
        _injectedAngles.add(impactAngle);
        _needlesLeft--;
      });

      if (_needlesLeft <= 0) {
        _handleSuccess();
      }
    }
  }

  void _handleFail() {
    setState(() {
      _isGameOver = true;
    });
    _rotationController.stop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("DAMAR YIRTILDI! ENJEKSİYON BAŞARISIZ."), backgroundColor: Colors.red));
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGameOver = false;
          _injectedAngles.clear();
          // Resetlerken yine başlangıç iğnelerini ekle
          _injectedAngles.add(0.5);
          _injectedAngles.add(2.5);
          _injectedAngles.add(4.0);
          _needlesLeft = 8;
          _rotationController.repeat();
        });
      }
    });
  }

  void _handleSuccess() {
    setState(() => _isSuccess = true);
    _rotationController.duration = const Duration(milliseconds: 500); // Hızla dönerek kutlama
    _rotationController.repeat();
    
    Future.delayed(const Duration(seconds: 2), widget.onSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return MissionCard(
      color: Colors.greenAccent,
      header: "HÜCRESEL ENJEKSİYON",
      story: "Numune aşırı tepki veriyor. Serumu doğrudan hücre çekirdeğine enjekte et.\n\nEkrana dokunarak iğneyi fırlat. Diğer iğnelere ÇARPMA.",
      content: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // DÖNEN HÜCRE ÇEKİRDEĞİ VE İĞNELER
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * math.pi,
                      child: SizedBox(
                        width: 200, height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // MERKEZ DAİRE (HÜCRE)
                            Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: _isGameOver ? Colors.red : (_isSuccess ? Colors.green : Colors.black),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.greenAccent, width: 4),
                                // DÜZELTME: withValues kullanıldı
                                boxShadow: [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.3), blurRadius: 20)]
                              ),
                              child: Center(
                                child: Text(
                                  _isSuccess ? "OK" : "$_needlesLeft",
                                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            
                            // SAPLANMIŞ İĞNELER
                            ..._injectedAngles.map((angle) {
                              return Transform.rotate(
                                angle: angle,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 100, // Yarıçap + Uzunluk
                                    height: 4,
                                    margin: const EdgeInsets.only(left: 40), // Merkezden uzaklık
                                    decoration: BoxDecoration(
                                      color: _isGameOver ? Colors.red : Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(2)
                                    ),
                                    // İğne Başı (Top)
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 10, height: 10,
                                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                // ALTTA BEKLEYEN İĞNE (FIRLATILACAK OLAN)
                Positioned(
                  bottom: 20,
                  child: Opacity(
                    opacity: _isSuccess ? 0.0 : 1.0,
                    child: Column(
                      children: [
                        Container(
                          width: 4, height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: const [BoxShadow(color: Colors.greenAccent, blurRadius: 10)]
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("DOKUN", style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2))
                      ],
                    ),
                  ),
                ),
                
                // TIKLAMA ALANI (TÜM EKRANI KAPLAYABİLİR)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _injectNeedle,
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}