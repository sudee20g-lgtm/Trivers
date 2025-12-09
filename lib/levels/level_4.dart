import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/app_texts.dart';
import '../utils/game_data.dart';
import '../widgets/triverse_ui.dart';

class Level4 extends StatefulWidget {
  final String language;
  const Level4({super.key, required this.language});

  @override
  State<Level4> createState() => _Level4State();
}

class _Level4State extends State<Level4> {
  int _stage = 1;
  
  // Tema Rengi: Tehlike Kırmızısı
  final Color _themeColor = const Color(0xFFFF2B2B); 

  // PUZZLE 1: SİNİR AĞI (SWITCHES)
  final List<bool> _switches = [false, false, false, false, false];
  
  // PUZZLE 3: KAÇIŞ ŞİFRESİ (KEYPAD)
  String _inputCode = "";
  final String _correctCode = "2084"; // Intro'daki yıl

  void _nextStage() {
    setState(() {
      _stage++;
      _inputCode = ""; // Kod girişini temizle
    });
    
    // Oyun sonu kontrolü
    if (_stage > 6) {
      _showPhaseVictory();
    }
  }

  // --- FAZ I FİNALİ VE FAZ II'YE GEÇİŞ ---
  void _showPhaseVictory() {
    GameData.unlockNextLevel(4); // Level 5 (Okyanus) açılır

    showFullStoryDialog(
      context: context,
      color: Colors.deepOrangeAccent,
      title: "KIL PAYI KURTULUŞ",
      logCode: "CRITICAL_EJECTION",
      storyText: "\"Kapsül fırlatıldı! Arkamızda devasa bir gümbürtü... Buz mağarası, o uyanan devasa şeyin ağırlığıyla çöktü.\n\nŞu an serbest düşüşteyiz. Buzun içinden geçtik, karanlık suya düştük. Derinlik göstergesi hızla artıyor: -500m... -1000m...\n\nKurtulduk sanıyordum. Ama sonar ekranına bakınca kanım dondu. Aşağıda, karanlığın içinde bizi bekleyen binlerce sinyal var.\n\nHOŞ GELDİNİZ: FAZ II - OKYANUS.\"",
      onContinue: () {
        Navigator.pop(context); // Dialog kapanır
        Navigator.pop(context); // Ana menüye döner
      },
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.red.shade900,
      duration: const Duration(milliseconds: 1000),
    ));
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.greenAccent,
      duration: const Duration(milliseconds: 1000),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: "FAZ I: FİNAL",
      levelName: AppTexts.get('l4_title', widget.language),
      themeColor: _themeColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: KeyedSubtree(
          key: ValueKey(_stage),
          child: SingleChildScrollView(child: _buildContent()),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_stage) {
      case 1: return _buildStory1();
      case 2: return _buildPuzzleNerveNetwork();
      case 3: return _buildStory2();
      case 4: return _buildPuzzleHeartbeat();
      case 5: return _buildStory3();
      case 6: return _buildPuzzleEscapePod();
      default: return const Center(child: CircularProgressIndicator(color: Colors.red));
    }
  }

  // ------------------------------------------------------------------------
  // HİKAYE BÖLÜMLERİ
  // ------------------------------------------------------------------------
  
  Widget _buildStory1() {
    return Column(
      children: [
        SystemLogCard(
          logId: "CORE-ENTRY-001",
          story: "Haritadaki koordinata ulaştık. Burası... burası bir mağara değil. Bu, biyolojik bir yapı. Duvarlar nefes alıyor.\n\nSıcaklık +35 derece. Buzun altında bir sera etkisi var. İleride devasa bir kapı var ama organik bir maddeyle mühürlenmiş. Sinir ağlarını tetikleyerek kapıyı açmamız lazım.",
          task: "SİNİR UÇLARINI AKTİVE ET VE KAPIYI AÇ.",
          color: _themeColor,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity, 
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              // DÜZELTME: withValues kullanıldı
              backgroundColor: _themeColor.withValues(alpha: 0.2), 
              side: BorderSide(color: _themeColor),
              padding: const EdgeInsets.symmetric(vertical: 15)
            ),
            onPressed: _nextStage,
            child: const Text("BAĞLANTIYI BAŞLAT >>>", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
          )
        ),
      ],
    );
  }

  Widget _buildStory2() {
    return Column(
      children: [
        const SystemLogCard(
          logId: "ENTITY-DISCOVERY",
          story: "Tanrım... Haritada gördüğümüz o 'kara parçası' toprak değilmiş. O, Yaratığın kendisiymiş.\n\nBuzulun altında uyuyan kilometrelerce uzunluğunda tek bir organizma. Ve biz tam göğüs kafesinin üzerindeyiz. Aşağıdaki o devasa kırmızı ışık... O kalbi. Atışları yavaşlıyor. Uyanıyor.",
          task: "KALP RİTMİNİ SENKRONİZE ET VE VERİ AL.",
          color: Colors.orangeAccent,
        ),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(
          // DÜZELTME: withValues kullanıldı
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent.withValues(alpha: 0.2), side: const BorderSide(color: Colors.orangeAccent)),
          onPressed: _nextStage,
          child: const Text(">>>", style: TextStyle(color: Colors.white, fontSize: 20))
        )),
      ],
    );
  }

  Widget _buildStory3() {
    return Column(
      children: [
        const SystemLogCard(
          logId: "CRITICAL-COLLAPSE",
          story: "HATA! Analiz, savunma sistemini tetikledi! Mağara çöküyor! Buz tavanı üzerimize iniyor!\n\nTek çıkış yolu, aşağıdaki su kanalına bakan acil durum kapsülü. Ama fırlatma protokolü şifreli. Yıl... Her şeyin başladığı yıl... O tarihi girmezsek buradan sağ çıkamayız!",
          task: "FIRLATMA KODUNU GİR (İPUCU: INTRO - YIL)",
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(
          // DÜZELTME: withValues kullanıldı
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withValues(alpha: 0.2), side: const BorderSide(color: Colors.red)),
          onPressed: _nextStage,
          child: const Text("KAPSÜLE GİR >>>", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
        )),
      ],
    );
  }

  // ------------------------------------------------------------------------
  // BULMACA 1: SİNİR AĞI (SWITCH PUZZLE)
  // ------------------------------------------------------------------------
  Widget _buildPuzzleNerveNetwork() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(color: _themeColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const Text("SİNİR AĞI PROTOKOLÜ", style: TextStyle(color: Colors.white70, fontFamily: 'Courier')),
              const SizedBox(height: 10),
              const Text("Tüm düğümleri aktif hale getir. Dikkat: Bazı düğümler diğerlerini tersine çevirir.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => _toggleSwitch(index),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _switches[index] ? _themeColor : Colors.grey[900],
                            boxShadow: _switches[index] ? [BoxShadow(color: _themeColor, blurRadius: 15)] : [],
                            border: Border.all(color: _switches[index] ? Colors.white : Colors.grey)
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text("${index+1}", style: const TextStyle(color: Colors.white30))
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _toggleSwitch(int index) {
    setState(() {
      _switches[index] = !_switches[index];
      // Mantık: Her anahtar yanındakini de etkiler (Zorluk için)
      if (index > 0) _switches[index - 1] = !_switches[index - 1];
      if (index < 4) _switches[index + 1] = !_switches[index + 1];
    });

    if (_switches.every((s) => s == true)) {
      _showSuccess("ORGANİK KİLİT AÇILDI");
      Future.delayed(const Duration(seconds: 1), _nextStage);
    }
  }

  // ------------------------------------------------------------------------
  // BULMACA 2: KALP RİTMİ (RHYTHM GAME)
  // ------------------------------------------------------------------------
  Widget _buildPuzzleHeartbeat() {
    return HeartbeatGame(
      onSuccess: () {
        _showSuccess("SENKRONİZASYON TAMAMLANDI");
        Future.delayed(const Duration(seconds: 1), _nextStage);
      },
      onFail: () {
        _showError("RİTİM BOZULDU! TEKRAR DENE.");
      },
    );
  }

  // ------------------------------------------------------------------------
  // BULMACA 3: KAÇIŞ KODU (KEYPAD)
  // ------------------------------------------------------------------------
  Widget _buildPuzzleEscapePod() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
            // DÜZELTME: withValues kullanıldı
            boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.3), blurRadius: 20)]
          ),
          child: Column(
            children: [
              const Text("ACİL DURUM FIRLATMA", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                color: Colors.grey[900],
                child: Text(
                  _inputCode.padRight(4, '_').split('').join(' '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontFamily: 'Courier', letterSpacing: 5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // Numara Paneli
        Wrap(
          spacing: 15, runSpacing: 15, alignment: WrapAlignment.center,
          children: List.generate(10, (index) {
            // Tuş düzeni: 1-9, sonra 0
            int number = (index + 1) % 10; 
            if (index == 9) number = 0; // Son tuş 0 olsun
            
            return SizedBox(
              width: 80, height: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.white24))
                ),
                onPressed: () => _onKeyPadTap(number.toString()),
                child: Text("$number", style: const TextStyle(fontSize: 24, color: Colors.white)),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => setState(() => _inputCode = ""),
              icon: const Icon(Icons.clear), label: const Text("TEMİZLE"),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _checkCode,
              icon: const Icon(Icons.check), label: const Text("BAŞLAT"),
            ),
          ],
        )
      ],
    );
  }

  void _onKeyPadTap(String num) {
    if (_inputCode.length < 4) {
      setState(() {
        _inputCode += num;
      });
    }
  }

  void _checkCode() {
    if (_inputCode == _correctCode) {
      _nextStage();
    } else {
      _showError("HATALI KOD! SİSTEM KİLİTLİ.");
      setState(() => _inputCode = "");
    }
  }
}

