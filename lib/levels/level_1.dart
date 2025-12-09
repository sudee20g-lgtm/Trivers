import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilter için
import 'dart:math' as math; // Matematik işlemleri için
import 'dart:async'; // Timer ve Future için
import '../widgets/triverse_ui.dart';

// --- ANA LEVEL 1 CLASSI ---
class Level1 extends StatefulWidget {
  const Level1({super.key});

  @override
  State<Level1> createState() => _Level1State();
}

class _Level1State extends State<Level1> {
  int currentLevel = 1;

  // --- HİKAYE VE GÖREV VERİLERİ ---
  final Map<int, Map<String, dynamic>> levelData = {
    1: {
      "title": "HİDROLİK ARIZA",
      "log_id": "SYS-VALVE-ERR",
      "story":
          "İSTASYON DURUMU: KRİTİK.\n\nAna soğutma hattı tıkalı. Vanalar paslanmış ve birbirine mekanik olarak kilitlenmiş durumda. Birini çevirdiğimde dişliler diğerlerini de zorluyor. Basıncı dengelemek için hepsini açık konuma getirmeliyiz.",
      "task": "TÜM VANALARI 'YUKARI' BAKACAK ŞEKİLDE AYARLA.",
    },
    2: {
      "title": "GÜVENLİK KİLİDİ",
      "log_id": "SYS-LOCK-OVERRIDE",
      "story":
          "Vanalar açıldı ama sıvı akışı başlamadı. Güvenlik protokolü devreye girmiş. Manyetik kilitleri manuel olarak 'bypass' etmemiz gerekiyor.\n\nBu riskli bir işlem; kilit mekanizması dönerken enjektörü tam doğru zamanda serbest bırakmalısın.",
      "task": "DÖNEN HALKALAR HİZALANDIĞINDA EKRANA DOKUN VE KİLİDİ AÇ.",
    },
    3: {
      "title": "VEKTÖR ANALİZİ",
      "log_id": "BIO-SCAN-004",
      "story":
          "Soğutma sıvısı akıyor, tüpler stabilize ediliyor... Ancak sensörler tüp #4'te bir anormallik yakaladı. Numune sabit durmuyor, kuantum seviyesinde titreşiyor.\n\nVektör Stabilizasyon Arayüzü (VSI) ile numuneyi dijital bir kafese kıstırman lazım.",
      "task": "TİTREŞİMİ DURDURMAK İÇİN X VE Y EKSENLERİNİ HİZALA.",
    },
    4: {
      "title": "HAYALET SİNYAL",
      "log_id": "NAV-ERR-404",
      "story":
          "Numune analizi biter bitmez navigasyon bilgisayarı çöktü. Uydularla bağlantı koptu. Radarımızda kaynağı belirsiz hayalet sinyaller var.\n\nManuel nirengi (triangulation) yaparak gerçek konumumuzu bulmalısın. Frekansı elle tarayarak sinyalin en güçlü olduğu yönü bul.",
      "task": "RADAR YÖNÜNÜ ÇEVİR VE GİZLİ SİNYALİ TESPİT ET.",
    }
  };

