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
  Question? _currentCardQuestion;
  final Color _themeColor = const Color(0xFF2979FF); 

  // --- PUZZLE 1: BASINÇ DEĞİŞKENLERİ ---
  int _currentPressure = 0;
  final int _targetPressure = 100;

  // --- PUZZLE 2: HARİTA (Map Puzzle) DEĞİŞKENLERİ ---
  // 0: Boş/Yerleşmedi, 1: Yerleşti
  List<int> _mapPiecesStatus = List.generate(9, (index) => 0);
  // Kullanılabilir (henüz yerleşmemiş) parçaların listesi
  List<int> _availablePieces = [0, 1, 2, 3, 4, 5, 6, 7, 8];

  // --- PUZZLE 3: REFLEKS (Matkap) DEĞİŞKENLERİ ---
  double _drillProgress = 0.0;
  bool _drillMoving = true;
  Timer? _drillTimer;

  @override
  void initState() {
    super.initState();
    _availablePieces.shuffle(); // Parçaları başlangıçta karıştır
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
      // Inputları temizle
      _cardInputCtrl.clear();
      _currentCardQuestion = null;
      
      // Basınç Reset
      _currentPressure = 0;
      
      // Harita Reset
      _mapPiecesStatus = List.generate(9, (index) => 0);
      _availablePieces = [0, 1, 2, 3, 4, 5, 6, 7, 8];
      _availablePieces.shuffle();

      // Refleks Reset
      _drillProgress = 0.0;
      _drillMoving = true;
    });
    if (_stage > 8) _showVictory();
  }

  // --- HİKAYE FİNALİ ---
  void _showVictory() {
    GameData.unlockNextLevel(3);

    showFullStoryDialog(
      context: context,
      color: Colors.blueAccent,
      title: "DERİNLİK: -4000M",
      logCode: "UNKNOWN_REGION",
      storyText: "\"Parçalar birleştiğinde gördüğümüz şeye inanamadık. Koordinatlar okyanusu gösteriyor olmalıydı ama harita orada devasa bir kara parçasını işaret ediyor.\n\nBurası haritalarda yok. Uydular burayı 'su' olarak görüyor. Sanki biri... veya bir şey burayı bilerek gizlemiş.\n\nO yaratıklar. Onlar uzaylı değil. Onlar hep buradaydı. Bu gizli kıtada.\"",
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
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500), 
        child: KeyedSubtree(key: ValueKey(_stage), child: _buildContent())
      ),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      case 1: return _buildStoryPage();
      case 2: return _buildPuzzlePressure(); 
      case 3: return _buildRiddle('l3_r1_header', 'l3_r1_story', 'l3_r1_opt1', 'l3_r1_opt2', 'l3_r1_opt3', 'l3_r1_opt4', 1);
      case 4: return _buildCardStep();
      case 5: return _buildMapPuzzle(); // GÜNCELLENMİŞ HARİTA PUZZLE
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

  // --- PUZZLE 1: BASINÇ ---
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

  // --- PUZZLE 2: HARİTA BİRLEŞTİRME (RESİMLİ & BOŞLUKSUZ) ---
  Widget _buildMapPuzzle() {
    bool isCompleted = !_mapPiecesStatus.contains(0);

    return MissionCard(
      color: Colors.tealAccent,
      header: "KAYIP KOORDİNAT",
      story: "Yırtık parçalar, okyanusun ortasında bilinmeyen bir kara parçasını gösteriyor. Parçaları sürükle ve boşluk kalmayacak şekilde birleştir.",
      content: Column(
        children: [
          // --- HARİTA ALANI (DROP ZONE) ---
          Center(
            child: Container(
              height: 303, // 300px resim + 3px sınır payı
              width: 303,
              decoration: BoxDecoration(
                border: Border.all(color: isCompleted ? Colors.green : Colors.grey.withOpacity(0.5), width: 1.5),
                color: const Color(0xFF1a1a1a),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero, // İç boşlukları sıfırla
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0, // Dikey boşluk yok
                  crossAxisSpacing: 0, // Yatay boşluk yok
                  childAspectRatio: 1.0, // Tam kare
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return DragTarget<int>(
                    onWillAcceptWithDetails: (data) => _mapPiecesStatus[index] == 0,
                    onAcceptWithDetails: (data) {
                      if (data == index) {
                        setState(() {
                          _mapPiecesStatus[index] = 1;
                          _availablePieces.remove(data);
                        });
                      } else {
                        _showError("Parça buraya uymuyor!");
                      }
                    },
                    builder: (context, candidates, rejected) {
                      bool isPlaced = _mapPiecesStatus[index] == 1;
                      
                      // PARÇA YERLEŞTİYSE:
                      if (isPlaced) {
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: MapPieceWidget(index: index), // Kenarlık yok, sadece resim
                        );
                      }
                      
                      // PARÇA YERLEŞMEDİYSE (BOŞ SLOT):
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white12, width: 0.5), // Çok silik kılavuz
                          color: candidates.isNotEmpty ? Colors.white10 : Colors.transparent,
                        ),
                        child: Center(
                          child: Text("${index + 1}", style: TextStyle(color: Colors.white.withOpacity(0.1)))
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          const Text("PARÇALARI SÜRÜKLE", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 10),
          
          // --- PARÇALAR (DRAGGABLE) ---
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
                  child: SizedBox(
                    width: 90, height: 90, // Sürüklenirken görünen boyut
                    child: MapPieceWidget(index: pieceIndex),
                  ),
                ),
                childWhenDragging: Container(width: 80, height: 80, color: Colors.white10),
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.3)),
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
                backgroundColor: isCompleted ? Colors.green : Colors.grey,
                disabledBackgroundColor: Colors.grey.shade800
              ), 
              onPressed: isCompleted ? _nextStage : null, 
              child: const Text("KOORDİNATI DOĞRULA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
            )
          )
        ],
      ),
    );
  }

  // --- PUZZLE 3: REFLEKS ---
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

  // --- GENEL HİKAYE/RIDDLE ---
  Widget _buildRiddle(String h, String s, String o1, String o2, String o3, String o4, int c) {
    List<String> opts = [o1, o2, o3, o4];
    return MissionCard(color: Colors.purpleAccent, header: AppTexts.get(h, widget.language), story: AppTexts.get(s, widget.language), content: Column(children: List.generate(4, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, side: const BorderSide(color: Colors.purpleAccent), padding: const EdgeInsets.all(15)), onPressed: () => i == c ? _nextStage() : _showError("Hatalı Seçim"), child: Text(AppTexts.get(opts[i], widget.language), style: const TextStyle(color: Colors.white))))))));
  }

  // --- KART TARAMA ---
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

// --- HARİTA PARÇASI WIDGET'I ---
class MapPieceWidget extends StatelessWidget {
  final int index;
  
  const MapPieceWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // Assets: piece_1.png ... piece_9.png
    String imagePath = 'assets/map_pieces/piece_${index + 1}.png';

    return Image.asset(
      imagePath,
      fit: BoxFit.fill, // Resimleri kutuya tam yayar (boşluk kalmaz)
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.red.withOpacity(0.3),
          child: const Center(child: Icon(Icons.broken_image, color: Colors.red)),
        );
      },
    );
  }
}