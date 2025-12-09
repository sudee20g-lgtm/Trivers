import 'package:flutter/foundation.dart'; // debugPrint için gerekli
import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  static int highestUnlockedLevel = 1;
  static bool isIntroSeen = false;

  static const String _levelKey = 'saved_level';
  static const String _introKey = 'intro_seen';

  // Verileri Yükle (GÜNCELLENDİ)
  static Future<void> loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      highestUnlockedLevel = prefs.getInt(_levelKey) ?? 1;
      isIntroSeen = prefs.getBool(_introKey) ?? false;
    } catch (e) {
      // Eğer tarayıcı depolama izni vermezse uygulama çökmesin diye hatayı yakalıyoruz.
      // Varsayılan değerlerle (Level 1) oyun açılacak.
      debugPrint("Kayıt verisi yüklenemedi (Storage Error): $e");
      highestUnlockedLevel = 1;
      isIntroSeen = false;
    }
  }

  // Seviye Kaydet (GÜNCELLENDİ)
  static Future<void> unlockNextLevel(int currentLevel) async {
    if (currentLevel >= highestUnlockedLevel) {
      highestUnlockedLevel = currentLevel + 1;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_levelKey, highestUnlockedLevel);
      } catch (e) {
        debugPrint("İlerleme kaydedilemedi: $e");
      }
    }
  }

  // İntro İzleme Kaydı (GÜNCELLENDİ)
  static Future<void> markIntroAsSeen() async {
    isIntroSeen = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_introKey, true);
    } catch (e) {
      debugPrint("Intro kaydı yapılamadı: $e");
    }
  }

  // Sıfırlama
  static Future<void> resetProgress() async {
    highestUnlockedLevel = 1;
    isIntroSeen = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_levelKey, 1);
      await prefs.setBool(_introKey, false);
    } catch (e) {
       debugPrint("Sıfırlama başarısız: $e");
    }
  }
}