// ------------------------------------------------------------------------
// YARDIMCI WIDGETLAR (LEVEL 4'e ÖZEL)
// ------------------------------------------------------------------------

// KALP RİTMİ OYUNU
class HeartbeatGame extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onFail;
  const HeartbeatGame({super.key, required this.onSuccess, required this.onFail});

  @override
  State<HeartbeatGame> createState() => _HeartbeatGameState();
}

class _HeartbeatGameState extends State<HeartbeatGame> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  int _successCount = 0;
  final int _targetSuccess = 3;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Animasyon değeri 0.8 ile 1.0 arasındaysa (Kalp en büyükken/kasılmışken)
    if (_animCtrl.value > 0.8) {
      setState(() {
        _successCount++;
      });
      if (_successCount >= _targetSuccess) {
        widget.onSuccess();
      }
    } else {
      widget.onFail();
      setState(() {
        _successCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _animCtrl,
            builder: (ctx, child) {
              bool isTargetZone = _animCtrl.value > 0.8;
              return Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  // DÜZELTME: withValues kullanıldı
                  border: Border.all(color: isTargetZone ? Colors.greenAccent : Colors.red.withValues(alpha: 0.5), width: 2)
                ),
                child: Center(
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isTargetZone ? Colors.red : Colors.red[900],
                        boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: isTargetZone ? 30 : 10, spreadRadius: 5)]
                      ),
                      child: const Icon(Icons.favorite, size: 50, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Text("$_successCount / $_targetSuccess", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("KALP BÜYÜDÜĞÜNDE DOKUN!", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// SYSTEM LOG CARD
class SystemLogCard extends StatelessWidget {
  final String logId;
  final String story;
  final String task;
  final Color color;

  const SystemLogCard({super.key, required this.logId, required this.story, required this.task, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF080808),
        border: Border(left: BorderSide(color: color, width: 4), top: const BorderSide(color: Colors.white10), right: const BorderSide(color: Colors.white10), bottom: const BorderSide(color: Colors.white10)),
        // DÜZELTME: withValues kullanıldı
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 10, offset: const Offset(0, 5))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DÜZELTME: withValues kullanıldı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8), color: Colors.white.withValues(alpha: 0.05),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [Icon(Icons.terminal, color: color, size: 16), const SizedBox(width: 8), Text("LOG // $logId", style: TextStyle(color: color, fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 12))]),
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle))
            ]),
          ),
          Padding(padding: const EdgeInsets.all(15), child: Text(story, style: const TextStyle(color: Color(0xFFCCCCCC), fontFamily: 'Courier', fontSize: 14, height: 1.4))),
          // DÜZELTME: withValues kullanıldı
          Container(
            width: double.infinity, padding: const EdgeInsets.all(12), color: color.withValues(alpha: 0.1),
            child: Row(children: [Icon(Icons.warning_amber_rounded, color: color, size: 16), const SizedBox(width: 8), Expanded(child: Text(task, style: TextStyle(color: color, fontFamily: 'Courier', fontWeight: FontWeight.w900, fontSize: 13)))]),
          )
        ],
      ),
    );
  }
}