  @override
  Widget build(BuildContext context) {
    final data = levelData[currentLevel]!;

    return TriverseScaffold(
      title: data['title'],
      levelName: "ZONE 3 - SEVİYE $currentLevel",
      themeColor: Colors.cyanAccent,
      child: Column(
        children: [
          // HİKAYE KUTUSU
          SystemLogCard(
            logId: data['log_id'],
            story: data['story'],
            task: data['task'],
            color: Colors.cyanAccent,
          ),
          
          const Spacer(),
          
          // OYUN ALANI
          Expanded(
            flex: 6,
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: _buildLevelContent(),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLevelContent() {
    if (currentLevel == 1) {
      return ConnectedValvesPuzzle(
        onUnlock: () {
          if (!mounted) return;
          setState(() => currentLevel = 2);
          _showSuccessMsg("Vanalar Açıldı. Güvenlik Duvarına Erişiliyor...");
        },
      );
    } else if (currentLevel == 2) {
      return MagneticLockPuzzle(
        onUnlock: () {
          if (!mounted) return;
          setState(() => currentLevel = 3);
          _showSuccessMsg("Kilitler Açıldı. Soğutma Sıvısı Enjekte Ediliyor.");
        },
      );
    } else if (currentLevel == 3) {
      // GÜNCELLENEN VEKTÖR OYUNU (Y EKSENİ UZATILDI)
      return DualFrequencyGame(
        onSuccess: () {
          if (!mounted) return;
          setState(() => currentLevel = 4);
          _showSuccessMsg("Numune Stabilize Edildi. Navigasyon Hatası Alınıyor.");
        },
      );
    } else if (currentLevel == 4) {
      // YENİLENEN RADAR OYUNU (MANUEL TARAMA & BUG FIX)
      return RadarTriangulationGame(
        onSuccess: () {
          if (!mounted) return;
          
          showFullStoryDialog(
            context: context,
            title: "SEKTÖR NULL",
            logCode: "ERR-404",
            storyText:
                "Sinyal kilitlendi. Koordinatlar doğrulandı.\n\nEkranda yanıp sönen nokta... okyanusun ortasını gösteriyor. Ama biz kara üzerindeyiz. Burası dünya haritalarından silinmiş bir bölge. Ya da... hiç var olmamış bir yer.\n\nVe radarın köşesinde beliren o uyarı: 'YAKLAŞAN BÜYÜK KÜTLE TESPİT EDİLDİ.'",
            color: Colors.redAccent,
            onContinue: () {
              if (!mounted) return;
              Navigator.pop(context); // Level 1'den çık
            },
          );
        },
      );
    }
    return const SizedBox();
  }

  void _showSuccessMsg(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green, duration: const Duration(seconds: 2)),
    );
  }
}

// ============================================================================
// YARDIMCI WIDGETLAR (LOG CARD & ESKİ PUZZLELAR)
// ============================================================================

class SystemLogCard extends StatelessWidget {
  final String logId; final String story; final String task; final Color color;
  const SystemLogCard({super.key, required this.logId, required this.story, required this.task, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(color: const Color(0xFF080808), border: Border(left: BorderSide(color: color, width: 4), top: const BorderSide(color: Colors.white10), right: const BorderSide(color: Colors.white10), bottom: const BorderSide(color: Colors.white10)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 10, offset: const Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), color: Colors.white.withValues(alpha: 0.05), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.terminal, color: color, size: 16), const SizedBox(width: 8), Text("LOG // $logId", style: TextStyle(color: color, fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 12))]), Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle))])), Padding(padding: const EdgeInsets.all(15), child: Text(story, style: const TextStyle(color: Color(0xFFCCCCCC), fontFamily: 'Courier', fontSize: 14, height: 1.4))), Container(width: double.infinity, padding: const EdgeInsets.all(12), color: color.withValues(alpha: 0.1), child: Row(children: [Icon(Icons.lock_open, color: color, size: 16), const SizedBox(width: 8), Expanded(child: Text(task, style: TextStyle(color: color, fontFamily: 'Courier', fontWeight: FontWeight.w900, fontSize: 13)))]) )]));
  }
}

