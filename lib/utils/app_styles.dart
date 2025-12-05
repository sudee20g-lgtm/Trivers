import 'package:flutter/material.dart';

class AppStyles {
  // --- MODERN "FROZEN GLASS" KUTU TASARIMI (Aynı Kaldı) ---
  static BoxDecoration neonBox({Color color = Colors.cyanAccent}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: 0.15),
          Colors.black.withValues(alpha: 0.85),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
          color: color.withValues(alpha: 0.6), 
          width: 1.5),
      boxShadow: [
        BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 30,
            spreadRadius: 5),
        BoxShadow(
            color: Colors.black.withValues(alpha: 1.0),
            blurRadius: 15,
            offset: const Offset(0, 10)),
        BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: -2),
      ],
    );
  }

  // --- HİKAYE METNİ (Kutuların içi) ---
  static TextStyle storyStyle = const TextStyle(
    color: Color(0xFFF0F0F0),
    fontSize: 17,
    height: 1.5,
    fontFamily: 'Courier',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    shadows: [
      Shadow(color: Colors.black, blurRadius: 3, offset: Offset(1, 1)),
    ],
  );

  // --- LORE / SONUÇ YAZISI (DÜZELTİLDİ: YEŞİL GERİ GELDİ) ---
  // Artık rengi (color) neyse (Yeşil, Mor, Mavi) yazı o renk olacak.
  static TextStyle loreStyle(Color color) {
    return TextStyle(
      color: color, // DÜZELTME: Yazı artık beyaz değil, kendi renginde (Örn: Yeşil)
      fontSize: 17, // Okunabilir boyut
      height: 1.4,
      fontFamily: 'Courier',
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0, 
      shadows: [
        // Kendi renginde güçlü bir parlama (Glow)
        Shadow(color: color.withValues(alpha: 0.8), blurRadius: 15),
        Shadow(color: color.withValues(alpha: 0.4), blurRadius: 5),
        // Kontrast için ince siyah gölge
        const Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1)),
      ],
    );
  }

  // --- BAŞLIK STİLİ ---
  static TextStyle titleStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 24,
      fontWeight: FontWeight.w900,
      fontFamily: 'Courier',
      letterSpacing: 6.0,
      shadows: [
        Shadow(color: color.withValues(alpha: 0.5), blurRadius: 20),
        Shadow(color: Colors.black, blurRadius: 2, offset: Offset(2, 2)),
      ],
    );
  }

  // --- INPUT ALANI ---
  static InputDecoration inputDecoration(String hint, Color color) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.6),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30, fontFamily: 'Courier'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: color, width: 2),
      ),
    );
  }
}