import 'package:flutter/material.dart';
import '../widgets/triverse_ui.dart';

// --- ANA LEVEL 1 CLASSI ---
class Level1 extends StatefulWidget {
  const Level1({super.key});

  @override
  State<Level1> createState() => _Level1State();
}

class _Level1State extends State<Level1> {
  int currentLevel = 1;

  // HİKAYE VERİLERİ
  final Map<int, Map<String, dynamic>> levelData = {
    1: {
      "title": "KRİYO TÜPLERİ",
      "story": "Sistem uyarısı: Soğutma sıvısı sızıyor. Vanaları kapatıp basıncı dengelemezsen örnekler çözülecek.",
      "task": "Basıncı dengelemek için vanayı doğru açıya getir.",
    },
    2: {
      "title": "DONMUŞ DOKU",
      "story": "Buzun içinde tanımlanamayan bir organik kütle var. DNA tarayıcısı hata veriyor: 'EŞLEŞME BULUNAMADI'. Bu dünya dışı değil ama dünyadaki hiçbir familyaya da ait değil.",
      "task": "Örnek numarasındaki eksik haneyi gir: X-9?2",
      "answer": "7", 
    },
    3: {
      "title": "HAYALET KOORDİNATLAR",
      "story": "Navigasyon sistemi çöktü. Cihazımız [82°S, 150°E] gösteriyor ama haritalarda burası okyanus olmalı. Elimizde sadece parçalanmış eski bir harita var.",
      "task": "Harita parçalarını birleştir ve konumunu doğrula.",
    }
  };

  void checkAnswer(String input) {
    if (input == levelData[2]!['answer']) {
      setState(() {
        currentLevel = 3;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Hatalı Veri Girişi!"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = levelData[currentLevel]!;

    return TriverseScaffold(
      title: data['title'],
      levelName: "ZONE 3 - SEVİYE $currentLevel",
      themeColor: Colors.cyanAccent,
      child: Column(
        children: [
          MissionCard(
            header: "GÖREV GÜNCESİ",
            story: data['story'],
            color: Colors.cyanAccent,
            content: Text(
              data['task'],
              style: const TextStyle(color: Colors.white70, fontFamily: 'Courier'),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Center(
              child: _buildLevelContent(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLevelContent() {
    if (currentLevel == 1) {
      return SimpleValve(
        onUnlock: () {
          setState(() => currentLevel = 2);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Basınç Dengelendi."), backgroundColor: Colors.green),
          );
        },
      );
    } else if (currentLevel == 2) {
      return _buildLevel2Input();
    } else if (currentLevel == 3) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          side: const BorderSide(color: Colors.cyanAccent),
        ),
        icon: const Icon(Icons.map, color: Colors.cyanAccent),
        label: const Text("HARİTA ONARIMINI BAŞLAT >", style: TextStyle(color: Colors.white, fontFamily: 'Courier')),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TornMapPuzzle(
              onPuzzleSolved: () {
                Navigator.pop(context);
                showFullStoryDialog(
                  context: context,
                  title: "SEKTÖR NULL",
                  logCode: "ERR-404",
                  storyText: "Harita tamamlandı... Burası dünyadaki hiçbir kayıtta yok. Bilinmeyen bir kıtadasınız.",
                  color: Colors.redAccent,
                  onContinue: () {}, // Buraya sonraki seviye kodu gelecek
                );
              },
            )),
          );
        },
      );
    }
    return const SizedBox();
  }

  Widget _buildLevel2Input() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: 20),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "?",
          hintStyle: TextStyle(color: Colors.white24),
          border: InputBorder.none,
        ),
        onSubmitted: checkAnswer,
      ),
    );
  }
}

// --- CLASS 2: BASİT VANA BULMACASI ---
class SimpleValve extends StatefulWidget {
  final VoidCallback onUnlock;
  const SimpleValve({super.key, required this.onUnlock});

  @override
  State<SimpleValve> createState() => _SimpleValveState();
}

class _SimpleValveState extends State<SimpleValve> {
  double turns = 0.0;
  bool isCorrect = false;

