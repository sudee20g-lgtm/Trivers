import 'package:shared_preferences/shared_preferences.dart';

class GameData {
  // Varsayılan olarak 1. seviye açık
  static int highestUnlockedLevel = 1;
  static const String _storageKey = 'saved_level';

  // Uygulama açılırken kayıtlı veriyi yükle
  static Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    // Kayıtlı veri varsa onu al, yoksa 1 yap
    highestUnlockedLevel = prefs.getInt(_storageKey) ?? 1;
  }

  // Seviye atlayınca kaydet
  static Future<void> unlockNextLevel(int currentLevel) async {
    if (currentLevel >= highestUnlockedLevel) {
      highestUnlockedLevel = currentLevel + 1;
      
      // Kalıcı hafızaya yaz
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_storageKey, highestUnlockedLevel);
    }
  }
  
  // (İsteğe bağlı) Oyunu sıfırlamak istersen kullanacağın method
  static Future<void> resetProgress() async {
    highestUnlockedLevel = 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, 1);
  }
}