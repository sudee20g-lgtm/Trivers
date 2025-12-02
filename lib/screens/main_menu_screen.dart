import 'package:flutter/material.dart';
import '../utils/app_texts.dart';
import 'introduction_screen.dart';
import 'purchase_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final bool isMuted;
  final String language;
  final VoidCallback onToggleMute;
  final Future<void> Function() onStopMusic;
  final Future<void> Function() onResumeMusic;
  final Function(String) onChangeLanguage;

  const MainMenuScreen({
    super.key,
    required this.isMuted,
    required this.language,
    required this.onToggleMute,
    required this.onStopMusic,
    required this.onResumeMusic,
    required this.onChangeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. ARKA PLAN
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gif/background.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. AYARLAR BUTONU (KÜÇÜLTÜLDÜ VE KÖŞEYE ALINDI)
          Positioned(
            top: 45, // Status barın hemen altına
            right: 15, // Köşeye iyice yanaştı
            child: GestureDetector(
              onTap: () => _showSettingsDialog(context),
              child: Container(
                padding: const EdgeInsets.all(8), // Çerçeve inceldi
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.cyanAccent.withValues(alpha: 0.5),
                      width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ],
                ),
                // İkon küçüldü (24 standart boyuttur)
                child: const Icon(Icons.settings,
                    color: Colors.cyanAccent, size: 24),
              ),
            ),
          ),

          // 3. ANA MENÜ BUTONLARI (ALT KISIM)
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // GENİŞ "OYNA" BUTONU
                _buildWideButton(
                  text: AppTexts.get('play', language),
                  onTap: () async {
                    await onStopMusic();
                    if (context.mounted) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IntroductionScreen(
                            language: language,
                            onResumeMusic: onResumeMusic,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 25),

                // YAN YANA "SATIN AL" ve "MOLA"
                Row(
                  children: [
                    Expanded(
                      child: _buildMenuButton(
                        text: AppTexts.get('buy', language),
                        isSecondary: true, // Mor renk
                        onTap: () async {
                          await onStopMusic();
                          if (context.mounted) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PurchaseScreen(language: language),
                              ),
                            );
                          }
                          await onResumeMusic();
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildMenuButton(
                        text: "MOLA",
                        isPause: true, // Turuncu renk
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(AppTexts.get('pause_msg', language)),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- AYARLAR PENCERESİ ---
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.cyanAccent, width: 2)),
        title: const Text(
          "AYARLAR / SETTINGS",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Colors.grey),
            // DİL SEÇİMİ
            ListTile(
              leading: const Icon(Icons.language, color: Colors.white),
              title: const Text("Dil / Language",
                  style: TextStyle(color: Colors.white)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _langOption(context, "TR"),
                  const SizedBox(width: 10),
                  _langOption(context, "EN"),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            // SES AÇ/KAPA
            ListTile(
              leading: Icon(isMuted ? Icons.volume_off : Icons.volume_up,
                  color: isMuted ? Colors.redAccent : Colors.greenAccent),
              title: Text(
                isMuted ? "Ses Kapalı / Muted" : "Ses Açık / Sound On",
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                onToggleMute();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("KAPAT",
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _langOption(BuildContext context, String code) {
    bool isSelected = language == code;
    return GestureDetector(
      onTap: () {
        onChangeLanguage(code);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: isSelected ? Colors.cyanAccent : Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected ? Colors.cyanAccent : Colors.grey)),
        child: Text(code,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- BUTON TASARIMLARI ---
  Widget _buildWideButton({required String text, required VoidCallback onTap}) {
    const Color neonColor = Colors.cyanAccent;
    final List<Color> glowColors = [
      Colors.purple,
      Colors.blue,
      Colors.greenAccent
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: neonColor, width: 3),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: glowColors[0].withValues(alpha: 0.8),
                blurRadius: 15,
                spreadRadius: 2),
            BoxShadow(
                color: glowColors[1].withValues(alpha: 0.6),
                blurRadius: 25,
                spreadRadius: 3),
            BoxShadow(
                color: glowColors[2].withValues(alpha: 0.5),
                blurRadius: 35,
                spreadRadius: 4),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: neonColor,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            shadows: [Shadow(color: neonColor, blurRadius: 10)],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required VoidCallback onTap,
    bool isSecondary = false,
    bool isPause = false,
  }) {
    final Color primaryColor = isSecondary
        ? Colors.purpleAccent
        : (isPause ? Colors.orangeAccent : Colors.cyanAccent);

    final Color glowColor =
        isSecondary ? Colors.purple : (isPause ? Colors.orange : Colors.cyan);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: glowColor.withValues(alpha: 0.7),
                blurRadius: 12,
                spreadRadius: 1.5),
            BoxShadow(
                color: primaryColor.withValues(alpha: 0.9),
                blurRadius: 5,
                spreadRadius: 0.5),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(color: primaryColor.withValues(alpha: 0.8), blurRadius: 8)
            ],
          ),
        ),
      ),
    );
  }
}