class ConnectedValvesPuzzle extends StatefulWidget { final VoidCallback onUnlock; const ConnectedValvesPuzzle({super.key, required this.onUnlock}); @override State<ConnectedValvesPuzzle> createState() => _ConnectedValvesPuzzleState(); }
class _ConnectedValvesPuzzleState extends State<ConnectedValvesPuzzle> { List<int> valveStates = [1, 2, 3]; bool isSolved = false; void _rotateValve(int index) { if (isSolved) return; setState(() { valveStates[index] = (valveStates[index] + 1) % 4; if (index == 0) { valveStates[1] = (valveStates[1] + 1) % 4; } else if (index == 1) { valveStates[0] = (valveStates[0] + 1) % 4; valveStates[2] = (valveStates[2] + 1) % 4; } else if (index == 2) { valveStates[1] = (valveStates[1] + 1) % 4; } if (valveStates[0] == 0 && valveStates[1] == 0 && valveStates[2] == 0) { isSolved = true; Future.delayed(const Duration(milliseconds: 600), () { if (mounted) widget.onUnlock(); }); } }); } @override Widget build(BuildContext context) { return Column(mainAxisSize: MainAxisSize.min, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [0, 1, 2].map((i) => _buildValve(i)).toList()), const SizedBox(height: 30), Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: isSolved ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: isSolved ? Colors.greenAccent : Colors.redAccent)), child: Text(isSolved ? "HİDROLİK BASINÇ NORMAL" : "VANALARI SENKRONİZE ET", style: TextStyle(color: isSolved ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold, fontFamily: 'Courier')))]); } Widget _buildValve(int index) { bool isCorrect = valveStates[index] == 0; Color color = isSolved ? Colors.greenAccent : (isCorrect ? Colors.cyanAccent : Colors.redAccent); return GestureDetector(onTap: () => _rotateValve(index), child: AnimatedRotation(turns: valveStates[index] / 4.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutBack, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black54, border: Border.all(color: color, width: 3), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 1)]), child: Stack(alignment: Alignment.center, children: [Icon(Icons.add, size: 60, color: color.withValues(alpha: 0.5)), Positioned(top: 5, child: Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color, blurRadius: 5)])))])))); } }

