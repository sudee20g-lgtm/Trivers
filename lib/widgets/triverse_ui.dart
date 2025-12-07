import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/app_styles.dart';

// --- BUZUL / KRİSTAL EFEKTLİ KUTU DEKORASYONU ---
BoxDecoration iceCrystalDecoration({Color color = Colors.cyanAccent, bool isFocused = false}) {
  return BoxDecoration(
    color: const Color(0xFF051015).withOpacity(0.85), // Koyu buz mavisi zemin
    border: Border.all(
      color: isFocused ? Colors.white : color.withOpacity(0.6), // Odaklanınca beyaz parlar
      width: isFocused ? 2 : 1.5
    ),
    // Keskin köşeler (Kristal hissi için radius düşük)
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
      topRight: Radius.circular(2), // Keskin
      bottomLeft: Radius.circular(2), // Keskin
    ),
    boxShadow: [
      // İçten dışa doğru soğuk bir parlama
      BoxShadow(color: color.withOpacity(0.15), blurRadius: 15, spreadRadius: 2),
      if (isFocused) BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 20, spreadRadius: 1),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.1),
        Colors.transparent,
        color.withOpacity(0.05),
      ],
      stops: const [0.0, 0.5, 1.0],
    ),
  );
}

class TriverseScaffold extends StatelessWidget {
  final String title;
  final String levelName;
  final Color themeColor;
  final Widget child;
  final VoidCallback? onBack;

  const TriverseScaffold({
    super.key,
    required this.title,
    required this.levelName,
    required this.themeColor,
    required this.child,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020205), // Zifiri karanlık
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Arkaplan: Soğuk Gradyan
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.3,
                  colors: [
                    themeColor.withOpacity(0.15),
                    const Color(0xFF000000),
                  ],
                ),
              ),
            ),
          ),
          // 2. Buzlanma Efekti (Vignette)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: themeColor.withOpacity(0.1), width: 0),
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.9,
                    colors: [Colors.transparent, themeColor.withOpacity(0.2)],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: child, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: themeColor),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          Column(
            children: [
               Icon(Icons.ac_unit, color: themeColor.withOpacity(0.7), size: 16),
               const SizedBox(height: 4),
               Text(title, style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontWeight: FontWeight.bold, letterSpacing: 2)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: themeColor.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Text(levelName, style: TextStyle(color: themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// --- YENİLENEN MISSION CARD (KRİSTAL GÖRÜNÜM) ---
class MissionCard extends StatelessWidget {
  final String header;
  final String story;
  final Widget content; 
  final Color color;
  final bool isLog; 

  const MissionCard({
    super.key,
    required this.header,
    required this.story,
    required this.content,
    required this.color,
    this.isLog = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: iceCrystalDecoration(color: color),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        child: SingleChildScrollView( 
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Başlık Alanı (Buzlu Cam)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  border: Border(bottom: BorderSide(color: color.withOpacity(0.3))),
                ),
                child: Row(
                  children: [
                    Icon(isLog ? Icons.record_voice_over : Icons.memory, color: color, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(header.toUpperCase(), 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Courier', letterSpacing: 1.2, fontSize: 15, shadows: [Shadow(color: color, blurRadius: 10)]),
                      ),
                    ),
                  ],
                ),
              ),

              // Hikaye Metni
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  story,
                  style: TextStyle(
                    color: isLog ? Colors.cyanAccent.shade100 : const Color(0xFFDDDDDD),
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'Courier',
                    fontStyle: isLog ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
              
              if(!isLog) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: color.withOpacity(0.2)),
              ),

              // İçerik (Butonlar/Bulmacalar)
              Padding(
                padding: const EdgeInsets.all(20),
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- TAM EKRAN HİKAYE (KRİSTAL TEMA) ---
void showFullStoryDialog({
  required BuildContext context,
  required String title,
  required String logCode,
  required String storyText,
  required Color color,
  required VoidCallback onContinue,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (ctx, anim1, anim2) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Arkaplan Blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                decoration: iceCrystalDecoration(color: color).copyWith(
                  boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 40, spreadRadius: 5)]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ENCRYPTED_LOG // $logCode", style: TextStyle(color: color.withOpacity(0.6), fontFamily: 'Courier', fontSize: 12)),
                        Icon(Icons.lock_open, color: color, size: 18),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(title, style: AppStyles.titleStyle(color).copyWith(fontSize: 24, shadows: [Shadow(color: color, blurRadius: 15)])),
                    const SizedBox(height: 20),
                    Divider(color: color.withOpacity(0.4)),
                    const SizedBox(height: 20),
                    
                    // Metin Alanı
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          storyText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18, 
                            fontFamily: 'Courier',
                            height: 1.6,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Buton
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.withOpacity(0.1),
                          side: BorderSide(color: color),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                          elevation: 0,
                        ),
                        onPressed: onContinue,
                        child: Text("BAĞLANTIYI KES VE İLERLE >", style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1, fontFamily: 'Courier')),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}