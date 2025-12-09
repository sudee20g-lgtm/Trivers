import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math; // Rastgelelik için
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
  Question? _currentCardQuestion;
  final Color _themeColor = const Color(0xFF2979FF); 

  // --- PUZZLE 1: BASINÇ DEĞİŞKENLERİ ---
  int _currentPressure = 0;
  final int _targetPressure = 100;

  // --- PUZZLE 2: KOORDİNAT/SİNYAL (Map) DEĞİŞKENLERİ ---
  List<int> _mapPiecesStatus = List.generate(9, (index) => 0);
  List<int> _availablePieces = [0, 1, 2, 3, 4, 5, 6, 7, 8];

  // --- PUZZLE 3: SİSMİK KİLİT (GÜNCELLENDİ: ÇİFT AŞAMA) ---
  double _drillProgress = 0.0;
  bool _drillMoving = true;
  Timer? _drillTimer;
  
  // Yeni Kilit Değişkenleri
  int _lockStage = 1; // 1: Dış Kabuk, 2: İç Çekirdek
  double _drillSpeed = 0.02; // İğne hızı
  int _drillDirection = 1; // 1: İleri, -1: Geri (Ping-pong hareketi için)
  
  // Hedef Alan (0.0 ile 1.0 arası)
  double _targetStart = 0.40; 
  double _targetWidth = 0.25; 

  @override
  void initState() {
    super.initState();
    _availablePieces.shuffle(); 
  }

  @override
  void dispose() {
    _drillTimer?.cancel();
    _cardInputCtrl.dispose();
    super.dispose();
  }

  void _nextStage() {
    _drillTimer?.cancel(); 
    setState(() {
      _stage++;
      // Değişkenleri sıfırla
      _cardInputCtrl.clear();
      _currentCardQuestion = null;
      _currentPressure = 0;
      
      _mapPiecesStatus = List.generate(9, (index) => 0);
      _availablePieces = [0, 1, 2, 3, 4, 5, 6, 7, 8];
      _availablePieces.shuffle();
      
      // Kilit puzzle'ı için sıfırlama (Eğer geri dönülürse diye)
      _lockStage = 1;
      _drillProgress = 0.0;
      _drillMoving = true;
      _drillSpeed = 0.02;
      _targetStart = 0.40;
      _targetWidth = 0.25;
    });
    
    if (_stage > 8) _showVictory();
  }

  void _showVictory() {
    GameData.unlockNextLevel(3);
    if (!mounted) return;
    
    showFullStoryDialog(
      context: context,
      color: Colors.blueAccent,
      title: "DERİNLİK: -4000M",
      logCode: "UNKNOWN_REGION",
      storyText: "\"Sinyal birleştiğinde gördüğümüz şeye inanamadık. Koordinatlar okyanusu gösteriyor olmalıydı ama sonar orada devasa bir kara parçasını işaret ediyor.\n\nBurası haritalarda yok. Uydular burayı 'su' olarak görüyor. Sanki biri... veya bir şey burayı bilerek gizlemiş.\n\nO yaratıklar. Onlar uzaylı değil. Onlar hep buradaydı. Bu gizli kıtada.\"",
      onContinue: () {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500), 
        child: KeyedSubtree(key: ValueKey(_stage), child: SingleChildScrollView(child: _buildContent()))
      ),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      case 1: return _buildStoryPage();
      case 2: return _buildPuzzlePressure(); 
      case 3: return _buildRiddle('l3_r1_header', 'l3_r1_story', 'l3_r1_opt1', 'l3_r1_opt2', 'l3_r1_opt3', 'l3_r1_opt4', 1);
      case 4: return _buildCardStep();
      case 5: return _buildSignalMapPuzzle(); 
      case 6: return _buildRiddle('l3_r2_header', 'l3_r2_story', 'l3_r2_opt1', 'l3_r2_opt2', 'l3_r2_opt3', 'l3_r2_opt4', 1);
      case 7: return _buildCardStep();
      // GÜNCELLENEN KİLİT OYUNU BURADA
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
        style: ElevatedButton.styleFrom(backgroundColor: _themeColor.withValues(alpha: 0.2), side: BorderSide(color: _themeColor)),
        onPressed: _nextStage,
        child: const Text(">>>", style: TextStyle(color: Colors.white, fontSize: 20))
      )),
    );
  }

  // --- PUZZLE 1: BASINÇ ---
  Widget _buildPuzzlePressure() {
    return MissionCard(
      color: Colors.blueAccent,
      header: "HİDROLİK BASINÇ",
      story: "Sistemi başlatmak için basıncı tam olarak doğru PSI seviyesine getir.\nŞu anki Basınç: $_currentPressure PSI",
      content: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentPressure / 150).clamp(0.0, 1.0), 
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
      style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(20), backgroundColor: color.withValues(alpha: 0.3), side: BorderSide(color: color)),
      onPressed: () => setState(() => _currentPressure += val),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  // --- PUZZLE 2: SONAR SİNYAL REKONSTRÜKSİYONU ---
  Widget _buildSignalMapPuzzle() {
    bool isCompleted = !_mapPiecesStatus.contains(0);

    return MissionCard(
      color: Colors.tealAccent,
      header: "SİNYAL REKONSTRÜKSİYONU",
      story: "Derinlik arttıkça sonar verileri parçalandı. Ekranda 'GİZLİ KOORDİNAT' beliriyor ama veri bozuk.\n\nSinyal bloklarını (resim parçalarını) ızgarada doğru yerlerine yerleştirerek koordinatı netleştir.",
      content: Column(
        children: [
          Center(
            child: Container(
              height: 304, 
              width: 304,
              decoration: BoxDecoration(
                border: Border.all(color: isCompleted ? Colors.green : Colors.cyan.withValues(alpha: 0.5), width: 2),
                color: Colors.black,
                boxShadow: [BoxShadow(color: isCompleted ? Colors.green.withValues(alpha: 0.2) : Colors.cyan.withValues(alpha: 0.1), blurRadius: 10)]
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(2), 
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2, 
                  crossAxisSpacing: 2, 
                  childAspectRatio: 1.0, 
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return DragTarget<int>(
                    onWillAcceptWithDetails: (details) => _mapPiecesStatus[index] == 0,
                    onAcceptWithDetails: (details) {
                      int data = details.data;
                      if (data == index) {
                        setState(() {
                          _mapPiecesStatus[index] = 1;
                          _availablePieces.remove(data);
                        });
                      } else {
                        _showError("Sinyal Uyuşmazlığı! Yanlış Blok.");
                      }
                    },
                    builder: (context, candidates, rejected) {
                      bool isPlaced = _mapPiecesStatus[index] == 1;
                      
                      if (isPlaced) {
                        return MapPieceWidget(index: index);
                      }
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: candidates.isNotEmpty ? Colors.white24 : Colors.white10,
                        ),
                        child: candidates.isNotEmpty 
                          ? const Center(child: Icon(Icons.download, color: Colors.greenAccent))
                          : Center(child: Text("SEC ${index + 1}", style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10))),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          if (!isCompleted)
             const Text("VERİ BLOKLARINI SÜRÜKLE", style: TextStyle(color: Colors.cyanAccent, fontSize: 12, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _availablePieces.map((pieceIndex) {
              return Draggable<int>(
                data: pieceIndex,
                feedback: Material(
                  color: Colors.transparent,
                  elevation: 5,
                  child: Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent)),
                    child: MapPieceWidget(index: pieceIndex),
                  ),
                ),
                childWhenDragging: Container(width: 80, height: 80, color: Colors.white10),
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
                    color: Colors.black26,
                  ),
                  child: MapPieceWidget(index: pieceIndex),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, 
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.green : Colors.grey.shade900,
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: BorderSide(color: isCompleted ? Colors.green : Colors.transparent)
              ), 
              onPressed: isCompleted ? _nextStage : null, 
              child: Text(
                isCompleted ? "SİNYALİ DOĞRULA" : "VERİ EKSİK", 
                style: TextStyle(color: isCompleted ? Colors.black : Colors.white38, fontWeight: FontWeight.bold)
              )
            )
          )
        ],
      ),
    );
  }

  // --- PUZZLE 3: SİSMİK KİLİT (YENİLENDİ: 2 AŞAMALI) ---
  Widget _buildPuzzleReflex() {
    if (_drillTimer == null && _drillMoving) {
      // 16ms = ~60 FPS
      _drillTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        if (!mounted) { timer.cancel(); return; }
        setState(() {
          // İlerleme Mantığı (Ping-Pong / Sarkaç)
          _drillProgress += (_drillSpeed * _drillDirection);
          
          // Sınırlara çarpınca yön değiştir
          if (_drillProgress >= 1.0) {
            _drillProgress = 1.0;
            _drillDirection = -1;
          } else if (_drillProgress <= 0.0) {
            _drillProgress = 0.0;
            _drillDirection = 1;
          }
        });
      });
    }

    // Aşamaya göre metin ve renkler
    String title = _lockStage == 1 ? "SİSMİK KİLİT (KATMAN 1)" : "ÇEKİRDEK KİLİDİ (KATMAN 2)";
    String desc = _lockStage == 1 
      ? "Mağara girişi mühürlü. Kırıcı iğneyi YEŞİL ALAN içindeyken durdur." 
      : "DİKKAT! Kilit mekanizması hızlandı! İkinci katmanı kırmak için iğneyi yakala.";
    Color stageColor = _lockStage == 1 ? Colors.redAccent : Colors.deepOrange;

    return MissionCard(
      color: stageColor, 
      header: title, 
      story: desc,
      content: Column(children: [
          // LayoutBuilder ile responsive genişlik
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black, 
                  borderRadius: BorderRadius.circular(20), 
                  border: Border.all(color: Colors.grey.shade800)
                ),
                child: Stack(
                  children: [
                    // Hedef Alan (Dinamik Pozisyon)
                    Positioned(
                      left: constraints.maxWidth * _targetStart, 
                      width: constraints.maxWidth * _targetWidth, 
                      top: 0, bottom: 0, 
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [BoxShadow(color: Colors.green, blurRadius: 10)]
                        ),
                      )
                    ),
                    // İğne (Beyaz)
                    Positioned(
                      left: (constraints.maxWidth - 5) * _drillProgress, // -5 iğne kalınlığı
                      child: Container(
                        width: 5, height: 40, 
                        decoration: const BoxDecoration(
                          color: Colors.white, 
                          boxShadow: [BoxShadow(color: Colors.white, blurRadius: 5)]
                        )
                      )
                    )
                  ],
                ),
              );
            }
          ),
          const SizedBox(height: 10),
          // Zorluk Göstergesi
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("HIZ: ${_lockStage == 1 ? 'NORMAL' : 'KRİTİK'}", style: TextStyle(color: _lockStage == 1 ? Colors.grey : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
            Text("HEDEF: %${(_targetWidth * 100).toInt()}", style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ]),
          const SizedBox(height: 30),
          
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: stageColor, 
              padding: const EdgeInsets.symmetric(vertical: 20),
              elevation: 10,
              shadowColor: stageColor
            ),
            onPressed: () => _handleLockBreak(),
            child: Text(
              _lockStage == 1 ? "KİLİDİ KIR" : "ÇEKİRDEĞİ DEL", 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)
            )
          ))
      ]),
    );
  }

  void _handleLockBreak() {
    // Zamanlayıcıyı durdur
    _drillTimer?.cancel();
    _drillTimer = null;
    setState(() => _drillMoving = false);
    
    // Hedef Kontrolü
    // İğne (Progress) hedef aralığında mı?
    // Not: Progress iğnenin sol kenarıdır. Biraz tolerans eklenebilir ama basit tutalım.
    bool hit = _drillProgress >= _targetStart && _drillProgress <= (_targetStart + _targetWidth);

    if (hit) {
      if (_lockStage == 1) {
        // AŞAMA 1 BAŞARILI -> AŞAMA 2'ye GEÇİŞ
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("DIŞ KABUK KIRILDI! ÇEKİRDEK KORUMASI DEVREDE!"), backgroundColor: Colors.orange, duration: Duration(seconds: 1)));
        
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;
          setState(() {
            _lockStage = 2;
            _drillProgress = 0.0; // Başa al
            _drillMoving = true;
            _drillDirection = 1;
            
            // ZORLUK ARTIRMA
            _drillSpeed = 0.035; // Daha hızlı (0.02 idi)
            
            // Hedefi küçült ve rastgele bir yere koy
            // Hedef genişliği %15 (0.15) olsun.
            // Başlangıç noktası 0.10 ile 0.75 arasında rastgele olabilir.
            _targetWidth = 0.15;
            _targetStart = 0.10 + (math.Random().nextDouble() * 0.65); 
          });
        });

      } else {
        // AŞAMA 2 BAŞARILI -> BÖLÜM BİTER
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("KİLİT TAMAMEN KIRILDI! MAĞARA AÇILIYOR..."), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
        Future.delayed(const Duration(seconds: 1), () { if(mounted) _nextStage(); });
      }
    } else {
      // BAŞARISIZ
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ISKA! MATKAP UCU KAYDI."), backgroundColor: Colors.red, duration: Duration(milliseconds: 800)));
      
      Future.delayed(const Duration(milliseconds: 900), () { 
        if(mounted) {
          setState(() { 
            // Aynı aşamayı tekrar başlat
            _drillProgress = 0.0; 
            _drillMoving = true; 
            _drillTimer = null; 
            _drillDirection = 1;
          }); 
        }
      }); 
    }
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

class MapPieceWidget extends StatelessWidget {
  final int index;
  const MapPieceWidget({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/map_pieces/piece_${index + 1}.png';
    return Image.asset(imagePath, fit: BoxFit.fill, filterQuality: FilterQuality.high, errorBuilder: (context, error, stackTrace) {
        return Container(color: Colors.blueGrey.withValues(alpha: 0.2), child: Center(child: Text("${index + 1}", style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 20))));
      },
    );
  }
}