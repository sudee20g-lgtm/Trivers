import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import '../utils/game_data.dart';
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
          itemBuilder: (context, zoneIndex) =>
              _buildZoneSection(context, zoneIndex),
        ),
      ),
    );
  }

  Widget _buildZoneSection(BuildContext context, int zoneIndex) {
    String titleKey = 'zone_${zoneIndex + 1}_title';
    // Zone renklerini listeye aldık
    List<Color> zoneColors = [
      Colors.cyanAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.redAccent
    ];
    Color zoneColor = zoneColors[zoneIndex];

    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: zoneColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: zoneColor.withValues(alpha: 0.1), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppTexts.get(titleKey, widget.language),
              style: TextStyle(
                  color: zoneColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [Shadow(color: zoneColor, blurRadius: 10)])),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemCount: 4,
            itemBuilder: (context, index) {
              int globalLevel = (zoneIndex * 4) + index + 1;
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
                child: Container(
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? zoneColor.withValues(alpha: 0.2)
                        : Colors.grey[900],
                    border: Border.all(
                        color: isUnlocked
                            ? zoneColor
                            : Colors.grey.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isUnlocked
                          ? Text("$globalLevel",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : const Icon(Icons.lock,
                              color: Colors.grey, size: 20)),
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

    // MANUEL GEÇİŞ SİSTEMİ
    switch (level) {
      case 1:
        nextScreen = const Level1();
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
      // Yeni Leveller eklendikçe burası açılacak:
      // case 7: nextScreen = Level7(language: widget.language); break;
      // case 8: nextScreen = Level8(language: widget.language); break;
      default:
        // Eğer level dosyası yoksa işlem yapma
        return;
    }

    // nextScreen kesinlikle atandı, güvenle gidebiliriz
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
    _refresh();
  }
}