class MagneticLockPuzzle extends StatefulWidget { final VoidCallback onUnlock; const MagneticLockPuzzle({super.key, required this.onUnlock}); @override State<MagneticLockPuzzle> createState() => _MagneticLockPuzzleState(); }
class _MagneticLockPuzzleState extends State<MagneticLockPuzzle> with SingleTickerProviderStateMixin { late AnimationController _controller; int _currentStage = 1; final int _totalStages = 3; double _targetAngle = 0; double _targetWidth = 0.5; bool _isSuccess = false; String _statusText = "KİLİT MEKANİZMASI BAŞLATILIYOR..."; Color _ringColor = Colors.cyanAccent; @override void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(); _setNewTarget(); } @override void dispose() { _controller.dispose(); super.dispose(); } void _setNewTarget() { setState(() { _targetAngle = math.Random().nextDouble() * 2 * math.pi; if (_currentStage == 1) { _controller.duration = const Duration(milliseconds: 3000); _targetWidth = 0.6; } else if (_currentStage == 2) { _controller.duration = const Duration(milliseconds: 2000); _targetWidth = 0.4; } else { _controller.duration = const Duration(milliseconds: 1200); _targetWidth = 0.25; } _controller.repeat(); }); } void _attemptUnlock() { if (_isSuccess) return; double currentAngle = _controller.value * 2 * math.pi; double diff = (currentAngle - _targetAngle).abs(); if (diff > math.pi) diff = (2 * math.pi) - diff; if (diff < _targetWidth / 2) { if (_currentStage < _totalStages) { setState(() { _currentStage++; _ringColor = Colors.greenAccent; _statusText = "KİLİT $_currentStage/$_totalStages AÇILDI"; }); Future.delayed(const Duration(milliseconds: 400), () { if (mounted) { setState(() { _ringColor = Colors.cyanAccent; _setNewTarget(); }); } }); } else { setState(() { _isSuccess = true; _ringColor = Colors.green; _statusText = "BYPASS TAMAMLANDI"; _controller.stop(); }); Future.delayed(const Duration(seconds: 1), () { if (mounted) widget.onUnlock(); }); } } else { setState(() { _ringColor = Colors.redAccent; _statusText = "HATA! ZAMANLAMA YANLIŞ"; }); Future.delayed(const Duration(milliseconds: 300), () { if (mounted && !_isSuccess) { setState(() { _ringColor = Colors.cyanAccent; _statusText = "TEKRAR DENEYİN..."; }); } }); } } @override Widget build(BuildContext context) { return Column(mainAxisSize: MainAxisSize.min, children: [GestureDetector(onTap: _attemptUnlock, child: Container(width: 260, height: 260, decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle, border: Border.all(color: _ringColor.withValues(alpha: 0.5), width: 8), boxShadow: [BoxShadow(color: _ringColor.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)]), child: Stack(alignment: Alignment.center, children: [CustomPaint(size: const Size(260, 260), painter: LockTargetPainter(angle: _targetAngle, width: _targetWidth, color: Colors.green.withValues(alpha: 0.3))), AnimatedBuilder(animation: _controller, builder: (context, child) { return Transform.rotate(angle: _controller.value * 2 * math.pi, child: Container(width: 260, height: 260, alignment: Alignment.topCenter, child: Container(margin: const EdgeInsets.only(top: 10), width: 15, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 10)])))); }), Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.grey[900], shape: BoxShape.circle, border: Border.all(color: Colors.white12)), child: Center(child: _isSuccess ? const Icon(Icons.lock_open, color: Colors.greenAccent, size: 40) : Text("$_currentStage/$_totalStages", style: TextStyle(color: _ringColor, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Courier'))))]))), const SizedBox(height: 30), Text(_statusText, textAlign: TextAlign.center, style: TextStyle(color: _ringColor, fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 14))]); } }
class LockTargetPainter extends CustomPainter { final double angle; final double width; final Color color; LockTargetPainter({required this.angle, required this.width, required this.color}); @override void paint(Canvas canvas, Size size) { final center = Offset(size.width / 2, size.height / 2); final radius = size.width / 2 - 15; final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 20..strokeCap = StrokeCap.butt; canvas.drawArc(Rect.fromCircle(center: center, radius: radius), angle - (width / 2) - (math.pi / 2), width, false, paint); final borderPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2; canvas.drawArc(Rect.fromCircle(center: center, radius: radius), angle - (width / 2) - (math.pi / 2), width, false, borderPaint); } @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true; }

// ============================================================================
// OYUN 3: VEKTÖR ANALİZİ (GÜNCELLENDİ: UZUN Y EKSENİ - 250px & LINT FIX)
// ============================================================================
class DualFrequencyGame extends StatefulWidget {
  final VoidCallback onSuccess;
  const DualFrequencyGame({super.key, required this.onSuccess});
  @override
  State<DualFrequencyGame> createState() => _DualFrequencyGameState();
}
class _DualFrequencyGameState extends State<DualFrequencyGame> {
  double _valX = 10.0; double _valY = 90.0; 
  final double _targetX = 65.0; final double _targetY = 40.0;
  final double _tolerance = 4.0; 
  bool _isLocked = false;

  @override
  Widget build(BuildContext context) {
    double diffX = (_valX - _targetX).abs(); double diffY = (_valY - _targetY).abs();
    bool fullyAligned = (diffX < _tolerance) && (diffY < _tolerance);
    double blurAmount = (diffX + diffY) / 6.0;
    
    // stateColor değişkeni kullanılmadığı için kaldırıldı.
    
    Color xColor = (diffX < _tolerance) ? Colors.green : Colors.red;
    Color yColor = (diffY < _tolerance) ? Colors.green : Colors.red;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            // EKRAN
            Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.black, border: Border.all(color: fullyAligned ? Colors.greenAccent : Colors.redAccent, width: 2), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: (fullyAligned ? Colors.green : Colors.red).withValues(alpha: 0.2), blurRadius: 20)]),
              child: ClipRRect(borderRadius: BorderRadius.circular(13), child: Stack(alignment: Alignment.center, children: [Opacity(opacity: 0.3, child: Image.asset('assets/images/grid_overlay.png', fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(decoration: BoxDecoration(border: Border.all(color: Colors.white10))))), ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount), child: const Icon(Icons.bug_report, size: 50, color: Colors.cyanAccent)), if (fullyAligned) const Icon(Icons.filter_center_focus, color: Colors.greenAccent, size: 70)]))),
            const SizedBox(width: 20),
            
