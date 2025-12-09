import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  static int highestUnlockedLevel = 1;
  static bool isIntroSeen = false; // YENİ: Giriş izlendi mi kontrolü

  static const String _levelKey = 'saved_level';
  static const String _introKey = 'intro_seen'; // YENİ ANAHTAR

  // Verileri Yükle
  static Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    highestUnlockedLevel = prefs.getInt(_levelKey) ?? 1;
    isIntroSeen = prefs.getBool(_introKey) ?? false; // YENİ: Kayıtlı veriyi oku
  }

  // Seviye Kaydet
  static Future<void> unlockNextLevel(int currentLevel) async {
    if (currentLevel >= highestUnlockedLevel) {
      highestUnlockedLevel = currentLevel + 1;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_levelKey, highestUnlockedLevel);
    }
  }

  // YENİ: İntroyu izlendi olarak işaretle
  static Future<void> markIntroAsSeen() async {
    isIntroSeen = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introKey, true);
  }
  
  // Sıfırlama (Geliştirici için)
  static Future<void> resetProgress() async {
    highestUnlockedLevel = 1;
    isIntroSeen = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelKey, 1);
    await prefs.setBool(_introKey, false);
  }
}