import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/app_styles.dart';
import '../utils/game_data.dart';
import '../widgets/triverse_ui.dart';

class Level2 extends StatefulWidget {
  final String language;
  const Level2({super.key, required this.language});
  @override
  State<Level2> createState() => _Level2State();
}

class _Level2State extends State<Level2> {
  int _stage = 1;
  final List<String> _s1Selection = [];
  final TextEditingController _s3Controller = TextEditingController();
  final Color _themeColor = Colors.greenAccent;

  void _nextStage() {
    if (_stage < 3) {
      setState(() => _stage++);
    } else {
      _showVictory();
    }
  }

  void _showVictory() {
    GameData.unlockNextLevel(2);
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (c) => _victoryPopup());
  }

  Widget _victoryPopup() => Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFF051005),
          border: Border(top: BorderSide(color: _themeColor, width: 3)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.biotech, color: _themeColor, size: 60),
        const SizedBox(height: 10),
        Text(widget.language == 'TR' ? "TÜR TESPİT EDİLDİ" : "SPECIES IDENTIFIED",
           style: AppStyles.titleStyle(_themeColor)),
        const SizedBox(height: 15),
        Text(
            widget.language == 'TR'
                ? "DNA Dünya dışı. Hücreler uyanıyor ve Okyanus tabanına sinyal gönderiyor. Onu takip etmeliyiz."
                : "DNA is extraterrestrial. Cells are waking up and signaling the Ocean floor. We must follow it.",
            textAlign: TextAlign.center,
            style: AppStyles.loreStyle(_themeColor)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _themeColor, padding: const EdgeInsets.all(15)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                widget.language == 'TR' ? "OKYANUSA DAL" : "DIVE TO OCEAN",
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))),
        )
      ]));

  void _error() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppTexts.get('retry', widget.language), style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade900,
        behavior: SnackBarBehavior.floating));
    if (_stage == 1) {
      setState(() => _s1Selection.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TriverseScaffold(
      title: AppTexts.get('l2_title', widget.language),
      levelName: "SECTOR: BIO-LAB",
      themeColor: _themeColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: KeyedSubtree(key: ValueKey(_stage), child: _buildContent()),
      ),
    );
  }

  Widget _buildContent() {
    if (_stage == 1) return _stage1Order();
    if (_stage == 2) return _stage2DNA();
    return _stage3Math();
  }

  // STAGE 1: SIRALAMA
  Widget _stage1Order() {
    return MissionCard(
      color: _themeColor,
      header: "EVOLUTIONARY ANALYSIS",
      story: AppTexts.get('l2_s1_story', widget.language),
      content: Column(
        children: [
          _item("D", AppTexts.get('l2_optD', widget.language)),
          _item("A", AppTexts.get('l2_optA', widget.language)),
          _item("C", AppTexts.get('l2_optC', widget.language)),
          _item("B", AppTexts.get('l2_optB', widget.language)),
          const SizedBox(height: 20),
          _btn(AppTexts.get('check', widget.language), () {
            if (_s1Selection.join() == "DACB") {
              _nextStage();
            } else {
              _error();
            }
          })
        ],
      ),
    );
  }

  Widget _item(String id, String txt) {
    bool sel = _s1Selection.contains(id);
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
            onTap: () => setState(() {
                  if (!sel && _s1Selection.length < 4) {
                    _s1Selection.add(id);
                  }
                }),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: sel ? _themeColor.withValues(alpha: 0.2) : Colors.black,
                    border: Border.all(color: sel ? _themeColor : Colors.white24),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Text(id, style: TextStyle(color: _themeColor, fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(width: 15),
                    Expanded(child: Text(txt, style: const TextStyle(color: Colors.white))),
                    if(sel) Icon(Icons.check, color: _themeColor)
                  ],
                ))));
  }

  // STAGE 2: DNA
  Widget _stage2DNA() {
    return MissionCard(
      color: Colors.tealAccent,
      header: "DNA SEQUENCE MATCHING",
      story: AppTexts.get('l2_s2_story', widget.language),
      footerInfo: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
          const SizedBox(width: 10),
          Expanded(child: Text(
            widget.language == 'TR' ? "UYARI: Örnekte bilinmeyen radyasyon tespit edildi." : "WARNING: Unknown radiation in sample.",
            style: const TextStyle(color: Colors.orange, fontSize: 11, fontFamily: 'Courier'),
          )),
        ],
      ),
      content: Column(
        children: [
          Text(AppTexts.get('l2_s2_q', widget.language),
              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 30),
          _btn(AppTexts.get('l2_s2_opt1', widget.language), () => _error()),
          const SizedBox(height: 10),
          _btn(AppTexts.get('l2_s2_opt2', widget.language), () => _nextStage()),
        ],
      ),
    );
  }

  // STAGE 3: MATEMATİK
  Widget _stage3Math() {
    return MissionCard(
      color: Colors.orangeAccent,
      header: "CALCULATE HALF-LIFE",
      story: AppTexts.get('l2_s3_story', widget.language),
      content: Column(children: [
        // Özel modern input fonksiyonunu burada çağırıyoruz
        _buildModernInput(
          controller: _s3Controller, 
          hint: AppTexts.get('l2_s3_input', widget.language), 
          color: Colors.orangeAccent
        ),
        const SizedBox(height: 20),
        _btn(AppTexts.get('check', widget.language), () {
           if (_s3Controller.text == "60") {
             _nextStage();
           } else {
             _error();
           }
        }, color: Colors.orangeAccent)
      ]),
    );
  }

  // YARDIMCI METODLAR
  Widget _btn(String t, VoidCallback onPressed, {Color color = Colors.greenAccent}) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: 16)
      ),
      onPressed: onPressed, 
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))
    ),
  );

  // Bu fonksiyonu sınıfın içine aldık, böylece AppStyles hatası vermeyecek
  Widget _buildModernInput({required TextEditingController controller, required String hint, required Color color}) {
    return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.black,
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.withValues(alpha: 0.3))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 2)
            )
        ));
  }
}