            // DİKEY SLIDER (GÜNCELLENDİ: DAHA UZUN - 250px)
            Column(
              children: [
                const Text("Y", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)), 
                Container(
                  height: 250, 
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12)
                  ),
                  child: RotatedBox(
                    quarterTurns: 3, 
                    child: Slider(
                      value: _valY, 
                      min: 0, 
                      max: 100, 
                      activeColor: yColor, 
                      onChanged: _isLocked ? null : (v) => setState(() => _valY = v)
                    )
                  ),
                )
              ]
            ),
          ],
        ),
        const SizedBox(height: 20), 
        // YATAY SLIDER
        Padding(padding: const EdgeInsets.only(right: 60), child: Row(children: [const Text("X ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)), Expanded(child: Slider(value: _valX, min: 0, max: 100, activeColor: xColor, onChanged: _isLocked ? null : (v) => setState(() => _valX = v)))])),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: fullyAligned ? Colors.green : Colors.grey[800], padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
          onPressed: fullyAligned && !_isLocked ? () { setState(() => _isLocked = true); widget.onSuccess(); } : null,
          child: Text(fullyAligned ? "STABİLİZASYONU ONAYLA" : "ODAKLAN...", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}

// ============================================================================
// OYUN 4: RADAR NİRENGİ (LINT FIX UYGULANDI)
// ============================================================================
class RadarTriangulationGame extends StatefulWidget {
  final VoidCallback onSuccess;
  const RadarTriangulationGame({super.key, required this.onSuccess});
  @override
  State<RadarTriangulationGame> createState() => _RadarTriangulationGameState();
}

class _RadarTriangulationGameState extends State<RadarTriangulationGame> with SingleTickerProviderStateMixin {
  double _currentAngle = 0.0; // Kullanıcının çevirdiği açı
  late double _targetAngle;   // Rastgele belirlenen hedef açısı
  double _signalStrength = 0.0; // Sinyal doluluk oranı
  bool _isSuccess = false;
  
  // Radar animasyonu için
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // 0 ile 360 derece (2 PI) arasında rastgele bir hedef
    _targetAngle = math.Random().nextDouble() * 2 * math.pi;
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Dokunmatik kontrol (Pan Update)
  void _updateRotation(DragUpdateDetails details, Size size) {
    if (_isSuccess) return;

    // Dokunulan noktanın merkeze göre açısını hesapla
    final dx = details.localPosition.dx - (size.width / 2);
    final dy = details.localPosition.dy - (size.height / 2);
    double angle = math.atan2(dy, dx);
    
    // Açıyı pozitif yap (0 - 2PI arası)
    if (angle < 0) angle += 2 * math.pi;

    setState(() {
      _currentAngle = angle;
      _checkSignal();
    });
  }

  // Sinyal kontrolü
  void _checkSignal() {
    double diff = (_currentAngle - _targetAngle).abs();
    // En kısa mesafeyi bul (Dairesel fark)
    if (diff > math.pi) diff = (2 * math.pi) - diff;

    // Hedefe yakınlık kontrolü (Tolerans: ~20 derece)
    if (diff < 0.35) {
      // Doğru yerdeyse sinyal güçlenir
      _signalStrength += 0.03; 
      if (_signalStrength >= 1.0) {
        _signalStrength = 1.0;
        _completeGame();
      }
    } else {
      // Yanlış yöndeysek sinyal zayıflar
      _signalStrength -= 0.02;
      if (_signalStrength < 0) _signalStrength = 0;
    }
  }

  void _completeGame() {
    if (_isSuccess) return;
    _isSuccess = true;
    _pulseController.stop();
    
    if (mounted) {
      setState(() {}); 
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) widget.onSuccess();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hedefte miyiz? (Görsel geri bildirim için)
    double diff = (_currentAngle - _targetAngle).abs();
    if (diff > math.pi) diff = (2 * math.pi) - diff;
    bool onTarget = diff < 0.35;

    Color radarColor = _isSuccess ? Colors.greenAccent : (onTarget ? Colors.amber : Colors.cyanAccent);

    return Column(
      children: [
        // RADAR ALANI
        GestureDetector(
          onPanUpdate: (details) => _updateRotation(details, const Size(300, 300)),
          child: Container(
            width: 300,
            height: 300,
            color: Colors.transparent, // Dokunmayı algılaması için gerekli
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Dış Çerçeve ve Arka Plan
                Container(
                  width: 300, height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: radarColor.withValues(alpha: 0.5), width: 4),
                    boxShadow: [BoxShadow(color: radarColor.withValues(alpha: 0.2), blurRadius: 20)]
                  ),
                ),

                // 2. Izgara Çizgileri
                CustomPaint(size: const Size(300, 300), painter: RadarGridPainter(color: radarColor)),

                // 3. Hedef Nokta (Sadece yaklaşıldığında veya bitince görünür)
                if (onTarget || _isSuccess)
                  Transform.translate(
                    offset: Offset(
                      100 * math.cos(_targetAngle),
                      100 * math.sin(_targetAngle)
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 25, height: 25,
                      decoration: BoxDecoration(
                        color: _isSuccess ? Colors.green : Colors.redAccent.withValues(alpha: _signalStrength.clamp(0.2, 1.0)),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: _isSuccess ? Colors.green : Colors.red, blurRadius: 15)]
                      ),
                      child: const Icon(Icons.priority_high, size: 15, color: Colors.white),
                    ),
                  ),

                // 4. Dönen Tarayıcı Kolu (Kullanıcı Kontrollü)
                Transform.rotate(
                  angle: _currentAngle,
                  child: Container(
                    width: 300, height: 300,
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 150, height: 2, 
                      decoration: BoxDecoration(
                        color: radarColor,
                        boxShadow: [BoxShadow(color: radarColor, blurRadius: 5)]
                      ),
                    ),
                  ),
                ),
                
                // 5. Tarayıcı Gradyanı (Radar Efekti)
                Transform.rotate(
                  angle: _currentAngle,
                  child: Container(
                    width: 300, height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        center: Alignment.center,
                        startAngle: 3.0, 
                        endAngle: 3.2, 
                        colors: [
                          Colors.transparent,
                          radarColor.withValues(alpha: 0.3),
                          Colors.transparent
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        transform: const GradientRotation(-1.6) 
                      )
                    ),
                  ),
                ),

                // 6. Merkez Göstergesi
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black, 
                    shape: BoxShape.circle, 
                    border: Border.all(color: Colors.white24)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isSuccess ? Icons.lock : (onTarget ? Icons.wifi_tethering : Icons.radar),
                          color: radarColor,
                          size: 30
                        ),
                        Text(
                          _isSuccess ? "100%" : "${(_signalStrength * 100).toInt()}%",
                          style: TextStyle(color: radarColor, fontSize: 12, fontWeight: FontWeight.bold)
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // BİLGİ VE DURUM ÇUBUĞU
        Text(
          _isSuccess ? "SİNYAL KİLİTLENDİ" : (onTarget ? "SİNYAL YAKALANIYOR..." : "FREKANS TARANIYOR"), 
          style: TextStyle(color: radarColor, fontSize: 16, fontFamily: 'Courier', fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 10),
        
        // İlerleme Çubuğu
        Container(
          width: 250, height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white12)
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _signalStrength,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: radarColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [BoxShadow(color: radarColor, blurRadius: 10)]
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text("RADAR KOLUNU ÇEVİREREK SİNYALİ ARA", style: TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}

class RadarGridPainter extends CustomPainter { 
  final Color color; 
  RadarGridPainter({required this.color}); 
  
  @override 
  void paint(Canvas canvas, Size size) { 
    final paint = Paint()..color = color.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 1.0; 
    final center = Offset(size.width / 2, size.height / 2); 
    double radius = size.width / 2; 
    
    // Daireler
    canvas.drawCircle(center, radius, paint); 
    canvas.drawCircle(center, radius * 0.66, paint); 
    canvas.drawCircle(center, radius * 0.33, paint); 
    
    // Çizgiler (Artı şeklinde)
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint); 
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint); 
  } 
  
  @override 
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; 
}