class GameData {
  // Başlangıçta sadece 1. seviye açık
  static int highestUnlockedLevel = 1;

  static void unlockNextLevel(int currentLevel) {
    if (currentLevel >= highestUnlockedLevel) {
      highestUnlockedLevel = currentLevel + 1;
    }
  }
}
