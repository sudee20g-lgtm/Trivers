import 'package:flutter/material.dart';

class AppStyles {
  // Neon Çerçeve Deseni
  static BoxDecoration neonBox({Color color = Colors.cyanAccent}) {
    return BoxDecoration(
      color: Colors.black.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
      boxShadow: [
        BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2)
      ],
    );
  }

  // Hikaye Metni Stili
  static TextStyle storyStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    height: 1.5,
    fontFamily: 'Courier',
    shadows: [Shadow(color: Colors.blueAccent, blurRadius: 5)],
  );

  // Başlık Stili
  static TextStyle titleStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 22,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
      shadows: [Shadow(color: color, blurRadius: 15)],
    );
  }
}