  void _rotateValve() {
    if (isCorrect) return;
    setState(() {
      turns += 0.25;
      if (turns % 1.0 == 0) {
        isCorrect = true;
        Future.delayed(const Duration(milliseconds: 500), widget.onUnlock);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _rotateValve,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedRotation(
            turns: turns,
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.1),
                border: Border.all(color: isCorrect ? Colors.greenAccent : Colors.redAccent, width: 4),
                boxShadow: [
                  BoxShadow(color: isCorrect ? Colors.greenAccent.withOpacity(0.4) : Colors.redAccent.withOpacity(0.2), blurRadius: 30, spreadRadius: 5)
                ]
              ),
              child: Icon(Icons.settings, size: 80, color: isCorrect ? Colors.green : Colors.red),
            ),
          ),
          const SizedBox(height: 20),
          Text(isCorrect ? "BASINÇ NORMAL" : "VANAYI ÇEVİR", style: TextStyle(color: isCorrect ? Colors.greenAccent : Colors.redAccent, fontFamily: 'Courier', fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

// --- CLASS 3: YIRTIK HARİTA OYUNU ---
const Color kIceDark = Color(0xFF051015);
const Color kIceCyan = Colors.cyanAccent;
const Color kIceError = Colors.redAccent;

class TornMapPuzzle extends StatefulWidget {
  final VoidCallback onPuzzleSolved;
  const TornMapPuzzle({super.key, required this.onPuzzleSolved});

  @override
  _TornMapPuzzleState createState() => _TornMapPuzzleState();
}

class _TornMapPuzzleState extends State<TornMapPuzzle> {
  late List<int> loosePieces;
  List<int?> gridState = List.filled(9, null);
  bool isGameFinished = false;

  @override
  void initState() {
    super.initState();
    loosePieces = List.generate(9, (index) => index);
    loosePieces.shuffle();
    WidgetsBinding.instance.addPostFrameCallback((_) { _showIntroDialog(); });
  }

  void _showIntroDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: kIceDark.withOpacity(0.95),
        shape: RoundedRectangleBorder(side: const BorderSide(color: kIceError), borderRadius: BorderRadius.circular(15)),
        title: const Row(children: [Icon(Icons.warning_amber_rounded, color: kIceError), SizedBox(width: 10), Text("SİSTEM HATASI", style: TextStyle(color: kIceError, fontFamily: 'Courier'))]),
        content: const Text("Navigasyon cihazı sustu. Eski harita parçalarını birleştirmen lazım.", style: TextStyle(color: Colors.white70)),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("BAŞLA >", style: TextStyle(color: kIceCyan)))],
      ),
    );
  }

  void _checkWinCondition() {
    bool allCorrect = true;
    for (int i = 0; i < 9; i++) {
      if (gridState[i] != i) { allCorrect = false; break; }
    }
    if (allCorrect) {
      setState(() => isGameFinished = true);
      Future.delayed(const Duration(milliseconds: 500), widget.onPuzzleSolved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text("MANUEL HARİTA ONARIMI", style: TextStyle(color: Colors.white54, fontFamily: 'Courier'))),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                width: 300, height: 300, padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(color: isGameFinished ? kIceCyan : Colors.white24, width: 2), borderRadius: BorderRadius.circular(10)),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return DragTarget<int>(
                      onWillAccept: (data) => gridState[index] == null,
                      onAccept: (data) {
                        setState(() { gridState[index] = data; loosePieces.remove(data); });
                        _checkWinCondition();
                      },
                      builder: (context, candidateData, rejectedData) {
                        if (gridState[index] != null) return MapTile(index: gridState[index]!, isLocked: true);
                        return Container(decoration: BoxDecoration(color: candidateData.isNotEmpty ? Colors.white10 : Colors.transparent, border: Border.all(color: Colors.white10)), child: const Icon(Icons.add, color: Colors.white10, size: 10));
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const Divider(color: Colors.white10),
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF0A0A0A), padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 15, runSpacing: 15, alignment: WrapAlignment.center,
                children: loosePieces.map((pieceIndex) {
                  return Draggable<int>(
                    data: pieceIndex,
                    feedback: Material(color: Colors.transparent, child: SizedBox(width: 80, height: 80, child: MapTile(index: pieceIndex, isLocked: false))),
                    childWhenDragging: Opacity(opacity: 0.3, child: SizedBox(width: 80, height: 80, child: MapTile(index: pieceIndex, isLocked: false))),
                    child: SizedBox(width: 80, height: 80, child: MapTile(index: pieceIndex, isLocked: false)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapTile extends StatelessWidget {
  final int index;
  final bool isLocked;
  const MapTile({super.key, required this.index, this.isLocked = false});

  @override
  Widget build(BuildContext context) {
    int row = index ~/ 3; int col = index % 3;
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF0F172A), border: Border.all(color: isLocked ? kIceCyan.withOpacity(0.5) : Colors.white24), borderRadius: BorderRadius.circular(4)),
      child: ClipRect(child: CustomPaint(painter: MapFragmentPainter(row, col))),
    );
  }
}

class MapFragmentPainter extends CustomPainter {
  final int row;
  final int col;
  MapFragmentPainter(this.row, this.col);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-col * size.width, -row * size.height);
    final totalSize = Size(size.width * 3, size.height * 3);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 3.0..color = kIceCyan;
    final fillPaint = Paint()..style = PaintingStyle.fill..color = kIceCyan.withOpacity(0.2);

    Path coastLine = Path();
    coastLine.moveTo(totalSize.width * 0.2, 0);
    coastLine.quadraticBezierTo(totalSize.width * 0.5, totalSize.height * 0.3, totalSize.width * 0.8, totalSize.height * 0.2);
    coastLine.quadraticBezierTo(totalSize.width * 0.9, totalSize.height * 0.6, totalSize.width * 0.5, totalSize.height * 0.8);
    coastLine.lineTo(totalSize.width * 0.2, totalSize.height * 0.9);
    coastLine.close();

    canvas.drawPath(coastLine, fillPaint);
    canvas.drawPath(coastLine, paint);

    final center = Offset(totalSize.width * 0.6, totalSize.height * 0.5);
    final xPaint = Paint()..color = Colors.redAccent ..strokeWidth = 5 ..style = PaintingStyle.stroke;
    canvas.drawLine(center - const Offset(20, 20), center + const Offset(20, 20), xPaint);
    canvas.drawLine(center - const Offset(-20, 20), center + const Offset(-20, 20), xPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}