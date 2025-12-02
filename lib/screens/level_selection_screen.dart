import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/game_data.dart'; // Kilit sistemi
import '../levels/level_1.dart';
import '../levels/level_2.dart';
import '../levels/level_3.dart';
import '../levels/level_4.dart';

class LevelSelectionScreen extends StatefulWidget {
  final Future<void> Function() onResumeMusic;
  final String language;

  const LevelSelectionScreen({
    super.key,
    required this.onResumeMusic,
    required this.language,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  // Ekrana geri dönüldüğünde kilidin açıldığını görmek için yenileme
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0b0e17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
          onPressed: () {
            widget.onResumeMusic();
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppTexts.get('mission_select', widget.language),
          style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w900,
              letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/background_static.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.5), BlendMode.darken),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 50),
          itemCount: 4,
          itemBuilder: (context, zoneIndex) {
            return _buildZoneSection(context, zoneIndex);
          },
        ),
      ),
    );
  }

  Widget _buildZoneSection(BuildContext context, int zoneIndex) {
    String titleKey = 'zone_${zoneIndex + 1}_title';
    String title = AppTexts.get(titleKey, widget.language);

    Color zoneColor;
    switch (zoneIndex) {
      case 0:
        zoneColor = Colors.cyanAccent;
        break;
      case 1:
        zoneColor = Colors.blueAccent;
        break;
      case 2:
        zoneColor = Colors.purpleAccent;
        break;
      case 3:
        zoneColor = Colors.redAccent;
        break;
      default:
        zoneColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: zoneColor.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(color: zoneColor.withValues(alpha: 0.1), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Text(
              title,
              style: TextStyle(
                  color: zoneColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [Shadow(color: zoneColor, blurRadius: 10)]),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              int globalLevel = (zoneIndex * 4) + index + 1;

              // KİLİT MANTIĞI: GameData'dan kontrol et
              bool isUnlocked = globalLevel <= GameData.highestUnlockedLevel;

              return GestureDetector(
                onTap: isUnlocked
                    ? () => _openLevel(context, globalLevel)
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                AppTexts.get('locked_msg', widget.language)),
                            backgroundColor: Colors.red));
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                      color: isUnlocked
                          ? zoneColor.withValues(alpha: 0.2)
                          : Colors.grey[900],
                      border: Border.all(
                          color: isUnlocked
                              ? zoneColor
                              : Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                  color: zoneColor.withValues(alpha: 0.4),
                                  blurRadius: 8)
                            ]
                          : []),
                  child: Center(
                    child: isUnlocked
                        ? Text("$globalLevel",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))
                        : const Icon(Icons.lock, color: Colors.grey, size: 20),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openLevel(BuildContext context, int level) async {
    Widget nextScreen;
    switch (level) {
      case 1:
        nextScreen = Level1(language: widget.language);
        break;
      case 2:
        nextScreen = Level2(language: widget.language);
        break;
      case 3:
        nextScreen = Level3(language: widget.language);
        break;
      case 4:
        nextScreen = Level4(language: widget.language);
        break;
      default:
        return;
    }

    // Bölüme git ve geri gelmesini bekle (Geri gelince kilitleri güncellemek için)
    await Navigator.push(
        context, MaterialPageRoute(builder: (_) => nextScreen));
    _refresh(); // Sayfayı yenile ki yeni açılan kilit görünsün
  }
}
